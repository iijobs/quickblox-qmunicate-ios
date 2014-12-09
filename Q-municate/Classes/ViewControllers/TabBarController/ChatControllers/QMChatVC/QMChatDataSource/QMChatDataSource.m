//

//  QMChatDataSource.m
//  Q-municate
//
//  Created by Andrey Ivanov on 16.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMChatDataSource.h"
#import "QMDBStorage+Messages.h"
#import "QMMessage.h"
#import "QMApi.h"
#import "SVProgressHUD.h"
#import "QMChatReceiver.h"
#import "QMContentService.h"
#import "QMTextMessageCell.h"
#import "QMSystemMessageCell.h"
#import "QMAttachmentMessageCell.h"
#import "QMSoundManager.h"
#import "QMChatSection.h"

@interface QMChatDataSource()

<UITableViewDataSource, QMChatCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatSections;

/**
 *  Specifies whether or not the view controller should automatically scroll to the most recent message
 *  when the view appears and when sending, receiving, and composing a new message.
 *
 *  @discussion The default value is `YES`, which allows the view controller to scroll automatically to the most recent message.
 *  Set to `NO` if you want to manage scrolling yourself.
 */
@property (assign, nonatomic) BOOL automaticallyScrollsToMostRecentMessage;

@end

@implementation QMChatDataSource

- (void)dealloc {
    [[QMChatReceiver instance] unsubscribeForTarget:self];
    ILog(@"%@ - %@", NSStringFromSelector(_cmd), self);
}

- (instancetype)initWithChatDialog:(QBChatDialog *)dialog forTableView:(UITableView *)tableView {
    
    self = [super init];
    
    if (self) {
        
        self.chatDialog = dialog;
        self.tableView = tableView;
        self.chatSections = [NSMutableArray array];
        
        self.automaticallyScrollsToMostRecentMessage = YES;
        
        tableView.dataSource = self;
        [tableView registerClass:[QMTextMessageCell class] forCellReuseIdentifier:QMTextMessageCellID];
        [tableView registerClass:[QMAttachmentMessageCell class] forCellReuseIdentifier:QMAttachmentMessageCellID];
        [tableView registerClass:[QMSystemMessageCell class] forCellReuseIdentifier:QMSystemMessageCellID];
        
        __weak __typeof(self)weakSelf = self;
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [[QMApi instance] fetchMessageWithDialog:self.chatDialog complete:^(BOOL success) {
            
            [weakSelf reloadCachedMessages:NO];
            [SVProgressHUD dismiss];
            
        }];
        
        [[QMChatReceiver instance] chatAfterDidReceiveMessageWithTarget:self block:^(QBChatMessage *message) {
            
            QBChatDialog *dialogForReceiverMessage = [[QMApi instance] chatDialogWithID:message.cParamDialogID];
            
            if ([weakSelf.chatDialog isEqual:dialogForReceiverMessage] && message.cParamNotificationType == QMMessageNotificationTypeNone) {
                
                if (message.senderID != [QMApi instance].currentUser.ID) {
                    [QMSoundManager playMessageReceivedSound];
                    
                    [weakSelf insertNewMessage:message];
                }
                
            }
            else if (message.cParamNotificationType == QMMessageNotificationTypeDeliveryMessage ){
            }
            
        }];
    }
    
    return self;
}

- (QMChatSection *)chatSectionForDate:(NSDate *)date
{
    NSInteger identifer = [QMChatSection daysBetweenDate:date andDate:[NSDate date]];
    for (QMChatSection *section in self.chatSections) {
        if (identifer == section.identifier) {
            return section;
        }
    }
    QMChatSection *newSection = [[QMChatSection alloc] initWithDate:date];
    [self.chatSections addObject:newSection];
    return newSection;
}

- (void)insertNewMessage:(QBChatMessage *)message {
    
    QMMessage *qmMessage = [self qmMessageWithQbChatHistoryMessage:message];
    
    QMChatSection *chatSection = [self chatSectionForDate:qmMessage.datetime];
    [chatSection addMessage:qmMessage];
    
    [self.tableView beginUpdates];
    if (chatSection.messages.count > 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:chatSection.messages.count-1 inSection:self.chatSections.count-1];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.chatSections.count-1] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView endUpdates];
    
    [self scrollToBottomAnimated:YES];
}

- (void)reloadCachedMessages:(BOOL)animated {
    
    NSArray *history = [[QMApi instance] messagesHistoryWithDialog:self.chatDialog];
    
    [self.chatSections removeAllObjects];
    self.chatSections = [self sortedChatSectionsFromMessageArray:history];
    
    [self.tableView reloadData];
    [self scrollToBottomAnimated:animated];
}

// ******************************************************************************
- (NSMutableArray *)sortedChatSectionsFromMessageArray:(NSArray *)messagesArray
{
    NSMutableArray *arrayOfSections = [[NSMutableArray alloc] init];
    NSMutableDictionary *sectionsDictionary = [NSMutableDictionary new];
    NSDate *dateNow = [NSDate date];
    
    for (QBChatHistoryMessage *historyMessage in messagesArray) {
        QMMessage *qmMessage = [self qmMessageWithQbChatHistoryMessage:historyMessage];
        NSNumber *key = @([QMChatSection daysBetweenDate:historyMessage.datetime andDate:dateNow]);
        QMChatSection *section = sectionsDictionary[key];
        if (!section) {
            section = [[QMChatSection alloc] initWithDate:qmMessage.datetime];
            sectionsDictionary[key] = section;
            [arrayOfSections addObject:section];
            
        }
        [section addMessage:qmMessage];
        
    }
    return arrayOfSections;
}
// *******************************************************************************

- (void)scrollToBottomAnimated:(BOOL)animated {
    
    if (self.chatSections.count > 0) {
        QMChatSection *chatSection = [self.chatSections lastObject];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:chatSection.messages.count-1 inSection:self.chatSections.count-1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

- (NSString *)cellIDAtQMMessage:(QMMessage *)message {
    
    switch (message.type) {
            
        case QMMessageTypeSystem: return QMSystemMessageCellID; break;
        case QMMessageTypePhoto: return QMAttachmentMessageCellID; break;
        case QMMessageTypeText: return QMTextMessageCellID; break;
        default: NSAssert(nil, @"Need update this case"); break;
    }
}

- (QMMessage *)qmMessageWithQbChatHistoryMessage:(QBChatAbstractMessage *)historyMessage {
    
    QMMessage *message = [[QMMessage alloc] initWithChatHistoryMessage:historyMessage];
    BOOL fromMe = ([QMApi instance].currentUser.ID == historyMessage.senderID);
    
    message.minWidth = fromMe || (message.chatDialog.type == QBChatDialogTypePrivate) ? 78 : -1;
    message.align =  fromMe ? QMMessageContentAlignRight : QMMessageContentAlignLeft;
    
    return message;
}

#pragma mark - Abstract methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    QMChatSection *chatSection = self.chatSections[section];
    NSAssert(chatSection, @"Section not found. Check this case");
    return ([chatSection.messages count] > 0) ? chatSection.name : nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.chatSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QMChatSection *chatSection = self.chatSections[section];
    return chatSection.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QMChatSection *chatSection = self.chatSections[indexPath.section];
    QMMessage *message = chatSection.messages[indexPath.row];
    QMChatCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIDAtQMMessage:message]];
    
    cell.delegate = self;
    
    BOOL isMe = [QMApi instance].currentUser.ID == message.senderID;
    QBUUser *user = [[QMApi instance] userWithID:message.senderID];
    [cell setMessage:message user:user isMe:isMe];
    
    return cell;
}

#pragma mark - Send actions

- (void)sendImage:(UIImage *)image {
    
    __weak __typeof(self)weakSelf = self;
    
    [SVProgressHUD showProgress:0 status:nil maskType:SVProgressHUDMaskTypeClear];
    [[QMApi instance].contentService uploadJPEGImage:image progress:^(float progress) {
        
        [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
        
    } completion:^(QBCFileUploadTaskResult *result) {
        
        if (result.success) {
            
            [[QMApi instance] sendAttachment:result.uploadedBlob.publicUrl toDialog:weakSelf.chatDialog completion:^(QBChatMessage *message) {
                [weakSelf insertNewMessage:message];
            }];
        }
        
        [SVProgressHUD dismiss];
    }];
}

- (void)sendMessage:(NSString *)text {
    
    __weak __typeof(self)weakSelf = self;
    [[QMApi instance] sendText:text toDialog:self.chatDialog completion:^(QBChatMessage *message) {
        
        [QMSoundManager playMessageSentSound];
        [weakSelf insertNewMessage:message];
    }];
}

#pragma mark - QMChatCellDelegate

#define USE_ATTACHMENT_FROM_CACHE 1

- (void)chatCell:(id)cell didSelectMessage:(QMMessage *)message {
    
    if ([cell isKindOfClass:[QMAttachmentMessageCell class]]) {
#if USE_ATTACHMENT_FROM_CACHE
        QMAttachmentMessageCell *imageCell = cell;
        
        if ([self.delegate respondsToSelector:@selector(chatDatasource:prepareImageAttachement:fromView:)]) {
            
            UIImageView *imageView = (UIImageView *)imageCell.balloonImageView;
            UIImage *image  = imageView.image;
            
            [self.delegate chatDatasource:self prepareImageAttachement:image fromView:imageView];
        }
#else
        if ([self.delegate respondsToSelector:@selector(chatDatasource:prepareImageURLAttachement:)]) {
            
            QBChatAttachment *attachment = [message.attachments firstObject];
            NSURL *url = [NSURL URLWithString:attachment.url];
            [self.delegate chatDatasource:self prepareImageURLAttachement:url];
        }
#endif
    }
}

@end
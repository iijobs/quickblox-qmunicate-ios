//
//  QBChatAbstractMessage+CustomParameters.m
//  Qmunicate
//
//  Created by Andrey Ivanov on 24.07.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QBChatAbstractMessage+CustomParameters.h"

/*Message keys*/
NSString const *kQMCustomParameterSaveToHistory = @"save_to_history";
NSString const *kQMCustomParameterNotificationType = @"notification_type";
NSString const *kQMCustomParameterChatMessageID = @"chat_message_id";
NSString const *kQMCustomParameterDateSent = @"date_sent";
NSString const *kQMCustomParameterChatMessageDeliveryStatus = @"message_delivery_status_read";
/*Dialogs keys*/
NSString const *kQMCustomParameterDialogID = @"dialog_id";
NSString const *kQMCustomParameterRoomJID = @"room_jid";
NSString const *kQMCustomParameterDialogName = @"name";
NSString const *kQMCustomParameterDialogType = @"type";
NSString const *kQMCustomParameterDialogOccupantsIDs = @"occupants_ids";

@interface QBChatAbstractMessage (Context)

@property (strong, nonatomic) NSMutableDictionary *context;

@end

@implementation QBChatAbstractMessage (CustomParameters)

/*Message params*/
@dynamic cParamSaveToHistory;
@dynamic cParamNotificationType;
@dynamic cParamChatMessageID;
@dynamic cParamDateSent;
@dynamic cParamMessageDeliveryStatus;

/*dialog info params*/
@dynamic cParamDialogID;
@dynamic cParamRoomJID;
@dynamic cParamDialogName;
@dynamic cParamDialogType;
@dynamic cParamDialogOccupantsIDs;

- (NSMutableDictionary *)context {
    
    if (!self.customParameters) {
        self.customParameters = [NSMutableDictionary dictionary];
    }
    return self.customParameters;
}

#pragma mark - cParamChatMessageID

- (void)setCParamChatMessageID:(NSString *)cParamChatMessageID {
    self.context[kQMCustomParameterChatMessageID] = cParamChatMessageID;
}

- (NSString *)cParamChatMessageID {
    
    return self.context[kQMCustomParameterChatMessageID];
}

#pragma mark - cParamDateSent

- (void)setCParamDateSent:(NSNumber *)cParamDateSent {
    self.context[kQMCustomParameterDateSent] = cParamDateSent;
}

- (NSNumber *)cParamDateSent {
    return self.context[kQMCustomParameterDateSent];
}

#pragma mark - cParamDialogID

- (void)setCParamDialogID:(NSString *)cParamDialogID {
    self.context[kQMCustomParameterDialogID] = cParamDialogID;
}

- (NSString *)cParamDialogID {
    return self.context[kQMCustomParameterDialogID];
}

#pragma mark - cParamSaveToHistory

- (void)setCParamSaveToHistory:(NSString *)cParamSaveToHistory {
    self.context[kQMCustomParameterSaveToHistory] = cParamSaveToHistory;
}

- (NSString *)cParamSaveToHistory {
    return self.context[kQMCustomParameterSaveToHistory];
}

#pragma mark - cParamRoomJID

- (void)setCParamRoomJID:(NSString *)cParamRoomJID {
    self.context[kQMCustomParameterRoomJID] = cParamRoomJID;
}

- (NSString *)cParamRoomJID {
    return self.context[kQMCustomParameterRoomJID];
}

#pragma mark - cParamDialogType

- (void)setCParamDialogType:(NSNumber *)cParamDialogType {
    self.context[kQMCustomParameterDialogType] = cParamDialogType;
}

- (NSNumber *)cParamDialogType {
    return self.context[kQMCustomParameterDialogType];
}

#pragma mark - cParamDialogName

- (void)setCParamDialogName:(NSString *)cParamDialogName {
    self.context[kQMCustomParameterDialogName] = cParamDialogName;
}

- (NSString *)cParamDialogName {
    return self.context[kQMCustomParameterDialogName];
}

#pragma mark - cParamDialogOccupantsIDs

- (void)setCParamDialogOccupantsIDs:(NSArray *)cParamDialogOccupantsIDs {
    
    NSString *strIDs = [cParamDialogOccupantsIDs componentsJoinedByString:@","];
    self.context[kQMCustomParameterDialogOccupantsIDs] = strIDs;
}

- (NSArray *)cParamDialogOccupantsIDs {
    
    NSString * strIDs = self.context[kQMCustomParameterDialogOccupantsIDs];
    
    NSArray *componets = [strIDs componentsSeparatedByString:@","];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:componets.count];

    for (NSString *occupantID in componets) {
        [result addObject:@(occupantID.integerValue)];
    }
    
    return result;
}

#pragma mark - cParamNotificationType

- (void)setCParamNotificationType:(QMMessageNotificationType)cParamNotificationType {

    self.context[kQMCustomParameterNotificationType] = @(cParamNotificationType);
}

- (QMMessageNotificationType)cParamNotificationType {
    return [self.context[kQMCustomParameterNotificationType] integerValue];
}

#pragma mark - cParamMessageDeliveryStatus

- (void)setCParamMessageDeliveryStatus:(BOOL)cParamMessageDeliveryStatus {
    self.context[kQMCustomParameterChatMessageDeliveryStatus] = @(cParamMessageDeliveryStatus);
}

- (BOOL)cParamMessageDeliveryStatus {
    return [self.context[kQMCustomParameterChatMessageDeliveryStatus] boolValue];
}

#pragma mark - QBChatDialog

- (void)setCustomParametersWithChatDialog:(QBChatDialog *)chatDialog {
    
    self.cParamDialogID = chatDialog.ID;
    
    if (chatDialog.type == QBChatDialogTypeGroup) {
        self.cParamRoomJID = chatDialog.roomJID;
        self.cParamDialogName = chatDialog.name;
    }
    
    self.cParamDialogType = @(chatDialog.type);
    self.cParamDialogOccupantsIDs = chatDialog.occupantIDs;
}

- (QBChatDialog *)chatDialogFromCustomParameters {

    QBChatDialog *chatDialog = [[QBChatDialog alloc] init];
    chatDialog.ID = self.cParamDialogID;
    chatDialog.roomJID = self.cParamRoomJID;
    chatDialog.name = self.cParamDialogName;
    chatDialog.occupantIDs = self.cParamDialogOccupantsIDs;
    chatDialog.type = self.cParamDialogType.integerValue;
    chatDialog.lastMessageDate = [NSDate dateWithTimeIntervalSince1970:self.cParamDateSent.doubleValue];
    
    return chatDialog;
}

@end

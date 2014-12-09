//
//  QMChatGroupService.h
//  Qmunicate
//
//  Created by Andrey Ivanov on 02.07.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMBaseService.h"

@interface QMChatDialogsService : QMBaseService

- (void)fetchAllDialogs:(QBDialogsPagedResultBlock)completion;
- (void)createChatDialog:(QBChatDialog *)chatDialog completion:(QBChatDialogResultBlock)completionl;
- (void)updateChatDialogWithID:(NSString *)dialogID extendedRequest:(NSMutableDictionary *)extendedRequest completion:(QBChatDialogResultBlock)completion;
//- (void)updateChatDialog:(QBChatDialog *)chatDialog;

- (NSArray *)dialogHistory;
- (void)addDialogToHistory:(QBChatDialog *)chatDialog;
- (void)addDialogs:(NSArray *)dialogs;
- (QBChatDialog *)privateDialogWithOpponentID:(NSUInteger)opponentID;
- (QBChatDialog *)chatDialogWithID:(NSString *)dialogID;
- (QBChatRoom *)chatRoomWithRoomJID:(NSString *)roomJID;

- (void)leaveFromRooms;
- (void)joinRooms;

@end

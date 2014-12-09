//
//  QBRequest+QBChat.h
//  Quickblox
//
//  Created by Anton Sokolchenko on 9/1/14.
//  Copyright (c) 2014 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBRequest.h"

@class QBResponsePage;
@class QBChatHistoryMessage;
@class QBChatDialog;
@class QBUpdateDialogParameters;

@interface QBRequest (QBChat)


/**
 Retrieve chat dialogs
 
 @param successBlock Block with response instance and arrays of chat dialogs and chat dialogs users IDs if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)dialogsWithSuccessBlock:(void(^)(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Retrieve chat dialogs for page
 
 @param successBlock Block with response instance, arrays of chat dialogs and chat dialogs users IDs and page instance if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)dialogsForPage:(QBResponsePage *)page successBlock:(void(^)(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, QBResponsePage *page))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Create chat dialog
 
 @param dialog chat dialog instance
 @param successBlock Block with response and created chat dialog instances if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)createDialog:(QBChatDialog *)dialog successBlock:(void(^)(QBResponse *response, QBChatDialog *createdDialog))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Update existing chat dialog
 
 @param updateDialogParameters Set of dialog parameters to update
 @param successBlock Block with response and updated chat dialog instances if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)updateDialog:(QBUpdateDialogParameters *)updateDialogParameters successBlock:(void(^)(QBResponse *response, QBChatDialog *updatedDialog))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Retrieve first 100 chat messages within particular dialog
 
 @param dialogID ID of a dialog
 @param successBlock Block with response instance and array of chat messages if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)messagesWithDialogID:(NSString *)dialogID successBlock:(void(^)(QBResponse *response, NSArray *messages))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Retrieve chat messages within particular dialog for page
 
 @param dialogID ID of a dialog
 @param page response page instance
 @param successBlock Block with response instance and array of chat messages for page if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)messagesWithDialogID:(NSString *)dialogID forPage:(QBResponsePage *)page successBlock:(void (^)(QBResponse *response, NSArray *messages, QBResponsePage *page))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Create chat message
 
 @param message chat message
 @param successBlock Block with response and chat message instances if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)createMessage:(QBChatHistoryMessage *)message successBlock:(void(^)(QBResponse *response, QBChatHistoryMessage *createdMessage))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Update existing chat message - mark it as read
 
 @param message chat message to update
 @param successBlock Block with response instance if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)updateMessage:(QBChatHistoryMessage *)message successBlock:(void(^)(QBResponse *response))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Mark messages as read
 
 @param dialogID dialog ID
 @param messageIDs array of chat message IDs to mark as read
 @param successBlock Block with response instance if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)markMessagesAsRead:(NSArray *)messageIDs dialogID:(NSString *)dialogID successBlock:(void(^)(QBResponse *response))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

/**
 Delete existing chat message
 
 @param messageID message ID to delete
 @param successBlock Block with response instance if request succeded
 @param errorBlock Block with response instance if request failed
 @return An instance, which conforms Cancelable protocol. Use this instance to cancel the operation.
 */
+ (QBRequest *)deleteMessageWithID:(NSString *)messageID successBlock:(void(^)(QBResponse *response))successBlock errorBlock:(QBRequestErrorBlock)errorBlock;

@end

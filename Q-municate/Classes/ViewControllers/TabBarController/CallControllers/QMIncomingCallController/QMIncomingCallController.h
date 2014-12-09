//
//  QMIncomingCallController.h
//  Q-municate
//
//  Created by Igor Alefirenko on 08/04/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMIncomingCallHandler;


@interface QMIncomingCallController : UIViewController

@property (strong, nonatomic) QMIncomingCallHandler *callsHandler;

@property (assign, nonatomic) NSUInteger opponentID;
@property (assign, nonatomic) enum QBVideoChatConferenceType callType;
@property (strong, nonatomic) QBUUser *opponent;

- (void)setCallStatus:(NSString *)callStatus;

@end

//
//  QMSettingsManager.h
//  Qmunicate
//
//  Created by Andrey Ivanov on 24.06.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QMAccountType) {
    QMAccountTypeNone,
    QMAccountTypeEmail,
    QMAccountTypeFacebook
};

@interface QMSettingsManager : NSObject

@property (assign, nonatomic) QMAccountType accountType;

/**
 Licence Agreement accepted
 */
@property (assign, nonatomic) BOOL userAgreementAccepted;

/**
 * User login
 */
@property (strong, nonatomic, readonly) NSString *login;

/**
 * User password
 */
@property (strong, nonatomic, readonly) NSString *password;

/**
 * User status
 */
@property (strong, nonatomic) NSString *userStatus;

/**
 * Push notifcation enable (Default YES)
 */
@property (assign, nonatomic) BOOL pushNotificationsEnabled;

/**
 * Remember user login and password
 */
@property (assign, nonatomic) BOOL rememberMe;

/**
 * First facebook login flag. Needed for import FB friends from Quickblox.
 */
@property (assign, nonatomic, getter = isFirstFacebookLogin) BOOL firstFacebookLogin;


- (void)setLogin:(NSString *)login andPassword:(NSString *)password;
/**
 * Set Default settings
 */
- (void)clearSettings;
- (void)defaultSettings;

@end

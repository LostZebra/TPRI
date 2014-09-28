//
//  LoginClient.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/22.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^loginCompletionHandler)(BOOL isSuccess, NSError *error);
typedef void (^logoutCompletionHandler)(BOOL isSuccess, NSError *error);

typedef NS_ENUM(NSInteger, LoginResponseError)
{
    NO_USERNAME_EXIST = 0x0001,
    USERNAME_PASSWORD_UNMATCH,
    LOGIN_DATABASE_ERROR
};

typedef NS_ENUM(NSInteger, LogoutResponseError)
{
    LOGINOUT_REFUSED = 0x0001,
    LOGOUT_DATABASE_ERROR
};

@interface LoginClient : NSObject

- (void)loginUsing:(NSString *)usrName password:(NSString *)password completionHandler:(loginCompletionHandler)completionHandler;

@end

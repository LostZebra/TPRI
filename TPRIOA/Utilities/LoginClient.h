//
//  LoginClient.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/22.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LoginClient : NSObject

- (void)loginUsing:(NSString *)usrName password:(NSString *)password completionHandler:(void (^)(bool isSuccess))cb;

@end

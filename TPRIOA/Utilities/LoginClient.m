//
//  LoginClient.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/22.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "LoginClient.h"

@implementation LoginClient

- (id)init
{
    self =  [super init];
    if (self) {
        //NSLog(@"Login client initiated!");
    }
    return self;
}

- (void)loginUsing:(NSString *)usrName password:(NSString *)password completionHandler:(loginCompletionHandler)completionHandler
{
    dispatch_queue_t asyncQueue = dispatch_get_main_queue();
    dispatch_async(asyncQueue, ^{
        // 这里实现登录的Http调用
        // ...
        // 启动异步现成完成登录,得到登录结果后完成回调
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^(void)
                       {
                           NSError *loginError = nil;
                           completionHandler(YES, loginError);
                       });
    });
}

@end

//
//  DataFetchingClient.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "DataFetchingClient.h"

@implementation DataFetchingClient

- (void)fetchDataInto:(NSMutableArray *)array completionHandler:(void (^)(void))cb
{
    dispatch_queue_t asyncQueue = dispatch_get_main_queue();
    dispatch_async(asyncQueue, ^{
        // 这里实现获取数据的Http调用
        // ...
        // 启动异步现成完成数据获取,得到结果后完成回调
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
        dispatch_after(delay, dispatch_get_main_queue(), ^(void)
                       {
                           for (int i = 1; i <= 100; i++) {
                               [array addObject:[NSNumber numberWithInt:i]];
                           }
                           cb();
                       });
    });
}

@end

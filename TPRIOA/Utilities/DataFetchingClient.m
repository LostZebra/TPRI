//
//  DataFetchingClient.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "DataFetchingClient.h"

@implementation DataFetchingClient

// This utility class might be disabled when webservice is available
- (void)fetchDataIntoArray:(NSMutableArray *)array completionHandler:(void (^)(void))cb
{
    // 这里实现获取数据的Http调用
    // ...
    // 启动异步现成完成数据获取,得到结果后完成回调
    for (int i = 1; i <= 20; i++) {
        [array addObject:@"西安华能集团有限公司伞塔路热工研究院200吨级煤发电项目"];
    }
    cb();
}

- (void)fetchDataIntoDictionary:(NSMutableDictionary *)dictionary completionHandler:(void (^)(void))cb
{
    // 这里实现获取数据的Http调用
    // ...
    // 启动异步现成完成数据获取,得到结果后完成回调
    [dictionary setValue:@[@"设备名称", @"处所审核", @"2014-06-25 09:50:35", @"2014-06-25 09:50:35"] forKey:@"采购合同"];
    cb();
}

@end

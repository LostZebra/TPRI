//
//  DataFetchingClient.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetchingClient : NSObject

- (void)fetchDataIntoArray: (NSMutableArray *)array completionHandler: (void (^)(void))cb;

- (void)fetchDataIntoDictionary:(NSMutableDictionary *)dictionary completionHandler:(void (^)(void))cb;

@end

//
//  BaseUIProtocol.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseUIProtocol <NSObject>

@optional
- (void)prepareData;
- (void)storeDataBackLocally;
- (void)storeDataBackLocallyUsingArray:(NSArray *)dataArray;
- (void)storeDataBackLocallyUsingDictionary:(NSDictionary *)dictionary;
- (void)prepareUIElements;

@required
- (void)buildNavigationBar;
- (void)buildConstraintsOnUIElements;

@end

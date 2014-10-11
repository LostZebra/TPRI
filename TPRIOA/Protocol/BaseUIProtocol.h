//
//  BaseUIProtocol.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^prepareDataAsyncCompletionHandler)(BOOL isSuccess, NSError *error);

@protocol BaseUIProtocol <NSObject>

@optional
/**
 调用UserDefaults进行简短的本地数据存储
 */
- (void)storeDataBackLocally;
/**
 调用UserDefaults进行简短的本地数据存储,要存储的本地数据放置在NSArray中
 @params dataArray 要存储到本地的数据
 */
- (void)storeDataBackLocallyUsingArray:(NSArray *)dataArray;
/**
 调用UserDefaults进行简短的本地数据存储,要存储的本地数据放置在NSDictionary中
 @params dictionary要存储到本地的数据
 */
- (void)storeDataBackLocallyUsingDictionary:(NSDictionary *)dictionary;
/**
 在这个方法里实现获取远程服务器数据的逻辑,返回获取数据的成功与否,如果遇到错误,设置错误代码,弹出错误提示
 @return 返回获取数据成功与否,YES代表成功,NO代表不成功
 */
- (BOOL)fetchRemoteData;
/**
 在这个方法里定义基本的获取远程服务器数据的逻辑
 @params completionHandler 获取数据完成后进行后续处理
 */
- (void)prepareDataAsyncWithCompletionHandler:(prepareDataAsyncCompletionHandler)completionHandler;

@required
- (void)buildNavigationBar;
- (void)prepareUIElements;
- (void)buildConstraintsOnUIElements;


@end

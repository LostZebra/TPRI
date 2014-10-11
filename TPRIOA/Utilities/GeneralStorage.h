//
//  GeneralStorage.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/25.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GeneralStorage : NSObject

@property (nonatomic, strong) NSUserDefaults *userDataDefaults;

+ (GeneralStorage *)getSharedInstance;

- (void)setUsrStatusFlag:(BOOL)status;

- (void)setAutoLoginFlag:(BOOL)willAutoLogin;

- (BOOL)isUsrExisted;

- (BOOL)willAutoLogin;

- (NSDictionary *)getUsrLoginData;

- (void)registerUsrLocally:(NSDictionary *)usrLoginData;

- (NSString *)getUsrName;

- (void)savePhoto:(UIImage *)photoSaving withCompletionHandler:(void (^)(NSURL *assetURL, NSError *error))completionHandler;

- (void)savePhotos:(NSArray *)photoArray withCompletionHandler:(void (^)(NSURL *assetURL, NSError *error))completionHandler;

@end

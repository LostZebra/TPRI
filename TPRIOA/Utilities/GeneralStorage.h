//
//  GeneralStorage.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/25.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralStorage : NSObject

@property (nonatomic, strong) NSUserDefaults *userDataDefaults;

+ (GeneralStorage *)getSharedInstance;

- (NSArray *)getUsrLoginData;

- (void)setLoginStatusFlag:(BOOL)status;

- (void)setUsrLoginData:(NSArray *)usrLoginArray;

@end

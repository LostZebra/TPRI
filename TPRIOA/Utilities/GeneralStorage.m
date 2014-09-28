//
//  GeneralStorage.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/25.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "GeneralStorage.h"

@implementation GeneralStorage

@synthesize userDataDefaults;

static GeneralStorage *generalStorage = nil;

+ (GeneralStorage *)getSharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        generalStorage = [[GeneralStorage alloc] init];
    });
    return generalStorage;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userDataDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark LoginRelated

- (void)setUsrStatusFlag:(BOOL)status
{
    [self.userDataDefaults setBool:status forKey:@"UserExisted"];
}

- (void)setAutoLoginFlag:(BOOL)willAutoLogin
{
    [self.userDataDefaults setBool:willAutoLogin forKey:@"WillAutoLogin"];
}

- (BOOL)isUsrExisted
{
    return [self.userDataDefaults boolForKey:@"UserExisted"];
}

- (BOOL)willAutoLogin
{
    return [self.userDataDefaults boolForKey:@"WillAutoLogin"];
}

- (NSArray *)getUsrLoginData
{
    NSMutableArray *loginDataArray = nil;
    if ([self.userDataDefaults boolForKey:@"UserExisted"] == YES) {
        loginDataArray = [[NSMutableArray alloc] initWithCapacity:2];
        [loginDataArray addObject:[self.userDataDefaults objectForKey:@"Username"]];
        [loginDataArray addObject:[self.userDataDefaults objectForKey:@"Password"]];
    }
    return loginDataArray == nil ? loginDataArray : [NSArray arrayWithArray:loginDataArray];
}

- (void)registerUsrLocally:(NSArray *)usrLoginArray
{
    [self setUsrStatusFlag:YES];
    [self setAutoLoginFlag:YES];
    [self.userDataDefaults setObject:[usrLoginArray objectAtIndex:0] forKey:@"Username"];
    [self.userDataDefaults setObject:[usrLoginArray objectAtIndex:1] forKey:@"Password"];
}

@end

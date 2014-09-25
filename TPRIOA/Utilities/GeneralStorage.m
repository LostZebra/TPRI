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

// Static
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

- (NSArray *)getUsrLoginData
{
    NSMutableArray *loginDataArray = nil;
    if ([self.userDataDefaults boolForKey:@"IsLogined"] == YES) {
        loginDataArray = [[NSMutableArray alloc] initWithCapacity:2];
        [loginDataArray addObject:[self.userDataDefaults objectForKey:@"Username"]];
        [loginDataArray addObject:[self.userDataDefaults objectForKey:@"Password"]];
    }
    if (loginDataArray == nil) {
        return nil;
    }
    return [NSArray arrayWithArray:loginDataArray];
}

- (void)setLoginStatusFlag:(BOOL)status
{
    [self.userDataDefaults setBool:status forKey:@"IsLogined"];
}

- (void)setUsrLoginData:(NSArray *)usrLoginArray
{
    [self.userDataDefaults setObject:[usrLoginArray objectAtIndex:0] forKey:@"Username"];
    [self.userDataDefaults setObject:[usrLoginArray objectAtIndex:1] forKey:@"Password"];
}

@end

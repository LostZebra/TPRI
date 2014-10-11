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

- (NSDictionary *)getUsrLoginData
{
    if ([self.userDataDefaults boolForKey:@"UserExisted"] == YES) {
        return @{@"Username" : [self.userDataDefaults objectForKey:@"Username"],
                 @"Password" : [self.userDataDefaults objectForKey:@"Password"]};
    }
    return nil;
}

- (void)registerUsrLocally:(NSDictionary *)usrLoginData
{
    if (usrLoginData != nil) {
        [self setUsrStatusFlag:YES];
        [self setAutoLoginFlag:YES];
        [self.userDataDefaults setObject:usrLoginData[@"Username"] forKey:@"Username"];
        [self.userDataDefaults setObject:usrLoginData[@"Password"] forKey:@"Password"];
    }
}

- (NSString *)getUsrName
{
    return [self.userDataDefaults objectForKey:@"Username"];
}

#pragma mark PhotoStorage

- (void)savePhoto:(UIImage *)photoSaving withCompletionHandler:(void (^)(NSURL *assetURL, NSError *error))completionHandler
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[photoSaving CGImage] orientation:(ALAssetOrientation)[photoSaving imageOrientation] completionBlock:completionHandler];
}

- (void)savePhotos:(NSArray *)photoArray withCompletionHandler:(void (^)(NSURL *assetURL, NSError *error))completionHandler
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    for (int i = 0; i < [photoArray count]; ++i) {
        UIImage *photoSaving = [photoArray objectAtIndex:i];
        if (i == [photoArray count] - 1) {
            [library writeImageToSavedPhotosAlbum:[photoSaving CGImage] orientation:(ALAssetOrientation)[photoSaving imageOrientation] completionBlock:completionHandler];
        }
        [library writeImageToSavedPhotosAlbum:[photoSaving CGImage] orientation:(ALAssetOrientation)[photoSaving imageOrientation] completionBlock:nil];
    }
}

@end

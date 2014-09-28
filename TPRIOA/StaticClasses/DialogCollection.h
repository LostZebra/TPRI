//
//  DialogCollection.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/20.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// StaticClasses
#import "FontCollection.h"
#import "ColorCollection.h"

@interface DialogCollection : NSObject

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message withLastingTime:(NSTimeInterval)time delegate:(id)del;

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message cancelButton:(NSString *)cancelButtonLabel otherButton:(NSString *)otherButtonLabel delagate:(id)del;

+ (void)showProgressView:(NSString *)status over:(UIView *)rootView;

+ (UIView *)showMaskView;

@end

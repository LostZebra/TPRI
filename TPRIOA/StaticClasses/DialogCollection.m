//
//  DialogCollection.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/20.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "DialogCollection.h"

@implementation DialogCollection

- (id)init
{
    NSAssert(false, @"This class is a static one which forbids explicit initiation");
    return nil;
}

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message withLastingTime:(NSTimeInterval)time delegate:(id)del
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:del cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertView show];
    // 在time参数指定的时间过后将弹出的UIAlertView取消
    dispatch_time_t showLastingTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_after(showLastingTime, dispatch_get_main_queue(), ^(void){
        [alertView dismissWithClickedButtonIndex:0 animated:true];
    });
}

+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message cancelButton:(NSString *)cancelButtonLabel otherButton:(NSString *)otherButtonLabel delagate:(id)del
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:del cancelButtonTitle:cancelButtonLabel otherButtonTitles:otherButtonLabel, nil];
    [alertView show];
}

+ (void)showProgressView:(NSString *)status over:(UIView *)rootView
{
    // 包含ActivityIndicator和Label的UIView
    UIView *inProgressView = [[UIView alloc] init];
    inProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    [inProgressView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:1.0]];
    inProgressView.layer.cornerRadius = 10;
    // 定义ActivityIndicator
    UIActivityIndicatorView *inProgressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    inProgressIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [inProgressIndicator startAnimating];
    // 定义Label
    UILabel *inProgressLabel = [[UILabel alloc] init];
    inProgressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [inProgressLabel setText:status];
    [inProgressLabel setFont:[UIFont systemFontOfSize:13]];
    [inProgressLabel setTextAlignment:NSTextAlignmentCenter];
    [inProgressLabel setTextColor:[UIColor whiteColor]];
    // 添加子UIView
    [inProgressView addSubview:inProgressIndicator];
    [inProgressView addSubview:inProgressLabel];
    // 为ActivityIndicator添加界面约束
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:-10.0f]];
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeWidth multiplier:0.0f constant:40.0f]];
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeHeight multiplier:0.0f constant:40.0f]];
    // 为Label添加界面约束
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:20.0f]];
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeWidth multiplier:0.0f constant:60.0f]];
    [inProgressView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:inProgressView attribute:NSLayoutAttributeHeight multiplier:0.0f constant:20.0f]];
    // 将Progress view添加至目标view的层级之上
    [rootView addSubview:inProgressView];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:0.0f constant:80.0f]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:inProgressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:0.0f constant:80.0f]];
}

@end

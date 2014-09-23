//
//  ColorCollection.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/19.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "ColorCollection.h"

@implementation ColorCollection

- (id)init
{
    NSAssert(false, @"This class is a static one which forbids explicit initiation");
    return nil;
}

+ (UIColor *)titleBarColor
{
    return [UIColor colorWithRed:0.0f green:0.5f blue:0.9f alpha:1.0f];
}

+ (UIColor *)negativeUIColor
{
    return [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
}

+ (UIColor *)positiveUIColor
{
    return [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorWithWhite:0.95 alpha:0.9];
}

@end

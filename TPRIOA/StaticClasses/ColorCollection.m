//
//  ColorCollection.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/19.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "ColorCollection.h"

@implementation ColorCollection

+ (id)alloc
{
    NSAssert(false, @"This class is a static one which forbids explicit memory allocation");
    return nil;
}

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

+ (UIColor *)defaultBlueColor
{
    return [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f];;
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorWithWhite:0.9f alpha:0.9f];
}

+ (UIColor *)darkGrayColor
{
    return [UIColor colorWithWhite:0.5f alpha:0.5f];
}

+ (UIColor *)tableViewHeaderColor
{
    return [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
}

+ (UIColor *)headerViewTextColor
{
    return [UIColor colorWithWhite:0.5f alpha:0.8f];
}

+ (UIColor *)maskViewColor
{
    return [UIColor colorWithWhite:0.4f alpha:0.5f];
}

+ (UIColor *)whiteColor
{
    return [UIColor whiteColor];
}

@end

//
//  FontCollection.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/25.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "FontCollection.h"

@implementation FontCollection

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

+ (UIFont *)standardFontStyleWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+ (UIFont *)standardBoldFontStyleWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

+ (UIFont *)fontWithFontFamilyName:(NSString *)fontFamily andSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:fontFamily size:fontSize];
}

@end

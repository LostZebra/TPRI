//
//  FontCollection.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/25.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FontCollection : NSObject

+ (UIFont *)standardFontStyleWithSize:(CGFloat)fontSize;

+ (UIFont *)standardBoldFontStyleWithSize:(CGFloat)fontSize;

+ (UIFont *)fontWithFontFamilyName:(NSString *)fontFamily andSize:(CGFloat)fontSize;

@end

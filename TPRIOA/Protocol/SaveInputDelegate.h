//
//  SaveInputDelegate.h
//  TPRIOA
//
//  Created by xiaoyong on 14/10/8.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SaveInputDelegate <NSObject>

@required
- (void)saveText:(NSString *)text;

@end

//
//  ButtonDelegate.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/28.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ButtonDelegate <NSObject>

@required
- (void)buttonTapped:(UIButton *)tappedButton;

@end

//
//  MainController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/22.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Protocol
#import "BaseUIProtocol.h"

@interface MainController : UICollectionViewController<BaseUIProtocol, UIAlertViewDelegate>

@property (strong, nonatomic) UILabel *usrIdLabel;
@property (strong, nonatomic) UIImageView *loginedImageView;
@property (strong, nonatomic) UIButton *usrInfoButton;

@property (strong, nonatomic) NSDictionary *iconOrderDictionary;
@property (strong, nonatomic) NSDictionary *labelOrderDictionary;

@property (strong, nonatomic) NSError *error;

@end

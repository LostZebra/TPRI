//
//  BaseMasterDetailViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/29.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseUIProtocol.h"

@interface BaseMasterDetailViewController : UIViewController<BaseUIProtocol>

@property (strong, nonatomic) UITableView *masterView;
@property (strong, nonatomic) UITableView *detailView;
@property (strong, nonatomic) UIView *viewSeparator;

@property (strong, nonatomic) NSError *error;

@end

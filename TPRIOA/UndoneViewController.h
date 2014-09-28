//
//  UndoneViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocol
#import "BaseSplitViewProtocol.h"
#import "BaseUIProtocol.h"
#import "ButtonDelegate.h"

@interface UndoneViewController : UIViewController<BaseUIProtocol, BaseSplitViewProtocol, UITableViewDelegate, UITableViewDataSource, ButtonDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UITableView *masterView;
@property (strong, nonatomic) UITableView *detailView;
@property (strong, nonatomic) UIView *viewSeparator;

@end


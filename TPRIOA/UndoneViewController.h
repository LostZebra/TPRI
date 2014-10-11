//
//  UndoneViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseMasterDetailViewController.h"

// Protocol
#import "BaseSplitViewProtocol.h"
#import "ButtonDelegate.h"
#import "SaveInputDelegate.h"

@interface UndoneViewController : BaseMasterDetailViewController<BaseSplitViewProtocol, UITableViewDelegate, UITableViewDataSource, ButtonDelegate, UIPickerViewDelegate, UIPickerViewDataSource, SaveInputDelegate>

@end


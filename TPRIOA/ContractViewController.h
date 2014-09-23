//
//  ContractViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

// Static Class
#import "ColorCollection.h"
#import "DialogCollection.h"

// Module
#import "DataFetchingClient.h"

@interface ContractViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *masterView;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) UIView *viewSeparator;

@end

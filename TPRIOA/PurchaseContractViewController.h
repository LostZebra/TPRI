//
//  ContractViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseMasterDetailViewController.h"

// Protocol
#import "BaseUIProtocol.h"
#import "BaseSplitViewProtocol.h"

@interface PurchaseContractViewController : BaseMasterDetailViewController<BaseSplitViewProtocol, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

// @property (strong, nonatomic) UITableView *masterView;
// @property (strong, nonatomic) UITableView *detailView;
// @property (strong, nonatomic) UIView *viewSeparator;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

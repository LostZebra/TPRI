//
//  ContractViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

// StaticClasses
#import "ColorCollection.h"
#import "FontCollection.h"
#import "DialogCollection.h"

// Utilities
#import "DataFetchingClient.h"

// Views
#import "GeneralTableViewCell.h"

@interface ContractViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *masterView;
@property (strong, nonatomic) UITableView *detailView;
@property (strong, nonatomic) UIView *viewSeparator;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

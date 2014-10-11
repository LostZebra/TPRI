//
//  BaseMasterDetailViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/29.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "BaseMasterDetailViewController.h"

// StaticClasses
#import "ColorCollection.h"
#import "FontCollection.h"
#import "DialogCollection.h"

// Constraints
static NSString *const masterViewVCons = @"V:|-0-[_masterView]-0-|";
static NSString *const detailViewHCons = @"H:[_viewSeparator]-0-[_detailView]-0-|";
static NSString *const detailViewVCons = @"V:|-0-[_detailView]-0-|";
static NSString *const viewSeparatorHCons = @"H:[_masterView]-0-[_viewSeparator(==2)]";
static NSString *const viewSeparatorVCons = @"V:|-0-[_viewSeparator]-0-|";

@implementation BaseMasterDetailViewController

@synthesize masterView = _masterView;
@synthesize detailView = _detailView;
@synthesize viewSeparator = _viewSeparator;

@synthesize error = _error;

- (id)init
{
    self = [super init];
    if (self) {
        self.error = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareUIElements
{
    // 初始化各Subviews的实例
    // 显示概要的Masterview
    self.masterView = [[UITableView alloc] init];
    self.masterView.translatesAutoresizingMaskIntoConstraints = NO;
    self.masterView.backgroundColor = [ColorCollection tableViewHeaderColor];
    
    // 显示详情的Detailview
    self.detailView = [[UITableView alloc] init];
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailView.backgroundColor = [ColorCollection tableViewHeaderColor];
    
    // 分隔Masterview和Detailview的Viewseperator
    self.viewSeparator = [[UIView alloc] init];
    self.viewSeparator.backgroundColor = [ColorCollection lightGrayColor];
    self.viewSeparator.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[ColorCollection titleBarColor]];
    [self.navigationController.navigationBar setTintColor:[ColorCollection whiteColor]];
    // Title baritem
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:17.0f]];
    [titleLabel setTextColor:[ColorCollection whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)buildConstraintsOnUIElements
{
    // 添加Subviews
    [self.view addSubview:_masterView];
    [self.view addSubview:_detailView];
    [self.view addSubview:_viewSeparator];
    // 为显示合同概要的Masterview添加约束
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_masterView);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:masterViewVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_masterView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_masterView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4f constant:0.0f]];
    // 为分隔Masterview和Detailview的Viewseperator添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_masterView, _viewSeparator);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:viewSeparatorHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:viewSeparatorVCons options:0 metrics:nil views:viewDictionary]];
    // 为显示合同详情的Detailview添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_viewSeparator, _detailView);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:detailViewHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:detailViewVCons options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSArray arrayWithArray:constraintsArray]];
}

- (void)prepareDataAsyncWithCompletionHandler:(prepareDataAsyncCompletionHandler)completionHandler
{
    [DialogCollection showProgressView:@"正在加载" over:self.view];
    dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
    dispatch_after(delay_time, dispatch_get_main_queue(), ^{
        BOOL isSuccess = [self fetchRemoteData];
        completionHandler(isSuccess, _error);
    });
}

- (BOOL)fetchRemoteData
{
    NSString *errorStr = [NSString stringWithFormat:@"%@ should always be overriden!", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:errorStr userInfo:nil];
    return NO;
}

@end

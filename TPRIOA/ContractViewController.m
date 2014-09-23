//
//  ContractViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "ContractViewController.h"

// Constraints
NSString *const masterViewVCons = @"V:|-0-[_masterView]-0-|";
NSString *const detailViewHCons = @"H:[_viewSeparator]-0-[_detailView]-0-|";
NSString *const detailViewVCons = @"V:|-0-[_detailView]-0-|";
NSString *const viewSeparatorHCons = @"H:[_masterView]-0-[_viewSeparator(==2)]";
NSString *const viewSeparatorVCons = @"V:|-0-[_viewSeparator]-0-|";

NSString *const cellIndentifier = @"TableViewCell";

@interface ContractViewController ()

@end

@implementation ContractViewController
{
    NSMutableArray *testArray;
}

@synthesize masterView = _masterView;
@synthesize detailView = _detailView;
@synthesize viewSeparator = _viewSeparator;

- (id)init
{
    self = [super init];
    if (self) {
        [self prepareUIElements];
        testArray = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildNavigationBar];
    [self buildConstraintsOnUIElements];
    [self prepareData];
}

- (void)prepareData
{
    [DialogCollection showProgressView:@"正在加载" over:self.view];
    DataFetchingClient *dataFetchingClient = [[DataFetchingClient alloc] init];
    [dataFetchingClient fetchDataInto:testArray completionHandler:^{
        [[[self.view subviews] lastObject] removeFromSuperview];
        [self.masterView reloadData];
    }];
}

- (void)prepareUIElements
{
    // 初始化各Subviews的实例
    // 显示合同概要的Masterview
    self.masterView = [[UITableView alloc] init];
    self.masterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.masterView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIndentifier];
    self.masterView.delegate = self;
    self.masterView.dataSource = self;
    // 分隔Masterview和Detailview的Viewseperator
    self.detailView = [[UIView alloc] init];
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailView.backgroundColor = [UIColor whiteColor];
    // 显示合同详情的Detailview
    self.viewSeparator = [[UIView alloc] init];
    self.viewSeparator.backgroundColor = [ColorCollection lightGrayColor];
    self.viewSeparator.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [ColorCollection titleBarColor];
    // Title item
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"采购合同"];
    UIFont *fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [titleStr addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, 4)];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setAttributedText:titleStr];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)buildConstraintsOnUIElements
{
    // 添加Subviews
    [self.view addSubview:self.masterView];
    [self.view addSubview:self.detailView];
    [self.view addSubview:self.viewSeparator];
    // 为显示合同概要的Masterview添加约束
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_masterView);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:masterViewVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.masterView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.masterView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.4f constant:0.0f]];
    // 为分隔Masterview和Detailview的Viewseperator添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_masterView, _viewSeparator);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:viewSeparatorHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:viewSeparatorVCons options:0 metrics:nil views:viewDictionary]];
    // 为显示合同详情的Detailview添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_viewSeparator, _detailView);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:detailViewHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:detailViewVCons options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:constraintsArray];
    [self.masterView reloadData];
}

#pragma mark <UITableViewDelegate>

// TableView的delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.masterView dequeueReusableCellWithIdentifier:cellIndentifier forIndexPath:indexPath];
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width / 2 - 20, cell.frame.size.height / 2 - 10, 80, 20)];
    [cellLabel setText:[NSString stringWithFormat:@"%@", [testArray objectAtIndex:(int)indexPath.item]]];
    [cellLabel setTextColor:[UIColor blackColor]];
    [cellLabel sizeToFit];
    [cell addSubview:cellLabel];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [testArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

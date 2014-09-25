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

NSString *const masterTableViewIdentifier = @"MasterTableViewCell";
NSString *const detailTableViewIdentifier = @"DetailTableViewCell";

@interface ContractViewController ()

@end

@implementation ContractViewController
{
    // Masterview
    NSMutableArray *testArray;
    NSMutableArray *resultArray;
    NSObject *selectedContract;
    BOOL isSearching;
    // Detailview
    NSMutableArray *detailTableViewLabelArray;
    NSMutableArray *detailTableViewHeaderArray;
}

@synthesize masterView = _masterView;
@synthesize detailView = _detailView;
@synthesize viewSeparator = _viewSeparator;
@synthesize searchBar = _searchBar;

- (id)init
{
    self = [super init];
    if (self) {
        // Masterview
        testArray = [[NSMutableArray alloc] initWithCapacity:100];
        selectedContract = nil;
        isSearching = NO;
        // Detailview
        detailTableViewLabelArray = [[NSMutableArray alloc] initWithCapacity:4];
        detailTableViewHeaderArray = [[NSMutableArray alloc] initWithCapacity:4];
        // Add UI Elements
        [self prepareUIElements];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildConstraintsOnUIElements];
    [self prepareData];
}

- (void)prepareData
{
    [_detailView reloadData];
    [DialogCollection showProgressView:@"正在加载" over:self.view];
    DataFetchingClient *dataFetchingClient = [[DataFetchingClient alloc] init];
    [dataFetchingClient fetchDataInto:testArray completionHandler:^{
        // Testing
        selectedContract = [[NSObject alloc] init];
        detailTableViewLabelArray = [[NSMutableArray alloc] initWithCapacity:4];
        [detailTableViewLabelArray addObject:@[@"合同类型", @"项目分类", @"部门名称", @"客户名称", @"外委合同经办人", @"供方/外协方"]];
        [detailTableViewLabelArray addObject:@[@"主合同名称", @"主合同编号", @"主合同金额(元)", @"采购合同名称", @"采购归类", @"采购方式", @"采购合同额(元)", @"设备到货时间", @"申请日期", @"合同主要内容"]];
        [detailTableViewLabelArray addObject:@[@"预付款", @"验收款/进度款", @"168试运行", @"其他", @"质保金"]];
        [detailTableViewLabelArray addObject:@[@"处所主管及意见", @"部门主任及意见", @"合同管理专职及意见", @"采购中心主管及意见"]];
        [detailTableViewLabelArray addObject:@[@"附件", @"当前进度"]];
        detailTableViewHeaderArray = [[NSMutableArray alloc] initWithCapacity:4];
        [detailTableViewHeaderArray addObjectsFromArray:@[@"参与方信息", @"合同详细信息", @"付款信息", @"审核信息", @"其他"]];
        // Official
        [[[self.view subviews] lastObject] removeFromSuperview];
        [_masterView reloadData];
        [_detailView reloadData];
        [_masterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)prepareUIElements
{
    // 初始化各Subviews的实例
    // 显示概要的Masterview
    _masterView = [[UITableView alloc] init];
    _masterView.translatesAutoresizingMaskIntoConstraints = NO;
    [_masterView registerClass:[GeneralTableViewCell class] forCellReuseIdentifier:masterTableViewIdentifier];
    _masterView.delegate = self;
    _masterView.dataSource = self;
    
    // 显示详情的Detailview
    _detailView = [[UITableView alloc] init];
    _detailView.translatesAutoresizingMaskIntoConstraints = NO;
    [_detailView registerClass:[UITableViewCell class] forCellReuseIdentifier:detailTableViewIdentifier];
    [_detailView setBackgroundColor:[ColorCollection tableViewHeaderColor]];
    _detailView.delegate = self;
    _detailView.dataSource = self;
    
    // 分隔Masterview和Detailview的Viewseperator
    _viewSeparator = [[UIView alloc] init];
    _viewSeparator.backgroundColor = [ColorCollection lightGrayColor];
    _viewSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 初始化SearchBar
    _searchBar = [[UISearchBar alloc] init];
    [_searchBar sizeToFit];
    _searchBar.placeholder = @"搜索合同";
    _searchBar.delegate = self;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_masterView setTableHeaderView:_searchBar];
    for (UIView *subView in [_searchBar subviews]) {
        if ([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            UITextField *textField = (UITextField *)subView;
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        }
    }
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [ColorCollection titleBarColor];
    // Title item
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:17.0f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"采购合同"];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    // Right baritem
    UIButton *cancelSearchButton = [[UIButton alloc] init];
    [cancelSearchButton setTitle:@"取消搜索" forState:UIControlStateNormal];
    [cancelSearchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelSearchButton sizeToFit];
    [cancelSearchButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelSearchButton];
    [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
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

#pragma mark <UITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 左边概要视图中TableViewCell构建
    if (tableView == _masterView) {
        GeneralTableViewCell *cell = [_masterView dequeueReusableCellWithIdentifier:masterTableViewIdentifier forIndexPath:indexPath];
        // 配置Cell的内容和样式
        [self configureMasterTableViewCell:cell forIndexPath:indexPath];
        return cell;
    }
    // 右边详细视图中TableViewCell的构建
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:detailTableViewIdentifier];
    // 配置Cell的内容和样式
    [self configureDetailTableViewCell:cell forIndexPath:indexPath];
    return cell;
}

// 各UITableView有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _masterView) {
        return 1;
    }
    else {
        if (selectedContract == nil) {
            UILabel *backgroudLabel = [[UILabel alloc] init];
            [backgroudLabel setFont:[FontCollection standardBoldFontStyleWithSize:20.0f]];
            [backgroudLabel setTextColor:[ColorCollection headerViewTextColor]];
            [backgroudLabel setTextAlignment:NSTextAlignmentCenter];
            [backgroudLabel setText:@"尚未选中任何条目"];
            [backgroudLabel sizeToFit];
            _detailView.backgroundView = backgroudLabel;
            _detailView.separatorStyle = UITableViewCellSeparatorStyleNone;  // Remove separator line
            return 0;
        }
        _detailView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [detailTableViewHeaderArray count];
    }
}

// 定义每个section有多少列
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _masterView) {
        return [self numberOfRowsInMasterTableViewForSection:section];
    }
    return [self numberOfRowsInDetailTableViewForSection:section];
}

// 定义行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _masterView) {
        return [self masterTableViewCellHeightForIndexPath:indexPath];
    }
    return [self detailTableViewCellHeightForIndexPath:indexPath];
}

// 定义每个section的标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _detailView) {
        return 40.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _masterView) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _masterView.bounds.size.width, 30.0f)];
    [headerView setBackgroundColor:[ColorCollection tableViewHeaderColor]];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
    [headerLabel setTextColor:[ColorCollection headerViewTextColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setText:[detailTableViewHeaderArray objectAtIndex:section]];
    [headerLabel sizeToFit];
    [headerView addSubview:headerLabel];
    
    // 添加约束
    NSString *const headerLabelHCons = @"H:|-10-[headerLabel]";
    NSString *const headerLabelVCons = @"V:[headerLabel]-2-|";
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(headerLabel);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:headerLabelHCons options:0 metrics:nil views:viewDictionary]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:headerLabelVCons options:0 metrics:nil views:viewDictionary]];
    return headerView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _masterView) {
        [_detailView reloadData];
    }
    else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            NSLog(@"附件");
        }
        else {
            NSLog(@"流程");
        }
    }
    return indexPath;
}

#pragma mark <UISearchBarDelegate>

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [resultArray removeAllObjects];
    for (NSString *singleStr in testArray) {
        if ([singleStr rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [resultArray addObject:singleStr];
            NSLog(@"Add");
        }
    }
    [_masterView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
}

- (void)cancelSearch
{
    isSearching = NO;
    [_searchBar resignFirstResponder];
    [_masterView reloadData];
    [UIView animateWithDuration:0.4f animations:^{
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
        [_masterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

#pragma mark ConfigureTableViewCell(ignorable)

- (void)configureMasterTableViewCell:(GeneralTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell cellConfigureWithPreHandler:^{
        [cell.titleLabel setText:@"西安华能集团有限公司伞塔路热工研究院200吨级煤发电项目"];
        [cell.statusLabel setText:@"正在审核"];
        [cell.statusLabel setTextColor:[UIColor redColor]];
        [cell.departmentLabel setText:@"院工部"];
    }];
}

- (void)configureDetailTableViewCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
    [cell.textLabel setText:[[detailTableViewLabelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    // Testing
    [cell.detailTextLabel setText:@"暂无信息"];
    if (indexPath.section == 1 && indexPath.row == [[detailTableViewLabelArray objectAtIndex:1] count] - 1) {
        [cell.detailTextLabel setFont:[FontCollection standardFontStyleWithSize:11.0f]];
        [cell.detailTextLabel setNumberOfLines:2];
    }
    else if (indexPath.section == 4)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.detailTextLabel setText:@""];
    }
}

- (NSInteger)numberOfRowsInMasterTableViewForSection:(NSInteger)section
{
    resultArray = (isSearching == YES) ? [NSMutableArray arrayWithArray:resultArray] : [NSMutableArray arrayWithArray:testArray];
    return [resultArray count];
}

- (NSInteger)numberOfRowsInDetailTableViewForSection:(NSInteger)section
{
    return [[detailTableViewLabelArray objectAtIndex:section] count];
}

- (CGFloat)masterTableViewCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (CGFloat)detailTableViewCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == [[detailTableViewLabelArray objectAtIndex:1] count] - 1) {
        return 60.0f;
    }
    return 40.0f;
}


#pragma mark Ignorable

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

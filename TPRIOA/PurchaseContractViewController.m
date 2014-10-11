//
//  ContractViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "PurchaseContractViewController.h"

// StaticClasses
#import "ColorCollection.h"
#import "FontCollection.h"
#import "DialogCollection.h"

// Utilities
#import "DataFetchingClient.h"

// Views
#import "PurchaseContractCell.h"

static NSString *const masterTableViewIdentifier = @"MasterTableViewCell";
static NSString *const detailTableViewIdentifier = @"DetailTableViewCell";

@interface PurchaseContractViewController ()

@end

@implementation PurchaseContractViewController
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

@synthesize searchBar = _searchBar;

- (id)init
{
    self = [super init];
    if (self) {
        // Data for Masterview
        testArray = [[NSMutableArray alloc] initWithCapacity:20];
        selectedContract = nil;
        isSearching = NO;
        // Data for Detailview
        detailTableViewLabelArray = [[NSMutableArray alloc] initWithCapacity:4];
        detailTableViewHeaderArray = [[NSMutableArray alloc] initWithCapacity:4];
        // Views
        [self prepareUIElements];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildConstraintsOnUIElements];
    [self prepareDataAsyncWithCompletionHandler:^(BOOL isSuccess, NSError *error) {
        [[[self.view subviews] lastObject] removeFromSuperview];
        if (isSuccess) {
            // Official
            [self.masterView reloadData];
            [self.detailView reloadData];
            [self.masterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else {
            if (error) {
                [DialogCollection showAlertViewWithTitle:@"错误" andMessage:error.localizedDescription withLastingTime:0.5f delegate:self];
            }
        }
    }];
}

- (void)prepareUIElements
{
    [super prepareUIElements];
    // 初始化Tableview的delegate,datasource和class
    self.masterView.delegate = self;
    self.masterView.dataSource = self;
    [self.masterView registerClass:[PurchaseContractCell class] forCellReuseIdentifier:masterTableViewIdentifier];
    self.detailView.delegate = self;
    self.detailView.dataSource = self;
    [self.detailView registerClass:[UITableViewCell class] forCellReuseIdentifier:detailTableViewIdentifier];
    // 初始化SearchBar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.placeholder = @"搜索合同";
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    [self.masterView setTableHeaderView:_searchBar];
    for (UIView *subView in [self.searchBar subviews]) {
        if ([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            UITextField *textField = (UITextField *)subView;
            [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        }
    }
}

- (void)buildNavigationBar
{
    [super buildNavigationBar];
    // Title item
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    [titleView setText:@"采购合同"];
    [titleView sizeToFit];
    // Right baritem
    UIButton *cancelSearchButton = [[UIButton alloc] init];
    [cancelSearchButton.titleLabel setFont:[FontCollection standardFontStyleWithSize:17.0f]];
    [cancelSearchButton setTitle:@"取消搜索" forState:UIControlStateNormal];
    [cancelSearchButton sizeToFit];
    [cancelSearchButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelSearchButton];
    [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
}

- (BOOL)fetchRemoteData
{
    DataFetchingClient *dataFetchingClient = [[DataFetchingClient alloc] init];
    [dataFetchingClient fetchDataIntoArray:testArray completionHandler:^{
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
    }];
    return YES;
}

#pragma mark <UITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 左边概要视图中TableViewCell构建
    if (tableView == self.masterView) {
        PurchaseContractCell *cell = [self.masterView dequeueReusableCellWithIdentifier:masterTableViewIdentifier forIndexPath:indexPath];
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
    if (tableView == self.masterView) {
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
            self.detailView.backgroundView = backgroudLabel;
            self.detailView.separatorStyle = UITableViewCellSeparatorStyleNone;  // Remove separator line
            return 0;
        }
        self.detailView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return [detailTableViewHeaderArray count];
    }
}

// 定义每个section有多少列
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.masterView) {
        return [self numberOfRowsInMasterTableViewForSection:section];
    }
    return [self numberOfRowsInDetailTableViewForSection:section];
}

// 定义行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.masterView) {
        return [self masterTableViewCellHeightForIndexPath:indexPath];
    }
    return [self detailTableViewCellHeightForIndexPath:indexPath];
}

// 定义每个section的标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.detailView) {
        return 40.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.masterView) {
        return nil;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.masterView.bounds.size.width, 30.0f)];
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
    if (tableView == self.masterView) {
        [self.detailView reloadData];
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
        }
    }
    [self.masterView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
}

- (void)cancelSearch
{
    isSearching = NO;
    [self.searchBar resignFirstResponder];
    [self.masterView reloadData];
    [UIView animateWithDuration:0.4f animations:^{
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
        [self.masterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

#pragma mark ConfigureTableViewCell(inherited&ignorable)

- (void)configureMasterTableViewCell:(PurchaseContractCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell cellConfigureWithPreHandler:^{
        [cell.titleLabel setText:@"西安华能集团有限公司伞塔路热工研究院200吨级煤发电项目"];
        [cell.statusLabel setText:@"正在审核"];
        [cell.statusLabel setTextColor:[ColorCollection negativeUIColor]];
        [cell.departmentLabel setText:@"院工部"];
    }];
}

- (void)configureDetailTableViewCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
    [cell.textLabel setText:[[detailTableViewLabelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Testing
    [cell.detailTextLabel setText:@"暂无信息"];
    if (indexPath.section == 1 && indexPath.row == [[detailTableViewLabelArray objectAtIndex:1] count] - 1) {
        [cell.detailTextLabel setFont:[FontCollection standardFontStyleWithSize:11.0f]];
        [cell.detailTextLabel setNumberOfLines:2];
    }
    else if (indexPath.section == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
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

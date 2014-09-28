//
//  UndoneViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "UndoneViewController.h"

// StaticClasses
#import "ColorCollection.h"
#import "FontCollection.h"
#import "DialogCollection.h"

// Utilities
#import "DataFetchingClient.h"

// Viewss
#import "UndoneItemCell.h"
#import "CustomizePickerView.h"

// Constraints
static NSString *const masterViewVCons = @"V:|-0-[_masterView]-0-|";
static NSString *const detailViewHCons = @"H:[_viewSeparator]-0-[_detailView]-0-|";
static NSString *const detailViewVCons = @"V:|-0-[_detailView]-0-|";
static NSString *const viewSeparatorHCons = @"H:[_masterView]-0-[_viewSeparator(==2)]";
static NSString *const viewSeparatorVCons = @"V:|-0-[_viewSeparator]-0-|";

static NSString *const masterTableViewIdentifier = @"MasterTableViewCell";
static NSString *const detailTableViewIdentifier = @"DetailTableViewCell";

@interface UndoneViewController ()

@end

@implementation UndoneViewController
{
    NSMutableDictionary *testDictionary;
    NSArray *testSectionArray;
    NSMutableArray *detailTableViewLabelArray;
    NSMutableArray *detailTableViewHeaderArray;
    NSObject *selectedUndone;
    // Testing
    NSArray *availablePeople;
    NSString *selectedPerson;
    // Pickerview
    CustomizePickerView *pickPersonView;
}

@synthesize masterView = _masterView;
@synthesize detailView = _detailView;
@synthesize viewSeparator = _viewSeparator;

- (id)init
{
    self = [super init];
    if (self) {
        // Masterview
        testSectionArray = [[NSArray alloc] init];
        testDictionary = [[NSMutableDictionary alloc] init];
        selectedUndone = nil;
        // Detailview
        detailTableViewLabelArray = [[NSMutableArray alloc] initWithCapacity:5];
        detailTableViewHeaderArray = [[NSMutableArray alloc] initWithCapacity:5];
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
    [DialogCollection showProgressView:@"正在加载" over:self.view];
    DataFetchingClient *dataFetchingClient = [[DataFetchingClient alloc] init];
    [dataFetchingClient fetchDataIntoDictionary:testDictionary completionHandler:^{
        // Testing
        testSectionArray = [testDictionary keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *str1 = (NSString *)obj1;
            NSString *str2 = (NSString *)obj2;
            return [str1 compare:str2];
        }];
        selectedUndone = [[NSObject alloc] init];
        detailTableViewLabelArray = [[NSMutableArray alloc] initWithCapacity:4];
        [detailTableViewLabelArray addObject:@[@"合同类型", @"项目分类", @"部门名称", @"客户名称", @"外委合同经办人", @"供方/外协方"]];
        [detailTableViewLabelArray addObject:@[@"主合同名称", @"主合同编号", @"主合同金额(元)", @"采购合同名称", @"采购归类", @"采购方式", @"采购合同额(元)", @"设备到货时间", @"申请日期", @"合同主要内容"]];
        [detailTableViewLabelArray addObject:@[@"预付款", @"验收款/进度款", @"168试运行", @"其他", @"质保金"]];
        [detailTableViewLabelArray addObject:@[@"附件", @"当前进度"]];
        [detailTableViewLabelArray addObject:@[@"处所主管", @"处所主管意见", @"部门审核人"]];
        [detailTableViewLabelArray addObject:@[@"同意", @"不同意"]];
        detailTableViewHeaderArray = [[NSMutableArray alloc] initWithCapacity:4];
        [detailTableViewHeaderArray addObjectsFromArray:@[@"参与方信息", @"合同详细信息", @"付款信息", @"审核信息", @"其他", @"意见"]];
        availablePeople = @[@"肖勇", @"黄甫翔", @"董明利"];
        // Official
        [[[self.view subviews] lastObject] removeFromSuperview];
        [_masterView reloadData];
        _masterView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _masterView.bounds.size.width, 10.0f)];
        [_detailView reloadData];
        [_masterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)prepareUIElements
{
    // 初始化各Subviews的实例
    // 显示概要的Masterview
    self.masterView = [[UITableView alloc] init];
    self.masterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.masterView registerClass:[UndoneItemCell class] forCellReuseIdentifier:masterTableViewIdentifier];
    [self.masterView setBackgroundColor:[ColorCollection tableViewHeaderColor]];
    self.masterView.delegate = self;
    self.masterView.dataSource = self;
    
    // 显示详情的Detailview
    self.detailView = [[UITableView alloc] init];
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.detailView registerClass:[UndoneItemCell class] forCellReuseIdentifier:detailTableViewIdentifier];
    [self.detailView setBackgroundColor:[ColorCollection tableViewHeaderColor]];
    self.detailView.delegate = self;
    self.detailView.dataSource = self;
    
    // 分隔Masterview和Detailview的Viewseperator
    self.viewSeparator = [[UIView alloc] init];
    self.viewSeparator.backgroundColor = [ColorCollection lightGrayColor];
    self.viewSeparator.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[ColorCollection titleBarColor]];
    // Title baritem
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:17.0f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"待办事项"];
    [titleLabel sizeToFit];
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

#pragma mark <UITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 左边概要视图中TableViewCell构建
    if (tableView == _masterView) {
        UndoneItemCell *cell = [tableView dequeueReusableCellWithIdentifier:masterTableViewIdentifier forIndexPath:indexPath];
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
        return [testSectionArray count];
    }
    else {
        if (selectedUndone == nil) {
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
    return 40.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableView *currentTableView = (tableView == _masterView) ? _masterView : _detailView;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, currentTableView.bounds.size.width, 30.0f)];
    [headerView setBackgroundColor:[ColorCollection tableViewHeaderColor]];
    
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
    [headerLabel setTextColor:[ColorCollection headerViewTextColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerView addSubview:headerLabel];
    
    // 添加约束
    NSString *const headerLabelHCons = @"H:|-10-[headerLabel]";
    NSString *const headerLabelVCons = @"V:[headerLabel]-2-|";
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(headerLabel);
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:headerLabelHCons options:0 metrics:nil views:viewDictionary]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:headerLabelVCons options:0 metrics:nil views:viewDictionary]];
    
    if (currentTableView == _masterView) {
        [headerLabel setText:[testSectionArray objectAtIndex:section]];
    }
    else {
        [headerLabel setText:[detailTableViewHeaderArray objectAtIndex:section]];
    }
    [headerLabel sizeToFit];
    return headerView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 2) {
        [self showPickerView];
    }
    return indexPath;
}

#pragma mark ConfigureTableViewCell(inherited&ignorable)

- (void)configureMasterTableViewCell:(UndoneItemCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell cellConfigureWithPreHandler:^{
        [cell.fromLabel setText:(NSString *)[[testDictionary objectForKey:[testSectionArray objectAtIndex:indexPath.section]] objectAtIndex:1]];
        [cell.titleLabel setText:[[testDictionary objectForKey:[testSectionArray objectAtIndex:indexPath.section]] objectAtIndex:0]];
        [cell.dateLabel setText:[[testDictionary objectForKey:[testSectionArray objectAtIndex:indexPath.section]] objectAtIndex:3]];
    }];
}

- (void)configureDetailTableViewCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    [cell.textLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
    [cell.textLabel setText:[[detailTableViewLabelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    // Testing
    [cell.detailTextLabel setText:@"暂无信息"];
    switch (indexPath.section) {
        case 1: {
            if (indexPath.row == [[detailTableViewLabelArray objectAtIndex:1] count] - 1) {
                [cell.detailTextLabel setFont:[FontCollection standardFontStyleWithSize:11.0f]];
                [cell.detailTextLabel setNumberOfLines:2];
            }
            break;
        }
        case 3: {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.detailTextLabel setText:@""];
            break;
        }
        case 4: {
            if (indexPath.row == 1) {
                [cell.detailTextLabel setText:@"编辑"];
                [cell.detailTextLabel setTextColor:[ColorCollection defaultBlueColor]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:@"选择"];
                [cell.detailTextLabel setTextColor:[ColorCollection defaultBlueColor]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        }
        case 5: {
            [cell.textLabel setFont:[FontCollection standardFontStyleWithSize:17.0f]];
            if (indexPath.row == 0) {
                [cell.textLabel setTextColor:[ColorCollection defaultBlueColor]];
            }
            else {
                [cell.textLabel setTextColor:[ColorCollection negativeUIColor]];
            }
            [cell.detailTextLabel setText:@""];
            break;
        }
        default: {
            // Should never be here
            break;
        }
    }
}

- (NSInteger)numberOfRowsInMasterTableViewForSection:(NSInteger)section
{
    return [[testDictionary objectForKey:[testSectionArray objectAtIndex:section]] count];
}

- (NSInteger)numberOfRowsInDetailTableViewForSection:(NSInteger)section
{
    return [[detailTableViewLabelArray objectAtIndex:section] count];
}

- (CGFloat)masterTableViewCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (CGFloat)detailTableViewCellHeightForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == [[detailTableViewLabelArray objectAtIndex:1] count] - 1) {
        return 60.0f;
    }
    return 40.0f;
}

#pragma mark <UIPickerViewDelegate&UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [availablePeople count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [availablePeople objectAtIndex:row];
}

#pragma mark <ButtonDelegate>

- (void)buttonTapped:(UIButton *)tappedButton
{
    if (tappedButton.tag == BUTTON_CANCEL) {
        [self dismissPickerView];
    }
    else if (tappedButton.tag == BUTTON_CONFIRM) {
        NSInteger selecedRow = [pickPersonView.pickerView selectedRowInComponent:0];
        selectedPerson = [pickPersonView.pickerView.delegate pickerView:pickPersonView.pickerView titleForRow:selecedRow forComponent:0];
        [self dismissPickerView];
    }
}

#pragma mark PickerView

- (void)showPickerView
{
    pickPersonView = [[CustomizePickerView alloc] initWithFrame:CGRectMake(self.view.center.x - 200.0f, self.view.bounds.size.height, 400.0f, 200.0f)];
    pickPersonView.delegate = self;
    pickPersonView.pickerView.delegate = self;
    pickPersonView.pickerView.dataSource = self;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view addSubview:pickPersonView];
        CGRect pickViewRect = pickPersonView.frame;
        pickViewRect.origin.y -= 195.0f;
        pickPersonView.frame = pickViewRect;
    } completion:^(BOOL finished) {
        pickPersonView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(pickPersonView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pickPersonView(==400)]" options:0 metrics:nil views:viewDictionary]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickPersonView(==200)]" options:0 metrics:nil views:viewDictionary]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pickPersonView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pickPersonView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:5.0f]];
    }];
}

- (void)dismissPickerView
{
    [UIView animateWithDuration:0.5f animations:^{
        CGRect pickViewRect = pickPersonView.frame;
        pickViewRect.origin.y += 195.0f;
        pickPersonView.frame = pickViewRect;
    } completion:^(BOOL finished) {
        if (finished) {
            [pickPersonView removeFromSuperview];
        }
    }];
}

#pragma mark Igonorable

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

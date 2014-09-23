//
//  MainController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/22.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "MainController.h"

NSString *const usrIdLabelHCons = @"H:|-30-[_usrIdLabel]";
NSString *const usrIdLabelVCons = @"V:|-30-[_usrIdLabel]";
NSString *const loginedImageViewHCons = @"H:[_usrIdLabel]-0-[_loginedImageView(==20)]";
NSString *const loginedImageViewVCons = @"V:[_loginedImageView(==20)]";
NSString *const usrInfoButtonHCons = @"H:[_usrInfoButton(==25)]";
NSString *const usrInfoButtonVCons = @"V:[_usrInfoButton(==25)]";

static NSString *const cellIndentifier = @"CollectionCell";

@interface MainController ()

@end

@implementation MainController

@synthesize usrIdLabel = _usrIdLabel;
@synthesize loginedImageView = _loginedImageView;
@synthesize usrInfoButton = _usrInfoButton;

@synthesize iconOrderDictionary;
@synthesize labelOrderDictionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self buildNavigationBar];
    [self buildContraintsOnUIElements];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    
    // Do any additional setup after loading the view.
}

- (void)prepareData
{
    // 在刚登录时准备数据
    // ...
    // 储存每个item的icon
    self.labelOrderDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"代办事宜", @(0), @"已办事宜", @(1), @"签报管理", @(2), @"会议管理", @(3), @"通知公告", @(4), @"收文管理", @(5), @"技术报告", @(6), @"采购合同", @(7), @"收入合同", @(8), @"双周工作汇报", @(9), @"阅览室", @(10), nil];
    self.iconOrderDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"done@2x"], @(0), [UIImage imageNamed:@"undone@2x"], @(1), [UIImage imageNamed:@"signature_management@2x"], @(2), [UIImage imageNamed:@"meeting_management@2x"], @(3), [UIImage imageNamed:@"bulletin@2x"], @(4), [UIImage imageNamed:@"document_management@2x"], @(5), [UIImage imageNamed:@"tech_report@2x"], @(6), [UIImage imageNamed:@"purchase_contract@2x"], @(7), [UIImage imageNamed:@"income_contract@2x"], @(8), [UIImage imageNamed:@"work_report@2x"], @(9), [UIImage imageNamed:@"reading@2x"], @(10), nil];
    self.title = @"返回主菜单";
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [ColorCollection titleBarColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Right baritem
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    logoutButton.layer.borderWidth = 1.0f;
    logoutButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    logoutButton.layer.cornerRadius = 5.0f;
    [logoutButton setTitle:@"登出" forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [logoutButton setTintColor:[UIColor whiteColor]];
    [logoutButton addTarget:self action:@selector(didSelectLogout) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    // Title baritem
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"西安市热工院办公自动化系统"];
    UIFont *fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [titleStr addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, [titleStr length])];
    //UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setAttributedText:titleStr];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)buildContraintsOnUIElements
{
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIndentifier];
    self.collectionView.delegate = self;
    // 用户名的Label
    NSMutableAttributedString *usrIdStr = [[NSMutableAttributedString alloc] initWithString:@"肖勇"];
    UIFont *fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [usrIdStr addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, [usrIdStr length])];
    self.usrIdLabel = [[UILabel alloc] init];
    self.usrIdLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.usrIdLabel sizeToFit];
    [self.usrIdLabel setAttributedText:usrIdStr];
    [self.usrIdLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.usrIdLabel];
    // 为用户名的Label添加约束
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_usrIdLabel);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrIdLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrIdLabelVCons options:0 metrics:nil views:viewDictionary]];
    // 指示用户当前登录成功的ImageView
    self.loginedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logined_status@2x"]];
    self.loginedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.loginedImageView];
    // 为指示用户当前登录成功的ImageView添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_usrIdLabel, _loginedImageView);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:loginedImageViewHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:loginedImageViewVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.loginedImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.usrIdLabel attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    // 获取用户信息的Button
    self.usrInfoButton = [[UIButton alloc] init];
    self.usrInfoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.usrInfoButton setBackgroundImage:[UIImage imageNamed:@"info_button_dark@2x"] forState:UIControlStateNormal];
    self.usrInfoButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.usrInfoButton];
    // 为获取用户信息的Button添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_usrInfoButton);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrInfoButtonHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrInfoButtonVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.usrInfoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.collectionView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.usrInfoButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.usrIdLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.view addConstraints:constraintsArray];
}

- (void)didSelectLogout
{
    [DialogCollection showAlertViewWithTitle:@"退出登录" andMessage:@"你确定要退出登录么?"cancelButton:@"取消" otherButton:@"确定" delagate:self];
}

// Registered delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 判断退出登录行为
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:true completion:^{
            NSLog(@"Logout");
        }];
    }
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 11;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    // Configure the cell
    // Constraints
    NSString *const iconImageHCons = @"H:|-1-[iconImageView(==78)]-1-|";
    NSString *const iconImageVCons = @"V:|-2-[iconImageView(==78)]";
    NSString *const iconLabelHCons = @"H:|-1-[iconLabel(==78)]-1-|";
    NSString *const iconLabelVCons = @"V:[iconImageView]-5-[iconLabel]";
    // Cell内部的view,一个容纳图标的ImageView一个容纳icon标题的Label
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [iconImageView setImage:[iconOrderDictionary objectForKey:@((int)indexPath.item)]];
    [cell addSubview:iconImageView];
    UILabel *iconLabel = [[UILabel alloc] init];
    iconLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [iconLabel setText:[labelOrderDictionary objectForKeyedSubscript:@((int)indexPath.item)]];
    [iconLabel setTextColor:[UIColor blackColor]];
    [iconLabel setTextAlignment:NSTextAlignmentCenter];
    iconLabel.numberOfLines = 2;
    [cell addSubview:iconLabel];
    // 添加界面约束
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(iconImageView);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:iconImageHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:iconImageVCons options:0 metrics:nil views:viewDictionary]];
    viewDictionary = NSDictionaryOfVariableBindings(iconImageView, iconLabel);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:iconLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:iconLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:iconLabelVCons options:0 metrics:nil views:viewDictionary]];
    [cell addConstraints:constraintsArray];
    return cell;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cellSelected = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1f animations:^{
        CGPoint p = cellSelected.center;
        p.x += 5;
        p.y += 5;
        cellSelected.center = p;
    } completion:^(BOOL finished) {
        if (finished) {
            if (indexPath.item == 7) {
                ContractViewController *contractViewController = [[ContractViewController alloc] init];
                [self.navigationController pushViewController:contractViewController animated:YES];
            }
            CGPoint p = cellSelected.center;
            p.x -= 5;
            p.y -= 5;
            cellSelected.center = p;
        }
    }];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

//
//  LoginViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/19.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "LoginViewController.h"

// Constrains
NSString *const titleLogoImageHCons = @"H:[_titleLogoImage(==200)]";
NSString *const titleLogoImageVCons = @"V:|-60-[_titleLogoImage(==33)]";
NSString *const usrNameTextFieldHCons = @"H:[_usrNameTextField(==350)]";
NSString *const usrNameTextFieldVCons = @"V:[_titleLogoImage]-60-[_usrNameTextField]";
NSString *const passwordTextFieldHCons = @"H:[_passwordTextField(==350)]";
NSString *const passwordTextFieldVCons = @"V:[_usrNameTextField]-10-[_passwordTextField]";
NSString *const loginButtonHCons = @"H:[_confirmLoginButton(==100)]";
NSString *const loginButtonVCons = @"V:[_passwordTextField]-30-[_confirmLoginButton(==30)]";

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UIView *inProgressView;
}

@synthesize titleLogoImage = _titleLogoImage;
@synthesize usrNameTextField = _usrNameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize confirmLoginButton = _confirmLoginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildingConstraintsOnUIElements];
    // Do any additional setup after loading the view from its nib.
}

- (void)login
{
    NSString *usrName = self.usrNameTextField.text;
    NSString *password = self.passwordTextField.text;
    if (usrName.length == 0 || password.length == 0) {
        [DialogCollection showAlertViewWithTitle:@"警告" andMessage:@"用户名密码不能为空" withLastingTime:1.0f delegate:self];
    }
    else {
        // 登录时为界面蒙上灰色阴影
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [maskView setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.5]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:maskView];
        // 显示指示正在登录的Progress view
        [DialogCollection showProgressView:@"正在登录" over:self.view];
        // 登录
        LoginClient *loginClient = [[LoginClient alloc] init];
        [loginClient loginUsing:usrName password:password completionHandler:^(bool isSuccess) {
            [[[self.view subviews] lastObject] removeFromSuperview];
            [maskView removeFromSuperview];
            if (isSuccess) {
                // 登录完成后使上述两个Subview消失
                [DialogCollection showAlertViewWithTitle:@"登录状态" andMessage:@"登录成功" withLastingTime:0.5f delegate:self];
                // 跳转到下一个View]
                UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
                collectionViewFlowLayout.itemSize = CGSizeMake(80, 110);
                collectionViewFlowLayout.minimumLineSpacing = 50;
                collectionViewFlowLayout.minimumInteritemSpacing = 30;
                collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
                collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(80.0f, 30.0f, 10.0f, 30.0f);
                MainController *mainController = [[MainController alloc] initWithCollectionViewLayout:collectionViewFlowLayout];
                UINavigationController *naviOnMainController = [[UINavigationController alloc] initWithRootViewController:mainController];
                naviOnMainController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:naviOnMainController animated:YES completion:^{
                    NSLog(@"Main Controller presented!");
                }];
            }
            else
            {
                [DialogCollection showAlertViewWithTitle:@"登录状态" andMessage:@"用户名或密码错误" withLastingTime:1.5f delegate:self];
            }
        }];
    }
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[ColorCollection titleBarColor]];
    // Right baritem
    UIButton *aboutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [aboutButton setTintColor:[UIColor whiteColor]];
    [aboutButton setBackgroundImage:[UIImage imageNamed:@"info_button@2x"] forState:UIControlStateNormal];
    [aboutButton addTarget:self action:@selector(showAboutDialog) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    // Title baritem
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"登录系统"];
    UIFont *fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [titleStr addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(0, 4)];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setAttributedText:titleStr];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = titleLabel;
}

- (void)buildingConstraintsOnUIElements
{
    // 判断系统版本,如为7.x将xib文件中的已有约束删除
    NSArray *iosVersion = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[iosVersion objectAtIndex:0] integerValue] == 7) {
            [self.view removeConstraints:self.view.constraints];
    }
    // 添加界面约束
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleLogoImage);
    // 顶部热工院Logo的界面约束
    self.titleLogoImage.contentMode = UIViewContentModeScaleAspectFit;
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLogoImageHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.titleLogoImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLogoImageVCons options:0 metrics:nil views:viewDictionary]];
    // 用户名输入框的界面约束
    viewDictionary = NSDictionaryOfVariableBindings(_titleLogoImage, _usrNameTextField);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrNameTextFieldHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.usrNameTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrNameTextFieldVCons options:0 metrics:nil views:viewDictionary]];
    // 密码输入框的界面约束
    viewDictionary = NSDictionaryOfVariableBindings(_usrNameTextField, _passwordTextField);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordTextFieldHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.passwordTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordTextFieldVCons options:0 metrics:nil views:viewDictionary]];
    // 登录按钮的界面约束
    viewDictionary = NSDictionaryOfVariableBindings(_passwordTextField, _confirmLoginButton);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:loginButtonHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:self.confirmLoginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:loginButtonVCons options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:constraintsArray];
    // 用户名,密码框显示细节的设置已在xib文件中设定,这里设定登录按钮的背景颜色和字体颜色
    [self.confirmLoginButton setTintColor:[UIColor whiteColor]];
    [self.confirmLoginButton setBackgroundColor:[ColorCollection titleBarColor]];
    [self.confirmLoginButton.layer setCornerRadius:10];
    [self.confirmLoginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showAboutDialog
{
    [DialogCollection showAlertViewWithTitle:@"关于" andMessage:@"西安热工院办公管理系统iPad客户端\n版本1.0.0.0" cancelButton:@"好的" otherButton:nil delagate:self];
}

// Registered delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 判断登录行为
}

// 登录界面支持所有屏幕方向
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
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

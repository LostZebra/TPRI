//
//  LoginViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/19.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "LoginViewController.h"

// ViewControllers
#import "MainController.h"

// StaticClasses
#import "ColorCollection.h"
#import "FontCollection.h"
#import "DialogCollection.h"

// Utilities
#import "LoginClient.h"
#import "GeneralStorage.h"

// Constrains
static NSString *const titleLogoImageHCons = @"H:[_titleLogoImage(==200)]";
static NSString *const titleLogoImageVCons = @"V:|-60-[_titleLogoImage(==33)]";
static NSString *const usrNameTextFieldHCons = @"H:[_usrNameTextField(==350)]";
static NSString *const usrNameTextFieldVCons = @"V:[_titleLogoImage]-60-[_usrNameTextField]";
static NSString *const passwordTextFieldHCons = @"H:[_passwordTextField(==350)]";
static NSString *const passwordTextFieldVCons = @"V:[_usrNameTextField]-10-[_passwordTextField]";
static NSString *const loginButtonHCons = @"H:[_confirmLoginButton(==100)]";
static NSString *const loginButtonVCons = @"V:[_passwordTextField]-30-[_confirmLoginButton(==30)]";

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    GeneralStorage *generalStorage;
    NSString *usrName;
    NSString *password;
}

@synthesize titleLogoImage = _titleLogoImage;
@synthesize usrNameTextField = _usrNameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize confirmLoginButton = _confirmLoginButton;

- (id)init
{
    self = [super init];
    if (self) {
        generalStorage = [GeneralStorage getSharedInstance];
        [self prepareUIElements];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildConstraintsOnUIElements];
    // 如果曾经登录过,获得曾经登录时使用的用户名,如果需要自动登录,则自动登录
    if ([generalStorage isUsrExisted]) {
        [self prepareDataAsyncWithCompletionHandler:^(BOOL isSuccess, NSError *error) {
            if (isSuccess && [generalStorage willAutoLogin]) {
                [self performLogin];
            }
        }];
    }
}

#pragma mark <BaseUIProtocol>

- (void)prepareDataAsyncWithCompletionHandler:(prepareDataAsyncCompletionHandler)completionHandler
{
    BOOL isPrepareDataSuccess = NO;
    NSDictionary *usrLoginData = [generalStorage getUsrLoginData];
    if (usrLoginData != nil) {
        isPrepareDataSuccess = YES;
        self.usrNameTextField.text = usrLoginData[@"Username"];
        self.passwordTextField.text = usrLoginData[@"Password"];
    }
    completionHandler(isPrepareDataSuccess, nil);
}

- (void)prepareUIElements
{
    // Logo
    self.titleLogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_logo@2x"]];
    self.titleLogoImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLogoImage.contentMode = UIViewContentModeScaleAspectFit;
    // 用户名输入框
    self.usrNameTextField = [[UITextField alloc] init];
    self.usrNameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.usrNameTextField.placeholder = @"用户名";
    self.usrNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.usrNameTextField.delegate = self;
    // 密码输入框
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordTextField.placeholder = @"密码";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.delegate = self;
    // 确认登录
    self.confirmLoginButton = [[UIButton alloc] init];
    self.confirmLoginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.confirmLoginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.confirmLoginButton.titleLabel.font = [FontCollection standardFontStyleWithSize:15.0f];
    [self.confirmLoginButton setTintColor:[ColorCollection whiteColor]];
    [self.confirmLoginButton setBackgroundColor:[ColorCollection titleBarColor]];
    [self.confirmLoginButton.layer setCornerRadius:10];
    [self.confirmLoginButton addTarget:self action:@selector(performLogin) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[ColorCollection titleBarColor]];
    [self.navigationController.navigationBar setTintColor:[ColorCollection whiteColor]];
    // Right baritem
    UIButton *aboutButton = [[UIButton alloc] init];
    [aboutButton.titleLabel setFont:[FontCollection standardFontStyleWithSize:17.0f]];
    [aboutButton setTitle:@"关于" forState:UIControlStateNormal];
    [aboutButton sizeToFit];
    [aboutButton addTarget:self action:@selector(showAboutDialog) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aboutButton];
    // Title baritem
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:17.0f]];
    [titleLabel setTextColor:[ColorCollection whiteColor]];
    [titleLabel setText:@"登录系统"];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (void)buildConstraintsOnUIElements
{
    [self.view setBackgroundColor:[ColorCollection whiteColor]];
    // 添加Subviews
    [self.view addSubview:_titleLogoImage];
    [self.view addSubview:_usrNameTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_confirmLoginButton];
    // 添加界面约束
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleLogoImage);
    // 顶部热工院Logo的界面约束
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLogoImageHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_titleLogoImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLogoImageVCons options:0 metrics:nil views:viewDictionary]];
    // 用户名输入框的界面约束
    viewDictionary = NSDictionaryOfVariableBindings(_titleLogoImage, _usrNameTextField);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrNameTextFieldHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_usrNameTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:usrNameTextFieldVCons options:0 metrics:nil views:viewDictionary]];
    // 密码输入框的界面约束
    viewDictionary = NSDictionaryOfVariableBindings(_usrNameTextField, _passwordTextField);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordTextFieldHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_passwordTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:passwordTextFieldVCons options:0 metrics:nil views:viewDictionary]];
    // 登录按钮的界面约束
    viewDictionary = NSDictionaryOfVariableBindings(_passwordTextField, _confirmLoginButton);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:loginButtonHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_confirmLoginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:loginButtonVCons options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSArray arrayWithArray:constraintsArray]];
}

#pragma mark SelfDefined

- (void)showAboutDialog
{
    [DialogCollection showAlertViewWithTitle:@"关于" andMessage:@"西安热工院办公管理系统iPad客户端\n版本1.0.0.0" cancelButton:@"好的" otherButton:nil delagate:self];
}

- (void)performLogin
{
    usrName = _usrNameTextField.text;
    password = _passwordTextField.text;
    if (usrName.length == 0 || password.length == 0) {
        [DialogCollection showAlertViewWithTitle:@"警告" andMessage:@"用户名密码不能为空" withLastingTime:1.0f delegate:self];
    }
    else {
        // 隐藏键盘
        [self.view endEditing:YES];
        // 登录时为界面蒙上灰色阴影
        UIView *maskView = [DialogCollection showMaskView];
        // 显示指示正在登录的Progress view
        [DialogCollection showProgressView:@"正在登录" over:self.view];
        [self loginWithCompletionHandler:^(BOOL isSuccess, NSError *error) {
                // 登录完成后使上述两个Subview消失
                [[[self.view subviews] lastObject] removeFromSuperview];
                [maskView removeFromSuperview];
                if (isSuccess) {
                    // 存储用户登录信息
                    [generalStorage registerUsrLocally:@{@"Username" : usrName , @"Password" : password}];
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
                        // Do nothing
                    }];
                }
                else {
                    // 显示登录失败
                    if (error != nil) {
                        [DialogCollection showAlertViewWithTitle:@"登录错误" andMessage:error.description withLastingTime:0.5f delegate:self];
                    }
                
                }
        }];
    }
}

- (void)loginWithCompletionHandler:(loginCompletionHandler)completionHandler
{
    // 登录
    LoginClient *loginClient = [[LoginClient alloc] init];
    [loginClient loginUsing:usrName password:password completionHandler:completionHandler];
}

#pragma mark <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_usrNameTextField.text.length == 0 || _passwordTextField.text.length == 0) {
        [self.view endEditing:YES];
    }
    else {
        // 按回车键直接登录
        [self performLogin];
    }
    return YES;
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

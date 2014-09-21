//
//  LoginViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/19.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ColorCollection.h"
#import "DialogCollection.h"

@interface LoginViewController : UIViewController<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *titleLogoImage;
@property (strong, nonatomic) IBOutlet UITextField *usrNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *confirmLoginButton;

@end

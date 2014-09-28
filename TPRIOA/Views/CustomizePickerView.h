//
//  CustomizePickerView.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/28.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ButtonDelegate.h"

@interface CustomizePickerView : UIView

@property UIButton *cancelButton;
@property UIButton *confirmButton;
@property UIPickerView *pickerView;

@property id<ButtonDelegate> delegate;

typedef NS_ENUM(NSInteger, ButtonType)
{
    BUTTON_CANCEL,
    BUTTON_CONFIRM
};

@end

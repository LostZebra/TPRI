//
//  CustomizePickerView.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/28.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "CustomizePickerView.h"

// StaticClasses
#import "ColorCollection.h"

static NSString *const cancelButtonHCons = @"H:|-10-[_cancelButton(==50)]";
static NSString *const cancelButtonVCons = @"V:|-5-[_cancelButton(==20)]";
static NSString *const confirmButtonHCons = @"H:[_confirmButton(==50)]-10-|";
static NSString *const confirmButtonVCons = @"V:|-5-[_confirmButton(==20)]";
static NSString *const pickerViewVCons = @"V:[_confirmButton]-0-[_pickerView]-0-|";

@implementation CustomizePickerView

@synthesize cancelButton = _cancelButton;
@synthesize confirmButton = _confirmButton;
@synthesize pickerView = _pickerView;

@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [ColorCollection whiteColor];
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [[ColorCollection darkGrayColor] CGColor];
        
        self.cancelButton = [[UIButton alloc] init];
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[ColorCollection darkGrayColor] forState:UIControlStateNormal];
        self.cancelButton.tag = BUTTON_CANCEL;
        [self.cancelButton addTarget:_delegate action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        self.confirmButton = [[UIButton alloc] init];
        self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[ColorCollection defaultBlueColor] forState:UIControlStateNormal];
        self.confirmButton.tag = BUTTON_CONFIRM;
        [self.confirmButton addTarget:_delegate action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmButton];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pickerView];
        
        // 添加约束
        [self buildConstraintsOnUIElements];
    }
    return self;
}

- (void)buildConstraintsOnUIElements
{
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_cancelButton);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:cancelButtonHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:cancelButtonVCons options:0 metrics:nil views:viewDictionary]];
    
    viewDictionary = NSDictionaryOfVariableBindings(_confirmButton);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:confirmButtonHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:confirmButtonVCons options:0 metrics:nil views:viewDictionary]];
    
    viewDictionary = NSDictionaryOfVariableBindings(_confirmButton, _pickerView);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:pickerViewVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [self addConstraints:constraintsArray];
}

- (void)cancelButtonTapped
{
    [self.delegate buttonTapped:_cancelButton];
}

- (void)confirmButtonTapped
{
    [self.delegate buttonTapped:_confirmButton];
}

@end

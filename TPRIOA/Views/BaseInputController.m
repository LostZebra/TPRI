//
//  BaseInputController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/10/8.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "BaseInputController.h"

// StaticClasses
#import "FontCollection.h"
#import "ColorCollection.h"

static NSString *const inputTextFieldVCons = @"V:|-40-[_inputTextField(==80)]";

@implementation BaseInputController
{
    NSInteger maxNumOfCharacters;
    BOOL isCharacterEnabled;
    UILabel *characterCountLabel;
}

@synthesize inputTextField = _inputTextField;
@synthesize delegate = _delegate;

- (id)init
{
    return [self initWithCharacterCount:NO maxNumberOfCharacters:0];
}

- (instancetype)initWithCharacterCount:(BOOL)enableCharacterCount maxNumberOfCharacters:(NSInteger)numOfCharacters
{
    self = [super init];
    if (self) {
        isCharacterEnabled = enableCharacterCount;
        maxNumOfCharacters = numOfCharacters;
        if (isCharacterEnabled == YES && maxNumOfCharacters <= 0) {
            NSString *errorStr = @"不能在启用字符计数的情况下同时最大字数为0或负数";
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:errorStr userInfo:nil];
        }
        [self prepareUIElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildConstraintsOnUIElements];
}

- (void)prepareUIElements
{
    self.inputTextField = [[UITextView alloc] init];
    self.inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputTextField.scrollEnabled = YES;
    self.inputTextField.returnKeyType = UIReturnKeyDone;
    self.inputTextField.textColor = [ColorCollection defaultTextColor];
    self.inputTextField.font = [FontCollection standardFontStyleWithSize:15.0f];
    // 如果启用字符统计
    if (isCharacterEnabled == YES) {
        characterCountLabel = [[UILabel alloc] init];
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        characterCountLabel.backgroundColor = [ColorCollection tableViewHeaderColor];
        characterCountLabel.text = [NSString stringWithFormat:@"%ld", maxNumOfCharacters];
        characterCountLabel.textAlignment = NSTextAlignmentRight;
        characterCountLabel.textColor = [ColorCollection headerViewTextColor];
    }
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[ColorCollection titleBarColor]];
    [self.navigationController.navigationBar setTintColor:[ColorCollection whiteColor]];
    // Title baritem
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:17.0f]];
    [titleLabel setTextColor:[ColorCollection whiteColor]];
    self.navigationItem.titleView = titleLabel;
    // Left baritem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissControllerWithNoChange)];
}

- (void)buildConstraintsOnUIElements
{
    self.view.backgroundColor = [ColorCollection tableViewHeaderColor];
    // 添加Subviews
    [self.view addSubview:_inputTextField];
    // 为文本输入框添加约束
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_inputTextField);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:inputTextFieldVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_inputTextField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_inputTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    if (isCharacterEnabled == YES) {
        [self.view addSubview:characterCountLabel];
        // 为字符统计Label添加约束
        NSString *const characterCountLabelHCons = @"H:[characterCountLabel(==40)]-10-|";
        NSString *const characterCountLabelVCons = @"V:[_inputTextField]-5-[characterCountLabel]";
        viewDictionary = NSDictionaryOfVariableBindings(_inputTextField, characterCountLabel);
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:characterCountLabelHCons options:0 metrics:nil views:viewDictionary]];
        [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:characterCountLabelVCons options:0 metrics:nil views:viewDictionary]];
    }
    [self.view addConstraints:constraintsArray];
}

#pragma mark SelfDefined

- (void)characterRemain:(NSInteger)remain
{
    if (isCharacterEnabled == YES) {
        characterCountLabel.text = [NSString stringWithFormat:@"%ld", remain];
    }
}

- (void)dismissControllerWithNoChange
{
    [self dismissViewControllerAnimated:YES completion:^{
        // Do nothing
    }];
}

@end


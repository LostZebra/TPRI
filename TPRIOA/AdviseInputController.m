//
//  AdviseInputController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/10/8.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "AdviseInputController.h"

@implementation AdviseInputController
{
    NSInteger maxNumOfCharacter;
    BOOL isCharacterCountEnabled;
    // 载入已有字符,"尚未填写"除外
    NSString *inputTextFieldInitialStr;
}

- (id)init
{
    return [self initWithCharacterCount:NO maxNumberOfCharacters:0];
}

- (instancetype)initWithCharacterCount:(BOOL)enableCharacterCount maxNumberOfCharacters:(NSInteger)numOfCharacters
{
    self = [super initWithCharacterCount:enableCharacterCount maxNumberOfCharacters:numOfCharacters];
    if (self) {
        isCharacterCountEnabled = enableCharacterCount;
        maxNumOfCharacter = numOfCharacters;
    }
    return self;
}

- (instancetype)initWithMaxNumberOfCharacters:(NSInteger)numOfCharacters andInitialCharacters:(NSString *)initialStr
{
    self = [self initWithCharacterCount:YES maxNumberOfCharacters:numOfCharacters];
    if (self) {
        if ([initialStr isEqualToString:@"尚未填写"] == NO) {
            inputTextFieldInitialStr = [[NSString alloc] initWithString:initialStr];
        }
        [self prepareUIElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildNavigationBar];
}

- (void)prepareUIElements
{
    [super prepareUIElements];
    self.inputTextField.text = inputTextFieldInitialStr;
    self.inputTextField.delegate = self;
    // 初始化时刷新字符统计
    if (isCharacterCountEnabled) {
        [self textViewDidChange:self.inputTextField];
    }
}

- (void)buildNavigationBar
{
    [super buildNavigationBar];
    // Title baritem
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    titleLabel.text = @"输入意见";
    [titleLabel sizeToFit];
    // Right baritem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(dismissControllerWithChange)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView
{
    if (isCharacterCountEnabled) {
        NSInteger numOfCharacter = [self.inputTextField.text length];
        self.inputTextField.userInteractionEnabled = numOfCharacter > maxNumOfCharacter ? NO : YES;
        self.navigationItem.rightBarButtonItem.enabled = (numOfCharacter > 0 && numOfCharacter <= maxNumOfCharacter) ? YES : NO;
        [self characterRemain:maxNumOfCharacter - numOfCharacter];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        // 换行键按下时即完成编辑
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark SelfDefined

- (void)dismissControllerWithChange
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate saveText:self.inputTextField.text];
    }];
}

@end

//
//  BaseInputController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/10/8.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseUIProtocol.h"
#import "SaveInputDelegate.h"

@interface BaseInputController : UIViewController<BaseUIProtocol>

@property (strong, nonatomic) UITextView *inputTextField;

@property id<SaveInputDelegate> delegate;

- (instancetype)initWithCharacterCount:(BOOL)enableCharacterCount maxNumberOfCharacters:(NSInteger)numOfCharacters;
- (void)characterRemain:(NSInteger)remain;

@end

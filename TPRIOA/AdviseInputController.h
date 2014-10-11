//
//  AdviseInputController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/10/8.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "BaseInputController.h"

@interface AdviseInputController : BaseInputController<UITextViewDelegate>

- (instancetype)initWithMaxNumberOfCharacters:(NSInteger)numOfCharacters andInitialCharacters:(NSString *)initialStr;

@end

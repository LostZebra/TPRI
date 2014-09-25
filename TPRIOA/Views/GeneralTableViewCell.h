//
//  GeneralTableViewCell.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// StaticClasses
#import "FontCollection.h"

@interface GeneralTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *departmentLabel;
@property (strong, nonatomic) UILabel *statusLabel;

- (void)cellConfigureWithPreHandler: (void (^)(void))pb;

@end

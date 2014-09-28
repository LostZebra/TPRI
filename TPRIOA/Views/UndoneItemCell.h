//
//  UndoneItemCell.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

// StaticClasses
#import "FontCollection.h"

@interface UndoneItemCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *fromLabel;
@property (strong, nonatomic) UILabel *dateLabel;

- (void)cellConfigureWithPreHandler: (void (^)(void))pb;

@end

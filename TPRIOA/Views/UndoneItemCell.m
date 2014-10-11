//
//  UndoneItemCell.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "UndoneItemCell.h"

static NSString *const fromLabelHCons = @"H:|-20-[_fromLabel]";
static NSString *const fromLabelVCons = @"V:|-5-[_fromLabel]";
static NSString *const titleLabelHCons = @"H:|-20-[_titleLabel]";
static NSString *const titleLabelVCons = @"V:[_fromLabel]-5-[_titleLabel]";
static NSString *const dateLabelHCons = @"[_dateLabel]-5-|";

@implementation UndoneItemCell

@synthesize titleLabel = _titleLabel;
@synthesize fromLabel = _fromLabel;
@synthesize dateLabel = _dateLabel;

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"This function should never be called!");
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 标题
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
        self.titleLabel.numberOfLines = 2;
        [self.titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        // 部门
        self.fromLabel = [[UILabel alloc] init];
        [self.fromLabel setFont:[FontCollection standardFontStyleWithSize:10.0F]];
        self.fromLabel.numberOfLines = 1;
        [self.fromLabel setTextColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:_fromLabel];
        // 状态
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFont:[FontCollection standardFontStyleWithSize:10.0f]];
        [self.dateLabel setTextAlignment:NSTextAlignmentRight];
        self.dateLabel.numberOfLines = 1;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)cellConfigureWithPreHandler: (void (^)(void))pb
{
    pb();
    // 为标题添加约束
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_fromLabel, _titleLabel);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLabelVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.75f constant:0.0f]];
    // 为部门添加约束
    self.fromLabel.translatesAutoresizingMaskIntoConstraints = NO;
    viewDictionary = NSDictionaryOfVariableBindings(_fromLabel);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:fromLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:fromLabelVCons options:0 metrics:nil views:viewDictionary]];
    // 为状态添加约束
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    viewDictionary = NSDictionaryOfVariableBindings(_dateLabel);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:dateLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.20f constant:0.0f]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_fromLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.contentView addConstraints:[NSArray arrayWithArray:constraintsArray]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

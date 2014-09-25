//
//  GeneralTableViewCell.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "GeneralTableViewCell.h"

NSString *const titleLabelHCons = @"H:|-20-[_titleLabel]";
NSString *const titleLabelVCons = @"V:|-10-[_titleLabel]";
NSString *const departmentLabelHCons = @"H:|-20-[_departmentLabel]";
NSString *const departmentLabelVCons = @"V:[_departmentLabel]-(>=5)-|";
NSString *const statusLabelHCons = @"H:[_titleLabel]-5-[_statusLabel]-5-|";
NSString *const statusLabelVCons = @"V:|-10-[_statusLabel]";

@implementation GeneralTableViewCell

@synthesize titleLabel = _titleLabel;
@synthesize departmentLabel = _departmentLabel;
@synthesize statusLabel = _statusLabel;

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"This function should never be called!");
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 标题
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:15.0f]];
        _titleLabel.numberOfLines = 2;
        [_titleLabel sizeToFit];
        [self.contentView addSubview:_titleLabel];
        // 部门
        _departmentLabel = [[UILabel alloc] init];
        [_departmentLabel setFont:[FontCollection standardFontStyleWithSize:12.0F]];
        _departmentLabel.numberOfLines = 1;
        [self.contentView addSubview:_departmentLabel];
        // 状态
        _statusLabel = [[UILabel alloc] init];
        [_statusLabel setFont:[FontCollection standardFontStyleWithSize:9.0f]];
        [_statusLabel setTextAlignment:NSTextAlignmentRight];
        _statusLabel.numberOfLines = 1;
        [self.contentView addSubview:_statusLabel];
    }
    return self;
}

- (void)cellConfigureWithPreHandler: (void (^)(void))pb
{
    pb();
    // 为标题添加约束
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_titleLabel);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:titleLabelVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.75f constant:0.0f]];
    // [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5f constant:0.0f]];
    // 为部门添加约束
    _departmentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    viewDictionary = NSDictionaryOfVariableBindings(_titleLabel, _departmentLabel);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:departmentLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:departmentLabelVCons options:0 metrics:nil views:viewDictionary]];
    // 为状态添加约束
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    viewDictionary = NSDictionaryOfVariableBindings(_titleLabel, _statusLabel);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:statusLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:statusLabelVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_statusLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.20f constant:0.0f]];
    [self.contentView addConstraints:[NSArray arrayWithArray:constraintsArray]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

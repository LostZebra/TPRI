//
//  GeneralTableViewCell.m
//  TPRIOA
//
//  Created by xiaoyong on 14/9/23.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "GeneralTableViewCell.h"

NSString *const titleLabelHCons = @"H:|-5-[_titleLabel]";
NSString *const lastModifiedLabelHCons = @"H:[_lastModifiedLabel]-5-|";
NSString *const lastModifiedLabelVCons = @"V:|-5-[_lastModifiedLabel]";

@implementation GeneralTableViewCell

@synthesize titleLabel = _titleLabel;
@synthesize lastModifiedLabel = _lastModifiedLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Do customization here
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

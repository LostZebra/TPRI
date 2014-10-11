//
//  BaseSplitViewProtocol.h
//  TPRIOA
//
//  Created by xiaoyong on 14/9/26.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol BaseSplitViewProtocol <NSObject>

@optional
- (void)configureMasterTableViewCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)configureDetailTableViewCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfRowsInMasterTableViewForSection:(NSInteger)section;
- (NSInteger)numberOfRowsInDetailTableViewForSection:(NSInteger)section;
- (CGFloat)masterTableViewCellHeightForIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)detailTableViewCellHeightForIndexPath:(NSIndexPath *)indexPath;

@end


//
//  PhotoGalleryViewController.h
//  TPRIOA
//
//  Created by xiaoyong on 14/10/10.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseUIProtocol.h"

typedef NS_ENUM(NSInteger, PhotoLoadError)
{
    PHOTODOWNLOADERROR = 0x0001,
    PHOTOFORMATMISMATCH,
    PHOTOLOADINTERNALERROR
};

@interface PhotoGalleryViewController : UIViewController<BaseUIProtocol, UIActionSheetDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *photoGalleryScrollView;
@property (strong, nonatomic) UIPageControl *photoPageControl;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end

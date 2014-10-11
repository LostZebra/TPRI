//
//  PhotoGalleryViewController.m
//  TPRIOA
//
//  Created by xiaoyong on 14/10/10.
//  Copyright (c) 2014年 xiaoyong. All rights reserved.
//

#import "PhotoGalleryViewController.h"

// StaticClasses
#import "FontCollection.h"
#import "ColorCollection.h"
#import "DialogCollection.h"

// Utilities
#import "GeneralStorage.h"

// Constraints
static NSString *const descriptionLabelHCons = @"H:|-0-[_descriptionLabel]-0-|";
static NSString *const descriptionLabelVCons = @"V:[_descriptionLabel(==40)]-0-|";
static NSString *const photoPageControlVCons = @"V:[_photoPageControl]-10-[_descriptionLabel]";

// Space placeholder
static NSString *const internalSpace = @"   ";

@implementation PhotoGalleryViewController
{
    NSInteger currentIndex;
    NSArray *imageArray;
    // Screen
    CGFloat screenWidth;
    CGFloat screenHeight;
    // Previes Orientation
    UIInterfaceOrientation previousOrientation;
}

@synthesize photoGalleryScrollView = _photoGalleryScrollView;
@synthesize photoPageControl = _photoPageControl;
@synthesize descriptionLabel = _descriptionLabel;

- (id)init
{
    self = [super init];
    if (self) {
        // Photos(Testing)
        imageArray = @[[UIImage imageNamed:@"Test1"], [UIImage imageNamed:@"Test2"], [UIImage imageNamed:@"Test3"], [UIImage imageNamed:@"Test4"]];
        // Initial photo index
        currentIndex = 0;
        // Previews orientation
        previousOrientation = self.interfaceOrientation;
        // Official
        [self prepareUIElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildNavigationBar];
    [self buildConstraintsOnUIElements];
    // 添加Imageviews
    [self prepareDataAsyncWithCompletionHandler:^(BOOL isSuccess, NSError *error) {
        if (error) {
            [DialogCollection showAlertViewWithTitle:@"错误" andMessage:@"载入附件出错" withLastingTime:0.5f delegate:self];
        }
        [[[self.view subviews] lastObject] removeFromSuperview];
    }];
}

- (void)prepareUIElements
{
    // 初始化各Subviews的实例
    // 展示图片的Scrollview
    self.photoGalleryScrollView = [[UIScrollView alloc] init];
    self.photoGalleryScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoGalleryScrollView.pagingEnabled = YES;
    self.photoGalleryScrollView.delegate = self;
    // 控制当前图片位置的Pagecontroll
    self.photoPageControl = [[UIPageControl alloc] init];
    self.photoPageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoPageControl.numberOfPages = [imageArray count];      // 初始时显示的是第一张图片,长度为附件中图片的数量
    self.photoPageControl.currentPage = 0;
    [self.photoPageControl sizeToFit];
    // 图片的描述Label
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.backgroundColor = [ColorCollection clearColor];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@%@", internalSpace, @"图片描述"];
    self.descriptionLabel.font = [FontCollection standardFontStyleWithSize:12.0f];
    self.descriptionLabel.textColor = [ColorCollection whiteColor];
    
}

- (void)prepareDataAsyncWithCompletionHandler:(prepareDataAsyncCompletionHandler)completionHandler
{
    [DialogCollection showProgressView:@"正在加载" over:self.view];
    dispatch_time_t delay_time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC));
    dispatch_after(delay_time, dispatch_get_main_queue(), ^{
        NSError *error = nil;
        BOOL isSuccess = [self fetchRemoteData];
        if (isSuccess) {
            [self loadImages];
        }
        else {
            error = [NSError errorWithDomain:@"PhotoGalleryViewController" code:PHOTODOWNLOADERROR userInfo:@{NSLocalizedDescriptionKey : @"图片加载错误"}];
        }
        completionHandler(isSuccess, error);
    });
}

- (void)buildNavigationBar
{
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBarTintColor:[ColorCollection defaultTextColor]];
    [self.navigationController.navigationBar setTintColor:[ColorCollection defaultBlueColor]];
    // Title baritem
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[NSString stringWithFormat:@"%ld/%lu", currentIndex + 1, [imageArray count]]];
    [titleLabel setFont:[FontCollection standardBoldFontStyleWithSize:17.0f]];
    [titleLabel setTextColor:[ColorCollection whiteColor]];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    // Left baritem
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
    // Right baritem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSavePhotoMenu)];
}

- (void)buildConstraintsOnUIElements
{
    self.view.backgroundColor = [ColorCollection defaultTextColor];
    // 判断初始时的屏幕方向
    if (previousOrientation == UIInterfaceOrientationPortrait || previousOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        screenWidth = self.view.bounds.size.width;
        screenHeight = self.view.bounds.size.height;
    }
    else {
        screenWidth = self.view.bounds.size.height;
        screenHeight = self.view.bounds.size.width;
    }
    // 添加Subviews
    [self.view addSubview:_photoGalleryScrollView];
    [self.view addSubview:_photoPageControl];
    [self.view addSubview:_descriptionLabel];
    // 为图片的Scrollview添加约束
    self.photoGalleryScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    // 为Pagecontrol添加约束
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_photoPageControl, _descriptionLabel);
    NSMutableArray *constraintsArray = [[NSMutableArray alloc] init];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:photoPageControlVCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObject:[NSLayoutConstraint constraintWithItem:_photoPageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    // 为Descriptionlabel添加约束
    viewDictionary = NSDictionaryOfVariableBindings(_descriptionLabel);
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:descriptionLabelHCons options:0 metrics:nil views:viewDictionary]];
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:descriptionLabelVCons options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:constraintsArray];
}

- (BOOL)fetchRemoteData
{
    return YES;
}

#pragma mark <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self saveCurrent];
            break;
        case 1:
            [self saveAll];
            break;
        default:
            [actionSheet dismissWithClickedButtonIndex:actionSheet.destructiveButtonIndex animated:YES];
            break;
    }
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    currentIndex = lround(scrollView.contentOffset.x / scrollView.frame.size.width);
    self.photoPageControl.currentPage = currentIndex;
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    titleLabel.text = [NSString stringWithFormat:@"%ld/%lu", currentIndex + 1, [imageArray count]];
}

#pragma mark SelfDefined

- (void)loadImages
{
    for (int i = 0; i < [imageArray count]; i++) {
        CGRect frame = CGRectMake(screenWidth * i, 0, screenWidth, screenHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [imageArray objectAtIndex:i];
        [self.photoGalleryScrollView addSubview:imageView];
    }
    self.photoGalleryScrollView.contentSize = CGSizeMake(screenWidth * [imageArray count], screenHeight / 2);
}

- (void)removeImages
{
    for (int i = 0; i < [[self.photoGalleryScrollView subviews] count]; i++) {
        [[[self.photoGalleryScrollView subviews] lastObject] removeFromSuperview];
    }
}

- (void)resetScrollViewInOrientation:(UIInterfaceOrientation)newOrientation
{
    if ((newOrientation == UIInterfaceOrientationPortrait || newOrientation ==UIInterfaceOrientationPortraitUpsideDown) && (previousOrientation == UIInterfaceOrientationLandscapeLeft || previousOrientation == UIInterfaceOrientationLandscapeRight)) {
        [self rescaleScreen];
        self.photoGalleryScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    else if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight) && (previousOrientation == UIInterfaceOrientationPortrait || previousOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        [self rescaleScreen];
        self.photoGalleryScrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    }
    previousOrientation = newOrientation;
}

// 屏幕旋转时重新计算宽和高
- (void)rescaleScreen
{
    NSInteger temp = screenWidth;
    screenWidth = screenHeight;
    screenHeight = temp;
}

- (void)showSavePhotoMenu
{
    UIActionSheet *savePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"保存到本地" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"保存本张", @"保存全部", nil];
    [savePhotoActionSheet showInView:self.view];
}

- (void)saveCurrent
{
    [[GeneralStorage getSharedInstance] savePhoto:[imageArray objectAtIndex:currentIndex] withCompletionHandler:^(NSURL *assetURL, NSError *error) {
        if (error) {
            [DialogCollection showAlertViewWithTitle:@"提示" andMessage:error.localizedDescription withLastingTime:0.5f delegate:self];
        }
        else {
            [DialogCollection showAlertViewWithTitle:@"提示" andMessage:@"保存照片成功" withLastingTime:0.5f delegate:self];
        }
    }];
}

- (void)saveAll
{
    [[GeneralStorage getSharedInstance] savePhotos:imageArray withCompletionHandler:^(NSURL *assetURL, NSError *error) {
        if (error) {
            [DialogCollection showAlertViewWithTitle:@"提示" andMessage:error.localizedDescription withLastingTime:0.5f delegate:self];
        }
        else {
            [DialogCollection showAlertViewWithTitle:@"提示" andMessage:@"保存照片成功" withLastingTime:0.5f delegate:self];
        }
    }];
}

- (void)dismissController
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self removeImages];
    [self dismissViewControllerAnimated:YES completion:^{
        // Do nothing
    }];
}

#pragma mark Ignorable

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self removeImages];
    [self resetScrollViewInOrientation:toInterfaceOrientation];
    [self loadImages];
}

@end

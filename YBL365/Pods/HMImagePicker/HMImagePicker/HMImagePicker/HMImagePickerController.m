//
//  HMImagePickerController.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/26.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMImagePickerController.h"
#import "HMAlbumTableViewController.h"

NSString *const HMImagePickerDidSelectedNotification = @"HMImagePickerDidSelectedNotification";
NSString *const HMImagePickerDidSelectedAssetsKey = @"HMImagePickerDidSelectedAssetsKey";
NSString *const HMImagePickerBundleName = @"HMImagePicker.bundle";

/// 默认选择图像大小
#define HMImagePickerDefaultSize    CGSizeMake(600, 600)

@interface HMImagePickerController ()

@end

@implementation HMImagePickerController {
    HMAlbumTableViewController *_rootViewController;
    /// 选中素材数组
    NSMutableArray <PHAsset *> *_selectedAssets;
}

#pragma mark - 构造函数

- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets {
    self = [super init];
    
    if (self) {
        if (selectedAssets == nil) {
            _selectedAssets = [NSMutableArray array];
        } else {
            _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        }
        
        _rootViewController = [[HMAlbumTableViewController alloc] initWithSelectedAssets:_selectedAssets];
        // 默认最大选择图像数量
        self.maxPickerCount = 9;
        
        [self pushViewController:_rootViewController animated:NO];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(didFinishedSelectAssets:)
         name:HMImagePickerDidSelectedNotification
         object:nil];
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"请调用 `-initWithSelectedAssets:`");
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMImagePickerDidSelectedNotification object:nil];
}

#pragma mark - getter & setter 方法
- (CGSize)targetSize {
    if (CGSizeEqualToSize(_targetSize, CGSizeZero)) {
        _targetSize = HMImagePickerDefaultSize;
    }
    return _targetSize;
}

- (void)setMaxPickerCount:(NSInteger)maxPickerCount {
    _rootViewController.maxPickerCount = maxPickerCount;
}

- (NSInteger)maxPickerCount {
    return _rootViewController.maxPickerCount;
}

#pragma mark - 监听方法
- (void)didFinishedSelectAssets:(NSNotification *)notification {
    
    if (![self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishSelectedImages:selectedAssets:)] || _selectedAssets == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    [self requestImages:_selectedAssets completed:^(NSArray<UIImage *> *images) {
        [self.pickerDelegate imagePickerController:self didFinishSelectedImages:images selectedAssets:_selectedAssets.copy];
    }];
}

#pragma mark - UINavigationController 父类方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.toolbarHidden = [viewController isKindOfClass:[HMAlbumTableViewController class]];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    
    self.toolbarHidden = (self.viewControllers.count == 1);
    self.hidesBarsOnTap = NO;
    
    return viewController;
}

#pragma mark - 请求图像方法
/// 根据 PHAsset 数组，统一查询用户选中图像
///
/// @param selectedAssets 用户选中 PHAsset 数组
/// @param completed      完成回调，缩放后的图像数组在回调参数中
- (void)requestImages:(NSArray <PHAsset *> *)selectedAssets completed:(void (^)(NSArray <UIImage *> *images))completed {
    
    /// 图像请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 设置 resizeMode 可以按照指定大小缩放图像
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 设置 deliveryMode 为 HighQualityFormat 可以只回调一次缩放之后的图像，否则会调用多次
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // 设置加载图像尺寸(以像素为单位)
    CGSize targetSize = self.targetSize;
    
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    
    for (NSInteger i = 0; i < selectedAssets.count; i++) {
        [images addObject:[UIImage new]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    NSInteger i = 0;
    for (PHAsset *asset in selectedAssets) {
        
        dispatch_group_enter(group);
        
        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:targetSize
         contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             [images replaceObjectAtIndex:i withObject:result];
             
             dispatch_group_leave(group);
         }];
        i++;
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completed(images.copy);
    });
}

@end

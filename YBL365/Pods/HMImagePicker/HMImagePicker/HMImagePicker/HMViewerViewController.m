//
//  HMViewerViewController.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMViewerViewController.h"

@interface HMViewerViewController () <UIScrollViewDelegate>

@end

@implementation HMViewerViewController {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [[PHImageManager defaultManager]
     requestImageForAsset:_asset
     targetSize:[UIScreen mainScreen].bounds.size
     contentMode:PHImageContentModeAspectFill
     options:options
     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         _imageView.image = result;
         
         [self setImageViewPosition];
     }];
}

- (void)setImageViewPosition {
    
    CGSize size = [self displaySize:_imageView.image];
    
    _imageView.transform = CGAffineTransformIdentity;
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    _scrollView.contentSize = size;
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    
    if (size.height < _scrollView.bounds.size.height) {
        
        CGFloat y = (_scrollView.bounds.size.height - size.height) * 0.5;
        
        _scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    }
}

/// 根据视图大小，等比例计算图像缩放大小
///
/// @param image 图像
///
/// @return 缩放后的大小
- (CGSize)displaySize:(UIImage *)image {
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = image.size.height * w / image.size.width;
    
    return CGSizeMake(w, h);
}

#pragma mark - 视图生命周期
- (void)loadView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view = _scrollView;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    _imageView = [[UIImageView alloc] init];
    [_scrollView addSubview:_imageView];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImageViewPosition];
    });
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGFloat offsetY = (_scrollView.bounds.size.height - view.frame.size.height) * 0.5;
    CGFloat offsetX = (_scrollView.bounds.size.width - view.frame.size.width) * 0.5;
    
    offsetY = offsetY < 0 ? 0 : offsetY;
    offsetX = offsetX < 0 ? 0 : offsetX;
    
    _scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0);
}

@end

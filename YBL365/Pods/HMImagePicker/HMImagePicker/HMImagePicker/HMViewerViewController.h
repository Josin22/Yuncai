//
//  HMViewerViewController.h
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface HMViewerViewController : UIViewController
/// 图像索引
@property (nonatomic) NSUInteger index;
/// 图像资源
@property (nonatomic) PHAsset *asset;
@end

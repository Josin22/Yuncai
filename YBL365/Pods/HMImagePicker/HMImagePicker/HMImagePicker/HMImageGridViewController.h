//
//  HMImageGridViewController.h
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/26.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMAlbum.h"

/// 多图选择控制器
@interface HMImageGridViewController : UICollectionViewController
/// 构造函数
///
/// @param album          相册模型
/// @param selectedAssets 选中资源数组
/// @param maxPickerCount 最大选择数量
///
/// @return 多图选择控制器
- (instancetype)initWithAlbum:(HMAlbum *)album
               selectedAssets:(NSMutableArray <PHAsset *> *)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount;
@end

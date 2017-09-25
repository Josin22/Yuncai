//
//  HMImageGridViewLayout.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMImageGridViewLayout.h"

/// 最小 Cell 宽高
#define HMGridCellMinWH 104

@implementation HMImageGridViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat margin = 2;
    CGFloat itemWH = [self itemWHWithCount:3 margin:margin];
    
    self.itemSize = CGSizeMake(itemWH, itemWH);
    self.minimumInteritemSpacing = margin;
    self.minimumLineSpacing = margin;
    self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
}

- (CGFloat)itemWHWithCount:(NSInteger)count margin:(CGFloat)margin {
    
    CGFloat itemWH = 0;
    CGSize size = self.collectionView.bounds.size;
    
    do {
        itemWH = floor((size.width - (count + 1) * margin) / count);
        count++;
    } while (itemWH > HMGridCellMinWH);
    
    
    return itemWH;
}

@end

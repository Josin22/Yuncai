//
//  YBLGoodGridFlowLayout.m
//  YC168
//
//  Created by 乔同新 on 2017/6/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodGridFlowLayout.h"

@implementation YBLGoodGridFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 5;
        self.minimumLineSpacing = 5;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(5, 5, kNavigationbarHeight+5, 5);
        CGFloat width = GridViewItemWidth;
        CGFloat hi = GridViewItemHeight;
        self.itemSize = CGSizeMake(width, hi);
    }
    return self;
}

@end

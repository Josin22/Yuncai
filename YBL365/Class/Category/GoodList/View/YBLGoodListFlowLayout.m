//
//  YBLGoodListFlowLayout.m
//  YC168
//
//  Created by 乔同新 on 2017/6/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodListFlowLayout.h"

@implementation YBLGoodListFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat width = YBLWindowWidth;
        CGFloat hi = 130;
        self.itemSize = CGSizeMake(width, hi);
    }
    return self;
}


@end

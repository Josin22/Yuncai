//
//  YBLHotCollectionView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HotCollectionDidSelectBlock)(void);

@interface YBLHotCollectionView : UICollectionView

@property (nonatomic, copy) HotCollectionDidSelectBlock hotCollectionDidSelectBlock;

@end

//
//  YBLStoreGoodsUIService.h
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^scrollYBlock)(CGFloat alpha,UIScrollView * scrollView);


@interface YBLStoreGoodsUIService : NSObject<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, copy) scrollYBlock scrollYBlock;


@property (nonatomic ,assign) BOOL isChangeList;

@property (nonatomic ,assign) BOOL isShop;

@end

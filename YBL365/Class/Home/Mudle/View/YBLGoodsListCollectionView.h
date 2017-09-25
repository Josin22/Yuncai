//
//  YBLGoodsListCollectionView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLGoodGridFlowLayout.h"

typedef NS_ENUM(NSInteger,CollectionType) {
    /**
     *  普通商品
     */
    CollectionTypeNormalGood = 0,
    CollectionTypeStoreGood
};

@class YBLTwotageMuduleViewController;

typedef void(^GoodsListCollectionViewScrollBlock)(UIScrollView *scrollView);

typedef void(^GoodsListCollectionViewScrollDidEndBlock)(UIScrollView *scrollView);

typedef void(^GoodsListCollectionViewScrollWillBegainDrageBlock)(UIScrollView *scrollView);

typedef void(^GoodsListCollectionViewCellDidSelectBlock)(NSIndexPath *selectIndexPath,id model);

@interface YBLGoodsListCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray                            *dataArray;

@property (nonatomic, assign) BOOL                                       isListType;

@property (nonatomic, copy  ) GoodsListCollectionViewCellDidSelectBlock goodsListCollectionViewCellDidSelectBlock;

@property (nonatomic, copy  ) GoodsListCollectionViewScrollBlock        goodsListCollectionViewScrollBlock;

@property (nonatomic, copy  ) GoodsListCollectionViewScrollWillBegainDrageBlock goodsListCollectionViewScrollWillBegainDrageBlock;

@property (nonatomic, copy  ) GoodsListCollectionViewScrollDidEndBlock  goodsListCollectionViewScrollDidEndBlock;

@property (nonatomic, copy  ) ViewPrestrainBlock                        viewPrestrainBlock;

- (instancetype)initWithFrame:(CGRect)frame
               collectionType:(CollectionType)type;

@end

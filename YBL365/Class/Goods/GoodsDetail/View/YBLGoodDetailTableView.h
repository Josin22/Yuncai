//
//  YBLGoodDetailTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YBLGoodShippingPriceModel.h"

typedef NS_ENUM(NSInteger,GoodDetailShowType) {
    /**
     *  正常商品展示
     */
    GoodDetailShowTypeNormalShow = 0,
    /**
     *  商品编辑展示
     */
    GoodDetailShowTypeEditShow
};

typedef void(^GoodDetailTableViewDidSelectBlock)(NSIndexPath *indexPath,NSString *selectCellName);

typedef void(^GoodDetailTableViewBannerScrollToLastItemBlock)(void);

typedef void(^GoodDetailTableViewScrollToImageTextBlock)(void);

typedef void(^GoodDetailTableViewScrollToCommentsBlock)(void);

typedef void(^GoodDetailTableViewScrollToFooterPrintsBlock)(void);

@class YBLGoodModel,YBLGoodsDetailViewController;

@interface YBLGoodDetailTableView : UITableView

@property (nonatomic, weak  ) YBLGoodsDetailViewController      *goodsDetailVC;

@property (nonatomic, copy  ) GoodDetailTableViewDidSelectBlock goodDetailTableViewDidSelectBlock;

@property (nonatomic, copy  ) GoodDetailTableViewScrollToFooterPrintsBlock footerPrintsBlock;

@property (nonatomic, copy  ) GoodDetailTableViewScrollToImageTextBlock goodDetailTableViewScrollToImageTextBlock;

@property (nonatomic, copy  ) GoodDetailTableViewBannerScrollToLastItemBlock goodDetailTableViewBannerScrollToLastItemBlock;

@property (nonatomic, copy  ) GoodDetailTableViewScrollToCommentsBlock goodDetailTableViewScrollToCommentsBlock;

@property (nonatomic, weak  ) NSMutableArray                    *cellIDArray;

@property (nonatomic, weak  ) YBLGoodModel                      *goodDetailModel;

- (void)updateCellIDArray:(NSMutableArray *)cellArray goodDetailModel:(YBLGoodModel *)goodDetailModel;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
           goodDetailShowType:(GoodDetailShowType)goodDetailShowType;

@end

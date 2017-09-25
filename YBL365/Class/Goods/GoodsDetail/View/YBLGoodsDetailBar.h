//
//  YBLGoodsDetailBar.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLBadgeLabel.h"

typedef NS_ENUM(NSInteger , BarItemType) {
    BarItemTypeStore = 0,
    BarItemTypeFoucs,
    BarItemTypeCart,
    BarItemTypeAddToCart,
    BarItemTypeDaoHuoNotification
};

typedef void(^YBLGoodsDetailBarItemClickBlock)(BarItemType type,YBLButton *clickBtn);

@interface YBLGoodsDetailBar : UIView

@property (nonatomic, strong) YBLButton *storeButton;

@property (nonatomic, strong) YBLButton *foucsButton;

@property (nonatomic, strong) YBLButton *carButton;

@property (nonatomic, retain) UILabel *foucLabel;

@property (nonatomic, retain) YBLBadgeLabel *bageLabel;

@property (nonatomic, strong) YBLButton *addToCartButton;

@property (nonatomic, assign) BOOL isBarEnable;

@property (nonatomic, copy) YBLGoodsDetailBarItemClickBlock goodsDetailBarItemClickBlock;

@end

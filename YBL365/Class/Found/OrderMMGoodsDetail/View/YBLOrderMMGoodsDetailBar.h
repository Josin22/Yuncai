//
//  YBLOrderMMGoodsDetailBar.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLTimeDown.h"
#import "YBLPurchaseOrderModel.h"

typedef NS_ENUM(NSInteger,PurchaseGoddDetailBarType) {
    PurchaseGoddDetailBarTypeNormal = 0,
    PurchaseGoddDetailBarTypeEdit
};

@interface YBLOrderMMGoodsDetailBar : UIView

-(void)updatePurchaseDetailModel:(YBLPurchaseOrderModel *)purchaseDetailModel;

- (instancetype)initWithFrame:(CGRect)frame purchaseGoddDetailBarType:(PurchaseGoddDetailBarType)purchaseGoddDetailBarType;

@property (nonatomic, strong) YBLTimeDown *timeDown;

@property (nonatomic, strong) UIButton *qiangButton;

@property (nonatomic, assign) float priceValue;

@end

//
//  YBLOutPriceBar.h
//  YC168
//
//  Created by 乔同新 on 2017/4/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CurrentButtonType) {
    /**
     *  取消订单
     */
    CurrentButtonTypeCancle = 0,
    /**
     *  确认采购
     */
    CurrentButtonTypeSurePurchase,
    /**
     *  查看订单
     */
    CurrentButtonTypeLookOrder,
    /**
     *  再次发布
     */
    CurrentButtonTypeReleaseAgain,
    /**
     *  我也报价
     */
    CurrentButtonTypeIwantOutPrice
};

typedef void(^OutPriceBarButtonClickBlock)(CurrentButtonType currentButtonType);

@class YBLPurchaseOrderModel;

@interface YBLOutPriceBar : UIView

@property (nonatomic, copy) OutPriceBarButtonClickBlock outPriceBarButtonClickBlock;

- (void)updateDataModel:(YBLPurchaseOrderModel *)dataModel;

@end

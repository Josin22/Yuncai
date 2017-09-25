//
//  YBLOutPriceRecordsCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MyPurchaseStatue) {
    MyPurchaseStatueDoingNotNotPay= 0,   //进行中未支付
    MyPurchaseStatueEndNotPay,       //采购结束未支付
    MyPurchaseStatueEndPurchaseOutPriceAgain,//采购结束再次报价
};

@class YBLPurchaseOrderModel;

@interface YBLOutPriceRecordsCell : UITableViewCell

@property (nonatomic, strong) UIButton *cancleButton;

@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) UIButton *againPublishButton;

@property (nonatomic, assign) MyPurchaseStatue statue;;

- (void)updateModel:(YBLPurchaseOrderModel *)model;

+ (CGFloat)getMyPurchaseCellHeight;

@end

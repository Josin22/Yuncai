//
//  YBLOrderMMOutPriceRecordsCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLSignLabel.h"

@class YBLPurchaseOrderModel;

@interface YBLOrderMMOutPriceRecordsCell : UITableViewCell

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, retain) YBLSignLabel *signLabel;

- (void)updateBiddingModel:(YBLPurchaseOrderModel *)bidModel purchaseGoodModel:(YBLPurchaseOrderModel *)purchaseGoodModel;

@end

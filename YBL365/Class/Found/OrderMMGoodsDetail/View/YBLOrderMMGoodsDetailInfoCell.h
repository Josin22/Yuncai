//
//  YBLOrderMMGoodsDetailInfoCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLPurchaseOrderModel;

@interface YBLOrderMMGoodsDetailInfoCell : UITableViewCell

@property (nonatomic, strong) UIButton *askButton;

- (void)updateModel:(YBLPurchaseOrderModel *)model;

+ (CGFloat)getGoodsDetailInfoCellHeight;

@end

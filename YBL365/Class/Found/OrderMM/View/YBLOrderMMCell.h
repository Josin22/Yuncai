//
//  YBLOrderMMCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLPurchaseOrderModel.h"

@interface YBLOrderMMCell : UICollectionViewCell

- (void)updateModel:(YBLPurchaseOrderModel *)model;

+ (CGFloat)getOrderMMCellGoodHeight;

@end

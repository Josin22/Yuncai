//
//  YBLOutPriceHeaderView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextImageButton.h"

@class YBLPurchaseOrderModel;

@interface YBLOutPriceHeaderView : UIView

- (void)updateModel:(YBLPurchaseOrderModel *)model;

@end

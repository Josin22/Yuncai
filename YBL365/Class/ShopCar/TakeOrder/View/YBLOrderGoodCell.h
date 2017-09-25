//
//  YBLOrderGoodCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class lineitems,YBLTakeOrderParaLineItemsModel;

@interface YBLOrderGoodCell : UITableViewCell

- (void)updateItemsModel:(id)model;

- (void)updateExpressCompanyPriceModel:(YBLTakeOrderParaLineItemsModel *)itemMode;

+ (CGFloat)getOrderGoodCellHi;

@end

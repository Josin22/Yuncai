//
//  YBLGoodShippingPrice.h
//  YC168
//
//  Created by 乔同新 on 2017/4/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLNoPermitCheckResultModel.h"

@interface YBLShippingPriceItemModel : NSObject

@property (nonatomic, strong) NSString *product_shipping_price_id;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSNumber *same_city;

@property (nonatomic, strong) NSString *express_company;
/**
 *  是否选中物流价格
 */
@property (nonatomic, strong) NSNumber *is_select;

@property (nonatomic, strong) YBLNoPermitCheckResultModel *no_permit_check_result;

@end


@interface YBLGoodShippingPriceModel : NSObject

@property (nonatomic, strong) NSString *line_item_id;

@property (nonatomic, strong) NSMutableArray *shipping_prices;

@end

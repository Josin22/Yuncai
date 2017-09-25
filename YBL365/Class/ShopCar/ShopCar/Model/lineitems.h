//
//  lineitems.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"

@interface product_shipping_method : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *shipping_method_id;
@property (nonatomic, strong) NSArray  *area;
@property (nonatomic, strong) NSArray  *address_ids;
@property (nonatomic, strong) NSNumber *down_payment_percent;

@end


@interface shipment : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *shipped_at;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSNumber *adjustment_total;
@property (nonatomic, strong) NSNumber *promo_total;
@property (nonatomic, strong) NSString *address_id;

@end

@interface lineitems : NSObject

@property (nonatomic , strong) YBLGoodModel                 *product;
@property (nonatomic , strong) NSNumber                     *quantity;
@property (nonatomic , copy  ) NSString                     *shop_id;
@property (nonatomic , strong) NSNumber                     *state;
@property (nonatomic , copy  ) NSString                     *itemid;
@property (nonatomic , strong) NSString                     *line_item_id;
@property (nonatomic , strong) NSNumber                     *price;
/**
 *  单个商品物流价格
 */
@property (nonatomic , strong) NSNumber                     *shipping_price;
/**
 *  单个商品物流公司 (mine:商家自配)
 */
@property (nonatomic , strong) NSString                     *express_company;
/**
 *  选中物流价格model
 */
@property (nonatomic , strong) YBLShippingPriceItemModel    *select_shipping_price_item_model;
/**
 *  选中自提地址
 */
@property (nonatomic , strong) YBLAddressModel              *select_pickup_address_model;
/**
 *  单个商品选择支付方式
 */
@property (nonatomic , strong) YBLShowPayShippingsmentModel *select_product_payment_methods;
/**
 *  单个商品选择配送方式
 */
@property (nonatomic , strong) YBLShowPayShippingsmentModel *select_product_shipping_methods;
/**
 *  判断商品
 */
@property (nonatomic , strong) YBLNoPermitCheckResultModel  *no_permit_check_result;
///单品选中状态
@property (nonatomic, assign ) BOOL                         lineitems_select;
///单品价格
@property (nonatomic, strong ) NSNumber                     *lineitems_price;
///商品支付方式
@property (nonatomic, strong ) NSString                     *lineitems_pay_type;

@end

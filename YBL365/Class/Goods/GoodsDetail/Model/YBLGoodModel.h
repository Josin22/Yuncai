//
//  YBLGoodModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shop.h"
#import "YBLAddressAreaModel.h"
#import "YBLCompanyTypePricesParaModel.h"
#import "YBLGoodShippingPriceModel.h"
#import "YBLShowPayShippingsmentModel.h"
#import "YBLGoodShippingPriceModel.h"
#import "YBLNoPermitCheckResultModel.h"
#import "YBLAddressModel.h"

@interface state : NSObject

@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * value;

@end

@interface YBLGoodModel : NSObject

CoreArchiver_MODEL_H

@property (nonatomic , copy  ) NSString       * _id;
@property (nonatomic , copy  ) NSString       * small_marketing_id;
@property (nonatomic , copy  ) NSString       * id;
@property (nonatomic , copy  ) NSString       * avatar;
@property (nonatomic , copy  ) NSString       * thumb;
@property (nonatomic , copy  ) NSString       * specification;
@property (nonatomic , copy  ) NSString       * unit;
@property (nonatomic , copy  ) NSString       * warehouse_id;
@property (nonatomic , copy  ) NSString       * category_id;
@property (nonatomic , copy  ) NSString       * brand;
@property (nonatomic , copy  ) NSString       * avatar_url;
@property (nonatomic , copy  ) NSString       * tags;
@property (nonatomic , strong) NSNumber       * stock;
@property (nonatomic , copy  ) NSString       * title;
@property (nonatomic , strong) NSNumber       * price;
@property (nonatomic , strong) NSNumber       * sale_count;
@property (nonatomic , strong) NSNumber       * paytypeout;
@property (nonatomic , strong) NSNumber       * qrcode;
@property (nonatomic , copy  ) NSString       * shop_id;
@property (nonatomic , copy  ) NSString       * origin;
@property (nonatomic , strong) NSString       * created_at;
@property (nonatomic , strong) NSString       * self_description;
@property (nonatomic , strong) NSNumber       * sale_order_count;
//new1
@property (nonatomic , strong) NSArray        * mains;
@property (nonatomic , strong) NSArray        * descs;
@property (nonatomic , strong) NSString       * mobile_category_name;
@property (nonatomic , strong) NSString       * manufacturer;
@property (nonatomic , strong) NSString       * scent;

@property (nonatomic , strong) state          * state;
//new2
@property (nonatomic , strong) NSString       * category_title;
@property (nonatomic , strong) NSString       * warehouse_product_id;
@property (nonatomic , strong) NSNumber       * cost_price;
@property (nonatomic , strong) NSNumber       * guest_price;
@property (nonatomic , strong) NSNumber       * weight;
@property (nonatomic , strong) NSNumber       * market_guide_price;
@property (nonatomic , strong) NSNumber       * market_retail_price;
@property (nonatomic , strong) NSDictionary   * properties;
@property (nonatomic , strong) NSDictionary   * properties_with_name;
@property (nonatomic , copy  ) NSString       * fullReduction;
@property (nonatomic , copy  ) NSString       * share_url;
@property (nonatomic , strong) NSNumber       * comment_rate;
@property (nonatomic , strong) shop           * shop;
@property (nonatomic , strong) NSNumber       * comment_count;
@property (nonatomic , strong) NSNumber       * integral;

//过滤的支付方式
@property (nonatomic , strong) NSMutableArray * filter_product_payment_methods;
//过滤的配送方式
@property (nonatomic , strong) NSMutableArray * filter_product_shiping_methods;
@property (nonatomic , strong) NSMutableArray * product_payment_methods;
@property (nonatomic , strong) NSMutableArray * product_shipping_methods;

/**
 *  物流价格
 */
@property (nonatomic , strong) YBLCompanyTypePricesParaModel * prices;
@property (nonatomic , strong) NSMutableArray                * shipping_prices;
@property (nonatomic , strong) NSMutableArray                * company_type_prices;
@property (nonatomic , strong) NSNumber                      * minCount;
@property (nonatomic , strong) NSNumber                      * quantity;
@property (nonatomic , strong) NSNumber                      * currentPrice;
@property (nonatomic , assign) BOOL                          is_select;
/**
 *  no_permit_check_result
 */
@property (nonatomic , strong) YBLNoPermitCheckResultModel  *no_permit_check_result;

@property (nonatomic, strong) YBLAddressModel               *selectAddressModel;

@property (nonatomic, strong) YBLShippingPriceItemModel     *expressCompanyItemModel;
/**
 *  评论
 */
@property (nonatomic, strong) NSMutableArray                *comments;
@property (nonatomic, strong) NSNumber                      *good_comments_rate;
@property (nonatomic, strong) NSNumber                      *comments_total;

@property (nonatomic, copy  ) NSString                      *state_value;

//coupons
@property (nonatomic, strong) NSMutableArray                *coupons;
- (void)handleAttPrice;

///**
// *  db
// */
//WCDB_PROPERTY(id)
//WCDB_PROPERTY(avatar)
//WCDB_PROPERTY(title)
//WCDB_PROPERTY(price)

@end

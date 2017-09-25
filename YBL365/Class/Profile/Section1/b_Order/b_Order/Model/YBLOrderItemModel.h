//
//  YBLOrderItemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lineitems.h"
#import "YBLAddressModel.h"
#import "payshippingment_model.h"
#import "YBLInvoiceModel.h"
#import "YBLPurchaseOrderModel.h"

@interface YBLOrderItemModel : NSObject
/**
 *  提货码
 */
@property (nonatomic , copy) NSString              * confirm_code;
///服务器当前时间
@property (nonatomic , copy  ) NSString              * current_time;
///过期时间
@property (nonatomic , copy  ) NSString              * current_state_expire_at;
@property (nonatomic , copy  ) NSString              * completed_at;
@property (nonatomic , copy  ) NSString              * canceled_at;
@property (nonatomic , strong) NSArray               * line_items;
/**
 *  已支付
 */
@property (nonatomic , copy  ) NSString              * payment_total;
/**
 *  总额==商品总额+运费-(ajustment_total)
 */
@property (nonatomic , copy  ) NSString              * total;
@property (nonatomic , copy  ) NSString              * canceler_user;
@property (nonatomic , copy  ) NSString              * customer_id;
@property (nonatomic , copy  ) NSString              * order_id;
@property (nonatomic , copy  ) NSString              * number;
@property (nonatomic , copy  ) NSString              * state;
@property (nonatomic , copy  ) NSString              * id;
@property (nonatomic , copy  ) NSString              * seller_mobile;
@property (nonatomic , copy  ) NSString              * customer_mobile;
@property (nonatomic , copy  ) NSString              * considered_risky;
@property (nonatomic , copy  ) NSString              * adjustment_total;
@property (nonatomic , strong) YBLAddressModel       * ship_address;
@property (nonatomic , strong) YBLAddressModel       * pick_up_address;
@property (nonatomic , strong) YBLAddressModel       * auto_address;
@property (nonatomic , strong) NSNumber              * item_total;
@property (nonatomic , strong) NSNumber              * item_count;
@property (nonatomic , copy  ) NSString              * confirmation_delivered;
@property (nonatomic , copy  ) NSString              * shipment_state;
@property (nonatomic , copy  ) NSString              * payment_state;
@property (nonatomic , copy  ) NSString              * shipment_total;
@property (nonatomic , copy  ) NSString              * promo_total;
@property (nonatomic , copy  ) NSString              * seller_id;
@property (nonatomic , copy  ) NSString              * seller_shopname;
@property (nonatomic , copy  ) NSString              * creator_user;
@property (nonatomic , copy  ) NSString              * created_at;
@property (nonatomic , copy  ) NSString              * state_cn;
@property (nonatomic , copy  ) NSString              * state_en;
@property (nonatomic , strong) payshippingment_model * payment_method;
@property (nonatomic , strong) payshippingment_model * shipping_method;
@property (nonatomic , strong) YBLInvoiceModel       * invoice;
@property (nonatomic , copy  ) NSString              * purchase_order_id;
@property (nonatomic , strong) YBLPurchaseOrderModel * purchase_order;
@property (nonatomic , strong) NSNumber              * delay_pick_up_count;
@property (nonatomic , strong) NSNumber              * delay_receive_ship_count;
@property (nonatomic , strong) NSNumber              * delay_shipping_count;

@property (nonatomic , strong) NSString              * message;
//
@property (nonatomic , strong) NSString              * button_title;
@property (nonatomic , strong) NSString              * button_action;

//new
@property (nonatomic , strong) YBLOrderPropertyModel *property_order;
@property (nonatomic , strong) NSString              * full_completed_at;

@end

//
//  YBLBigBOrderItemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "payshippingment_model.h"
#import "spree_order_state.h"
#import "YBLInvoiceModel.h"

@interface purchase_order :NSObject

@property (nonatomic , copy  ) NSString          * _id;
@property (nonatomic , copy  ) NSString          * specification;
@property (nonatomic , strong) NSArray           * paytype;
@property (nonatomic , copy  ) NSString          * aasm_state;
@property (nonatomic , strong) NSNumber          * sellshelflifes;
@property (nonatomic , strong) NSArray           * distributionparenttitle;
@property (nonatomic , copy  ) NSString          * created_at;
@property (nonatomic , copy  ) NSString          * warehouse_product_id;
@property (nonatomic , strong) NSArray           * mains;
@property (nonatomic , copy  ) NSString          * address;
@property (nonatomic , copy  ) NSString          * purchasetime;
@property (nonatomic , copy  ) NSString          * thumb;
@property (nonatomic , copy  ) NSString          * spree_order_id;
@property (nonatomic , copy  ) NSString          * system_time;
@property (nonatomic , strong) NSArray           * distributiontitle;
@property (nonatomic , strong) NSNumber          * visit_times;
@property (nonatomic , copy  ) NSString          * district;
@property (nonatomic , copy  ) NSString          * qrcode;
@property (nonatomic , strong) NSArray           * paytypetitle;
@property (nonatomic , copy  ) NSString          * brand;
@property (nonatomic , copy  ) NSString          * category_name;
@property (nonatomic , copy  ) NSString          * enddated_at;
@property (nonatomic , strong) NSNumber          * shelflifes;
@property (nonatomic , copy  ) NSString          * origin;
@property (nonatomic , strong) NSNumber          * quantity;
@property (nonatomic , copy  ) NSString          * avatar;
@property (nonatomic , strong) NSNumber          * price;
@property (nonatomic , strong) NSArray           * descs;
@property (nonatomic , copy  ) NSString          * rule;
@property (nonatomic , copy  ) NSString          * city;
@property (nonatomic , copy  ) NSString          * province;
@property (nonatomic , strong) spree_order_state * spree_order_state;
@property (nonatomic , copy  ) NSString          * addressinfo;
@property (nonatomic , strong) NSArray           * distributiondesc;
@property (nonatomic , copy  ) NSString          * userinfo_id;
@property (nonatomic , copy  ) NSString          * share_url;
@property (nonatomic , copy  ) NSString          * title;
@property (nonatomic , copy  ) NSString          * category_id;
@property (nonatomic , strong) NSArray           * distributiontime;
@property (nonatomic , strong) NSNumber          * bidding_count;
@property (nonatomic , copy  ) NSString          * county;

@end


@interface YBLBigBOrderItemModel :NSObject

@property (nonatomic , copy  ) NSString              * payment_method_id;
@property (nonatomic , copy  ) NSString              * created_at;
@property (nonatomic , copy  ) NSString              * id;
@property (nonatomic , strong) NSNumber              * adjustment_total;
@property (nonatomic , strong) NSNumber              * item_total;
@property (nonatomic , strong) NSNumber              * item_count;
@property (nonatomic , copy  ) NSString              * state;
@property (nonatomic , copy  ) NSString              * shipment_state;
@property (nonatomic , copy  ) NSString              * shipping_method;
@property (nonatomic , strong) NSNumber              * shipment_total;
@property (nonatomic , copy  ) NSString              * ship_address;
@property (nonatomic , copy  ) NSString              * customer_id;
@property (nonatomic , copy  ) NSString              * payment_state_cn;
@property (nonatomic , copy  ) NSString              * number;
@property (nonatomic , copy  ) NSString              * completed_at;
@property (nonatomic , copy  ) NSString              * payment_id;
@property (nonatomic , copy  ) NSString              * state_en;
@property (nonatomic , copy  ) NSString              * payment_state;
@property (nonatomic , strong) purchase_order        * purchase_order;
@property (nonatomic , copy  ) NSString              * canceled_at;
@property (nonatomic , copy  ) NSString              * order_id;
@property (nonatomic , strong) payshippingment_model * payment_method;
@property (nonatomic , strong) NSNumber              * total;
@property (nonatomic , strong) NSArray               * line_items;
@property (nonatomic , copy  ) NSString              * customer_shopname;
@property (nonatomic , copy  ) NSString              * purchase_order_id;
@property (nonatomic , copy  ) NSString              * order_state_cn;
@property (nonatomic , copy  ) NSString              * current_time;
@property (nonatomic , copy  ) NSString              * shipping_method_id;
@property (nonatomic , copy  ) NSString              * shipment_state_cn;
@property (nonatomic , strong) NSNumber              * promo_total;
@property (nonatomic , strong) NSNumber              * payment_total;
@property (nonatomic , copy  ) YBLInvoiceModel       * invoice;
@property (nonatomic , copy  ) NSString              * shipment_id;
@property (nonatomic , copy  ) NSString              * state_cn;
@property (nonatomic , copy  ) NSString              * seller_id;
@property (nonatomic , copy  ) NSString              * message;

@end

//
//  YBLPurchaseOrderModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "payshippingment_model.h"
#import "spree_order_state.h"
#import "YBLAddressModel.h"
#import "YBLpurchaseInfosModel.h"

@interface purchase_state_for_purchaser_or_bidder_model : NSObject

@property (nonatomic, copy  ) NSString       *mypurchase_head;
@property (nonatomic, copy  ) NSString       *histroy;
/**
 *  true==>>可点 false==>>不可点
 */
@property (nonatomic, strong) NSNumber       *disabled;
@property (nonatomic, strong) NSMutableArray *mypurchase_button;

@end

@interface singleOutPriceRecords : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *name;

@end

@interface spree_order :NSObject

@property (nonatomic , copy  ) NSString              * spree_order_number;
@property (nonatomic , copy  ) NSString              * spree_order_created_at;
@property (nonatomic , copy  ) NSString              * spree_order_id;

@end

@interface YBLPurchaseOrderModel : NSObject

@property (nonatomic , copy  ) NSString              * title;
@property (nonatomic , copy  ) NSString              * mobile_category_name;
@property (nonatomic , copy  ) NSString              * brand;
@property (nonatomic , copy  ) NSString              * _id;
@property (nonatomic , copy  ) NSString              * unit;
@property (nonatomic , copy  ) NSString              * qrcode;
@property (nonatomic , strong) NSString              * shelflifes;
@property (nonatomic , strong) NSString              * shelflifes_title;
@property (nonatomic , copy  ) NSString              * origin;
@property (nonatomic , copy  ) NSString              * aasm_state;
@property (nonatomic , copy  ) NSString              * state;
@property (nonatomic , copy  ) NSString              * aasm_title;
@property (nonatomic , copy  ) NSString              * warehouse_product_id;
@property (nonatomic , copy  ) NSString              * userinfo_id;
@property (nonatomic , copy  ) NSString              * manufacturer;
@property (nonatomic , strong) NSArray               * distributiontitle;
@property (nonatomic , strong) NSNumber              * quantity;
@property (nonatomic , copy  ) NSString              * specification;
@property (nonatomic , copy  ) NSString              * avatar;
@property (nonatomic , copy  ) NSString              * thumb;
@property (nonatomic , strong) NSArray               * descs;
@property (nonatomic , strong) NSString              * sellshelflifes;
@property (nonatomic , strong) NSString              * sellshelflifes_title;
@property (nonatomic , strong) NSNumber              * lowest_price;
@property (nonatomic , copy  ) NSString              * purchasetime;
@property (nonatomic , copy  ) NSString              * purchasetime_title;
@property (nonatomic , strong) YBLAddressModel       * address_info;
@property (nonatomic , strong) NSNumber              * price;
@property (nonatomic , strong) NSNumber              * bidder_price;
@property (nonatomic , strong) NSArray               * mains;
@property (nonatomic , copy  ) NSString              * category_id;
@property (nonatomic , copy  ) NSString              * category_name;
@property (nonatomic , copy  ) NSString              * created_at;
@property (nonatomic , copy  ) NSString              * updated_at;
@property (nonatomic , copy  ) NSString              * enddated_at;
@property (nonatomic , copy  ) NSString              * system_time;
@property (nonatomic , copy  ) NSString              * visit_times;
@property (nonatomic , copy  ) NSString              * bidding_count;
@property (nonatomic , copy  ) NSString              * spree_order_id;
@property (nonatomic , copy  ) NSString              * spree_order_number;
@property (nonatomic , copy  ) NSString              * spree_order_created_at;
@property (nonatomic , strong) spree_order_state     * spree_order_state;
@property (nonatomic , strong) spree_order           * spree_order;
@property (nonatomic , copy  ) NSString              * share_url;
@property (nonatomic , copy  ) NSString              * bidstate;
@property (nonatomic , copy  ) NSString              * userinfoname;
///
@property (nonatomic , strong) NSMutableArray        * purchase_pay_types;
@property (nonatomic , strong) NSMutableArray        * purchase_distributions;
/**
 *  caobi
 */
@property (nonatomic , strong) YBLPurchaseInfosModel * pay_type;
@property (nonatomic , strong) YBLPurchaseInfosModel * distributions;

@property (nonatomic , strong) singleOutPriceRecords * custom_records;
///中标方式（sys 系统选择 self自选）
@property (nonatomic , copy  ) NSString              * rule;
@property (nonatomic , copy  ) NSString              * rule_id;
@property (nonatomic , copy  ) NSString              * rule_title;
///是否自己的订单
@property (nonatomic , assign) BOOL                  isMyselfPurchaseOrder;
@property (nonatomic , assign) BOOL                  isSelect;
@property (nonatomic , strong) NSMutableArray        * all_pay_ship_ment_titles;
@property (nonatomic , strong) NSNumber              * distance;
@property (nonatomic , strong) NSNumber              * same_city;
/**
 *   @{dict_data_identity_key:depth1.title,
 *   dict_data_identity_value:depth22Array};
 */
@property (nonatomic , strong) NSDictionary          * same_city_data_dict;

@property (nonatomic , assign) MyPurchaseType        myPurchaseType;

@property (nonatomic , strong) purchase_state_for_purchaser_or_bidder_model  * purchase_state_for_bidder;
@property (nonatomic , strong) purchase_state_for_purchaser_or_bidder_model  * purchase_state_for_purchaser;


- (void)handleAttText;

- (void)handleAttPrice;

@end

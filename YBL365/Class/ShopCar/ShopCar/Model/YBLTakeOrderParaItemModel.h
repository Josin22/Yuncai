//
//  YBLTakeOrderParaItemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLInvoiceModel.h"
#import "YBLAddressModel.h"

@interface YBLTakeOrderParaShippingPriceModel : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy  ) NSString *express_company;

@end

@interface YBLTakeOrderParaLineItemsModel : NSObject

@property (nonatomic, copy  ) NSString                           *line_item_id;

@property (nonatomic, strong) NSNumber                           *quantity;

@property (nonatomic, copy  ) NSString                           *product_payment_method_id;
@property (nonatomic, copy  ) NSString                           *select_product_payment_method_name;

@property (nonatomic, copy  ) NSString                           *product_shipping_method_id;
@property (nonatomic, copy  ) NSString                           *select_product_shipping_method_name;

@property (nonatomic, copy  ) NSString                           *pick_up_address_id;
@property (nonatomic, strong) YBLAddressModel                    *select_pick_up_address_model;

@property (nonatomic, strong) YBLTakeOrderParaShippingPriceModel *shipping_price;


@end

@interface YBLTakeOrderParaItemModel : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, copy  ) NSString        *shop_id;
@property (nonatomic, copy  ) NSString        *ship_address_id;
@property (nonatomic, copy  ) NSString        *message;
@property (nonatomic, strong) YBLInvoiceModel *invoice;
@property (nonatomic, strong) NSMutableArray  *line_items;

@end

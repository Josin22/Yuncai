//
//  YBLShowPayShippingsmentModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "payshippingment_model.h"
#import "YBLAreaRadiusItemModel.h"

@interface YBLShowPayShippingsmentModel : NSObject
/* orgin */
//
@property (nonatomic, strong) NSString              *id;

@property (nonatomic, strong) NSString              *product_payment_method_id;

@property (nonatomic, strong) NSString              *payment_method_id;

@property (nonatomic, strong) payshippingment_model *shipping_method;
//
@property (nonatomic, strong) payshippingment_model *payment_method;

@property (nonatomic, strong) NSString              *shipping_method_id;

@property (nonatomic, strong) NSString              *product_shipping_method_id;

@property (nonatomic, strong) NSNumber              *is_default;

@property (nonatomic, strong) NSMutableArray        *address_ids;
//是否选中
@property (nonatomic, assign) BOOL                  is_select;
///选中值
@property (nonatomic, assign) NSInteger             is_select_value;
//物流代收比例
@property (nonatomic, assign) float                 down_payment_percent;
//选中的自提地址
@property (nonatomic, strong) NSMutableArray        *addresses;
//选中的配送地址库
@property (nonatomic, strong) NSMutableArray        *area_text;
///区域半径
@property (nonatomic, strong) NSMutableArray        *radius_prices;
//源数据
@property (nonatomic, strong) NSMutableDictionary   *orgin_select_shipping_address_dict;

//@property (nonatomic, strong) NSMutableArray        *area;

@end

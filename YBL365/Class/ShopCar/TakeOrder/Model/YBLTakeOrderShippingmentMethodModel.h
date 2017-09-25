//
//  YBLTakeOrderShippingmentMethodModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "payshippingment_model.h"

@interface YBLTakeOrderShippingmentMethodModel : NSObject

@property (nonatomic, strong) payshippingment_model *shipping_method;

@property (nonatomic, strong) NSNumber *is_default;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSString *product_shipping_method_id;

@property (nonatomic, strong) NSString *shipping_method_id;

@property (nonatomic, assign) BOOL isSelect;

@end

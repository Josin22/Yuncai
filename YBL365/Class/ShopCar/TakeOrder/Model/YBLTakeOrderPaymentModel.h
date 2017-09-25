//
//  YBLTakeOrderPaymentModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLTakeOrderPaymentMethodModel.h"
#import "payshippingment_model.h"

@interface YBLTakeOrderPaymentModel : NSObject

@property (nonatomic, strong) NSNumber *amount;

@property (nonatomic, strong) NSString *id;

@property (nonatomic, strong) NSArray *line_items_ids;

@property (nonatomic, strong) NSArray *orders_ids;

@property (nonatomic, strong) payshippingment_model *payment_method;

@property (nonatomic, strong) NSString *state;

@end

//
//  YBLTakeOrderModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTakeOrderModel.h"

@implementation YBLTakeOrderModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"orders":[YBLOrderItemModel class],
             @"payments":[YBLTakeOrderPaymentModel class]};
    
}

@end

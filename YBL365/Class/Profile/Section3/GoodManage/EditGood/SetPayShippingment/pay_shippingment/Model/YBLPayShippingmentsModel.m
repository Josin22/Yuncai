//
//  YBLPayShippingmentsModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayShippingmentsModel.h"

@implementation YBLPayShippingmentsModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"payments":[payshippingment_model class],
             @"shippings":[payshippingment_model class]};
    
}

@end

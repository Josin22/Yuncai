//
//  YBLSalesDisplayPriceModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSalesDisplayPriceModel.h"

@implementation YBLSalesDisplayPriceModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"sales_area":[YBLAddressAreaModel class],
             @"display_price_area":[YBLAddressAreaModel class]};
    
}

@end

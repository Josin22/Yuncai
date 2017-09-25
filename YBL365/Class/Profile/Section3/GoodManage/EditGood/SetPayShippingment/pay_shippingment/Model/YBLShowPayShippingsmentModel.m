//
//  YBLShowPayShippingsmentModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShowPayShippingsmentModel.h"
#import "YBLAddressModel.h"
#import "YBLAddressAreaModel.h"

@implementation YBLShowPayShippingsmentModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"area_text":[YBLAddressAreaModel class],
             @"addresses":[YBLAddressModel class],
             @"radius_prices":[YBLAreaRadiusItemModel class]};
    
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"down_payment_percent" : @"down_payment_percent",
//             @"addresses":@"addresses",
//             @"area_text":@"areas"};
//}

@end

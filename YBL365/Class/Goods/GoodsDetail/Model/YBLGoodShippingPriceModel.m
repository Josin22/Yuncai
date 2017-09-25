
//
//  YBLGoodShippingPrice.m
//  YC168
//
//  Created by 乔同新 on 2017/4/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodShippingPriceModel.h"

@implementation YBLShippingPriceItemModel


@end

@implementation YBLGoodShippingPriceModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"shipping_prices":[YBLShippingPriceItemModel class]};
    
}

@end

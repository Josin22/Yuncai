//
//  YBLSuperGoodModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSuperGoodModel.h"

@implementation YBLSuperGoodModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"comments":[YBLOrderCommentsModel class],
             @"shipping_prices":[YBLShippingPriceItemModel class],
             };
    
}
@end

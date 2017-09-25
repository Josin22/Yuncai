//
//  shop.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "shop.h"
#import "YBLGoodModel.h"

@implementation shop

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"shop_products":[YBLGoodModel class]};
    
}

@end

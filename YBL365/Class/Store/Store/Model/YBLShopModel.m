//
//  YBLShopModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopModel.h"

@implementation YBLShopModel

+ (NSDictionary *)modelContainerPropertyGenericClass{

    return @{@"products":[YBLGoodModel class],};

}

@end

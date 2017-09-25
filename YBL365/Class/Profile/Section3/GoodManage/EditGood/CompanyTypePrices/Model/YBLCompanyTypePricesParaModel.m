//
//  YBLCompanyTypePricesParaModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCompanyTypePricesParaModel.h"

@implementation YBLCompanyTypePricesParaModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"prices":[PricesItemModel class]};
}

//+ (NSArray *)modelPropertyBlacklist{
//    return @[@""];
//}
//+ (NSArray *)modelPropertyWhitelist{
//    return @[@""];
//}

@end


@implementation PricesItemModel

@end

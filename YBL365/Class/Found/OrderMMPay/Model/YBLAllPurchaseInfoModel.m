//
//  YBLAllPurchaseInfoModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAllPurchaseInfoModel.h"

@implementation YBLAllPurchaseInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"paytypes":[YBLPurchaseInfosModel class],
             @"distributions":[YBLPurchaseInfosModel class]};
    
}

@end

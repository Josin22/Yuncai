//
//  YBLOrderConfirmModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderConfirmModel.h"

@implementation YBLOrderConfirmModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"shop_line_items":[YBLCartModel class]};
    
}

@end

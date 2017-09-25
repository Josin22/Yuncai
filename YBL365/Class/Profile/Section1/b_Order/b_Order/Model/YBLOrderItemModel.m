//
//  YBLOrderItemModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderItemModel.h"

@implementation YBLOrderItemModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"line_items":[lineitems class]};
    
}

@end

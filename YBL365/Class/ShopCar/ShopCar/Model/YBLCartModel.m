//
//  YBLCartModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCartModel.h"

@implementation YBLCartModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"line_items":[lineitems class]};
    
}

@end


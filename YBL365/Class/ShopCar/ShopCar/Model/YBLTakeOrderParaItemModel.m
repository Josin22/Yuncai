//
//  YBLTakeOrderParaItemModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTakeOrderParaItemModel.h"

@implementation YBLTakeOrderParaShippingPriceModel

@end

@implementation YBLTakeOrderParaLineItemsModel

@end

@implementation YBLTakeOrderParaItemModel

- (id)mutableCopyWithZone:(NSZone *)zone{
    return [self copyWithZone:zone];
}
- (id)copyWithZone:(NSZone *)zone
{
    //实现自定义浅拷贝
    YBLTakeOrderParaItemModel *property = [[self class] allocWithZone:zone];
    property.shop_id = [_shop_id mutableCopy];
    property.invoice = [_invoice mutableCopy];
    property.message = [_message mutableCopy];
    property.line_items = [_line_items mutableCopy];
    property.ship_address_id = [_ship_address_id mutableCopy];
    return property;
}

@end

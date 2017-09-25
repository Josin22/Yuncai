//
//  YBLOrderConfirmModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLAddressModel.h"
#import "YBLCartModel.h"

@interface YBLOrderConfirmModel : NSObject

@property (nonatomic, strong) NSString *default_ship_address_id;

@property (nonatomic, strong) NSMutableArray *shop_line_items;

/**
 *  选择收货地址
 */
@property (nonatomic, strong) YBLAddressModel *default_ship_address;
/**
 *  下单总价
 */
@property (nonatomic, strong) NSNumber *shops_total;

@end

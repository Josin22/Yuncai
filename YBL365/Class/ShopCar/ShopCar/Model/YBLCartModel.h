//
//  YBLCartModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lineitems.h"
#import "YBLInvoiceModel.h"
#import "shop.h"

@interface YBLCartModel :NSObject

@property (nonatomic , strong) shop              * shop;
@property (nonatomic , strong) NSNumber          * item_total;
@property (nonatomic , strong) NSNumber          * adjustment_total;
@property (nonatomic , strong) NSNumber          * shipment_total;
/**
 *  单个订单件数
 */
@property (nonatomic , strong) NSNumber          * item_count;
/**
 *  单个订单总价 = item_total+shippingment_total-adjustment_tatol
 */
@property (nonatomic , strong) NSNumber          * total;
/**
 *  发票
 */
@property (nonatomic , strong) YBLInvoiceModel   * invoice;
/**
 *  店铺留言
 */
@property (nonatomic, strong) NSString           * shop_mark;
/**
 *  原lineitems
 */
@property (nonatomic , strong) NSMutableArray    * line_items;
/**
 *  过滤lineitem
 */
@property (nonatomic , strong) NSMutableArray    * filter_line_items;

@end

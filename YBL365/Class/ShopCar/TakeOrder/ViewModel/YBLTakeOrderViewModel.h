//
//  YBLTakeOrderViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLOrderConfirmModel.h"
#import "YBLAddressModel.h"

@class YBLTakeOrderModel;

@interface YBLTakeOrderViewModel : NSObject
/**
 *  订单确认数据
 */
@property (nonatomic, strong) YBLOrderConfirmModel *orderConfirmModel;
/**
 *  原始参数
 */
@property (nonatomic, strong) NSMutableArray       *orderConfirmParaArray;
/**
 *  copy参数@!!@
 */
@property (nonatomic, strong) NSMutableArray       *orderConfirmParaCopyArray;
/**
 *  是否没有地址
 */
@property (nonatomic, assign) BOOL                 isHaveAddress;
/**
 *  是否都没有库存
 */
@property (nonatomic, assign) BOOL                 isCanTakeOrder;
/**
 *  提交订单信号
 */
@property (nonatomic, strong) RACSignal            *commitSignal;
/**
 *  返回订单信息
 */
@property (nonatomic, strong) YBLTakeOrderModel    *takeOrderModel;

- (void)resetOrderConfirmParaArray;

- (RACSignal *)orderConfirmSiganl:(NSString *)addressId;
/**
 *  重新计算改变的当前section物流运费总价
 */
- (float)ReCalculateCurrentSectionPrice:(NSInteger)section;

@end

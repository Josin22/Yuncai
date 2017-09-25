//
//  YBLSettingPayShippingMentViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPayShippingmentsModel.h"

typedef NS_ENUM(NSInteger,SettingPayShippingMentVCType) {
    //单个商品修改
    SettingPayShippingMentVCTypeSingleGoodChange = 0,
    //多商品批量
    SettingPayShippingMentVCTypeManyGoodChange
};

@interface YBLSettingPayShippingMentViewModel : NSObject
/**
 *  支付配送方式类型
 */
@property (nonatomic, assign) SettingPayShippingMentVCType settingPayShippingMentVCType;
/**
 *  商品id
 */
@property (nonatomic, copy  ) NSString *_id;
/**
 *  所有支付方式
 */
@property (nonatomic, strong) NSMutableArray *allShippingmentDataArray;
/**
 *  所有配送方式
 */
@property (nonatomic, strong) NSMutableArray *allPaymentDataArray;

@property (nonatomic, strong) NSMutableArray *allNoPayshippingmentArray;
/**
 *  获取所有的配送及支付方式
 *
 *  @return return value description
 */
- (RACSignal *)siganlForAllPayShippingMent;
/**
 *  获取未设置配送及支付方式商品列表
 *
 *  @return return value description
 */
- (RACSignal *)siganlForNoPayShippingMentProduct;
/**
 *  是否有选择其中
 *
 *  @return BOOL
 */
- (NSArray *)isHasChooseSameCityShipPayment:(BOOL)isSameCity;
/**
 *  设置所有配送支付方式
 *
 *  @return return value description
 */
- (RACSignal *)siganlForSettingShippingPayment;
/**
 *  显示商品配送及支付方式
 *
 *  @return return value description
 */
- (RACSignal *)siganlForGetShippingPayment;

@end

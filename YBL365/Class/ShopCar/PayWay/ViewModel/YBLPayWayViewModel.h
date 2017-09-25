//
//  YBLPayWayViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YBLTakeOrderModel;

@interface YBLPayWayViewModel : NSObject
///订单数据
@property (nonatomic, strong) YBLTakeOrderModel *takeOrderModel;
///订单方式
@property (nonatomic, assign) OrderType payWay;
///支付方式
@property (nonatomic, assign) PayWayType payWayType;
///支付宝参数
@property (nonatomic, strong) NSString *aliPayParaString;
///微信参数
@property (nonatomic, strong) NSDictionary *wxPayParaDict;

@property (nonatomic, strong) RACSignal *orderPaySignal;

@end

//
//  YBLPurchaseBiddingViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLAllPurchaseInfoModel.h"

@class YBLPurchaseOrderModel,YBLBidingRecordsModel,YBLAddressModel;

@interface PurchaseBiddingParaModel : NSObject

@property (nonatomic, strong) NSString *_id;
///当前价格
@property (nonatomic, strong) NSNumber *price;
///保证金
@property (nonatomic, strong) NSNumber *baozhengjinprice;
///报价
@property (nonatomic, strong) NSNumber *out_price;

@property (nonatomic, strong) NSString *paytype_id;

@property (nonatomic, strong) NSString *distribution_id;

@property (nonatomic, strong) NSString *address_id;

@end

@interface YBLPurchaseBiddingViewModel : NSObject
/**
 *  请求参数信息
 */
@property (nonatomic, strong) PurchaseBiddingParaModel *paraModel;
/**
 *  采购单信息
 */
@property (nonatomic, strong) YBLPurchaseOrderModel *purchaseDetailModel;
/**
 *  竞标信息
 */
@property (nonatomic, strong) YBLBidingRecordsModel *bidModel;
/**
 *  所有支付方式
 */
@property (nonatomic, strong) YBLAllPurchaseInfoModel *allPurchaseModel;
/**
 *  竞标过地址好或者默认地址
 */
@property (nonatomic, strong) YBLAddressModel *bidOrDefaultAddress;

@property (nonatomic, strong) RACSignal *purhcaseBiddingSignal;

@property (nonatomic, strong) NSMutableDictionary *idsDict;

@property (nonatomic, assign) BOOL sameCity;

@property (nonatomic, assign) BOOL isChooseFromAddressVC;

- (RACSignal *)siganlCheckSameCity;

- (RACSignal *)siganlForAllPurchaseInfos;
+ (RACSignal *)siganlForAllPurchaseInfos;

@end

//
//  YBLPurchaseOutPriceRecordsViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLBaseFoundViewModel.h"

@interface YBLBidingRecordsModel : NSObject

@property (nonatomic, strong) YBLAddressModel *address;

@property (nonatomic, strong) NSMutableArray *bidding;

@property (nonatomic, strong) YBLPurchaseOrderModel *purchase_order;

@end

@interface YBLPurchaseOutPriceRecordsViewModel : YBLBaseFoundViewModel

@property (nonatomic, strong) YBLBidingRecordsModel *biddingRecordsModel;

@property (nonatomic, strong) YBLAddressModel *addressModel;

@property (nonatomic, strong) YBLPurchaseOrderModel *purchaseDetailModel;
///选中竞标者
@property (nonatomic, strong) YBLPurchaseOrderModel *chooseBidModel;

@property (nonatomic, strong) NSMutableArray *recordsDataArray;

//@property (nonatomic, assign) BOOL isNoMoreData;

- (RACSignal *)siganlForOnePurchaseRecordsDetailWithBidid:(NSString *)bid_id;
///报价记录
- (RACSignal *)siganlForPurchaseBidRecordsisReload:(BOOL)isReload;
///报价记录
+ (RACSignal *)siganlForPurchaseBidRecordsWithOrderId:(NSString *)orderId;
///查询最低报价
- (RACSignal *)signalForSearchCheapestWithOrderid:(NSString *)orderid;
///查询最低报价
+ (RACSignal *)signalForSearchCheapestWithOrderid:(NSString *)orderid;
///选择中标者
- (RACSignal *)signalForChooseBid;
///取消订单
- (RACSignal *)signalForCanclePurchaseOrder;
+ (RACSignal *)signalForCanclePurchaseOrder:(NSString *)orderid;
///判断取消订单是否扣除保证金
- (RACSignal *)signalForJudgeCanclePurchaseOrderIsDeductBaozhengjin;
+ (RACSignal *)signalForJudgeCanclePurchaseOrderIsDeductBaozhengjinOrderid:(NSString *)orderid;
///再次发布
- (RACSignal *)signalForReleaseAgain;
+ (RACSignal *)signalForReleaseAgainWithId:(NSString *)_id;



@end

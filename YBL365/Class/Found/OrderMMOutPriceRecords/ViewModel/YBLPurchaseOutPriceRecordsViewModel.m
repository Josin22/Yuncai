//
//  YBLPurchaseOutPriceRecordsViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseOutPriceRecordsViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLAddressModel.h"

@implementation YBLBidingRecordsModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"bidding":[YBLPurchaseOrderModel class]};
    
}

@end


@interface YBLPurchaseOutPriceRecordsViewModel ()
{
    NSInteger page;
}
@end

@implementation YBLPurchaseOutPriceRecordsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        page = 0;
    }
    return self;
}

- (NSMutableArray *)recordsDataArray{
    
    if (!_recordsDataArray) {
        _recordsDataArray = [NSMutableArray array];
    }
    return _recordsDataArray;
}

///查询最低报价
+ (RACSignal *)signalForSearchCheapestWithOrderid:(NSString *)orderid{

    return [[self alloc] signalForSearchCheapestWithOrderid:orderid];
 
}

///查询最低报价
- (RACSignal *)signalForSearchCheapestWithOrderid:(NSString *)orderid{
  

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self signalForSearchBiddingsWithOrderID:orderid
                                       bidID:nil
                                  isCheapest:YES
                                        page:1
                                    pageSize:page_size
                                    isReload:YES] subscribeNext:^(id  _Nullable x) {
        
        YBLBidingRecordsModel *model = [YBLBidingRecordsModel yy_modelWithJSON:x];
        [subject sendNext:model];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
    
}

///报价记录
+ (RACSignal *)siganlForPurchaseBidRecordsWithOrderId:(NSString *)orderId{
    
    return [[self alloc] siganlForPurchaseBidRecordsWithOrderID:orderId isReload:YES pageSize:1];
}
///报价记录
- (RACSignal *)siganlForPurchaseBidRecordsisReload:(BOOL)isReload{
    
    return [self siganlForPurchaseBidRecordsWithOrderID:self.purchaseDetailModel._id isReload:isReload pageSize:page_size];
}
///报价记录
- (RACSignal *)siganlForPurchaseBidRecordsWithOrderID:(NSString *)orderID isReload:(BOOL)isReload pageSize:(NSInteger)pageSize{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (isReload) {
        page = 0;
    }
    page++;
    
    [[self signalForSearchBiddingsWithOrderID:orderID
                                       bidID:nil
                                  isCheapest:NO
                                        page:page
                                     pageSize:pageSize
                                    isReload:isReload] subscribeNext:^(id  _Nullable x) {
        YBLBidingRecordsModel *model = [YBLBidingRecordsModel yy_modelWithJSON:x];
        self.biddingRecordsModel = model;
        self.addressModel = model.address;
        self.purchaseDetailModel = model.purchase_order;
        [self reSetPurchaseDetailModel:self.purchaseDetailModel];
        if (isReload) {
            [self.recordsDataArray removeAllObjects];
        }
        if (model.bidding.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
        }
        for (YBLPurchaseOrderModel *itemModel in model.bidding) {
            [self reSetPurchaseDetailModel:itemModel];
        }
        [self.recordsDataArray addObjectsFromArray:[model.bidding mutableCopy]];
        [subject sendNext:model];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}
//单个竞标信息
- (RACSignal *)siganlForOnePurchaseRecordsDetailWithBidid:(NSString *)bid_id{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self signalForSearchBiddingsWithOrderID:nil
                                       bidID:bid_id
                                  isCheapest:NO
                                        page:1
                                     pageSize:page_size
                                    isReload:YES] subscribeNext:^(id  _Nullable x) {
        YBLPurchaseOrderModel *bidModel = [YBLPurchaseOrderModel yy_modelWithJSON:x];
        [subject sendNext:bidModel];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}



- (RACSignal *)signalForChooseBid{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    if (!self.chooseBidModel) {
        [SVProgressHUD showErrorWithStatus:@"您还未选中竞标者呢~"];
        return subject;
    }
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"orderid"] = self.purchaseDetailModel._id;
    para[@"bidid"] = self.chooseBidModel._id;
    
    [YBLRequstTools HTTPPostWithUrl:url_purchasingorder_choose
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [subject sendNext:@YES];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)signalForCanclePurchaseOrder:(NSString *)orderid{
    
    return [[self alloc] signalForCanclePurchaseOrder:orderid];
}

- (RACSignal *)signalForCanclePurchaseOrder{
    
    return [self signalForCanclePurchaseOrder:self.purchaseDetailModel._id];
}

- (RACSignal *)signalForCanclePurchaseOrder:(NSString *)orderid{
    return [self signalForCanclePurchaseOrderIsDeductBaozhengjin:NO orderid:orderid];
}

+ (RACSignal *)signalForJudgeCanclePurchaseOrderIsDeductBaozhengjinOrderid:(NSString *)orderid{
    [SVProgressHUD showWithStatus:@"取消中..."];
    return [[self alloc] signalForCanclePurchaseOrderIsDeductBaozhengjin:YES orderid:orderid];
}

- (RACSignal *)signalForJudgeCanclePurchaseOrderIsDeductBaozhengjin {
    [SVProgressHUD showWithStatus:@"取消中..."];
    return [self signalForCanclePurchaseOrderIsDeductBaozhengjin:YES orderid:self.purchaseDetailModel._id];
}

- (RACSignal *)signalForCanclePurchaseOrderIsDeductBaozhengjin:(BOOL)isJudge orderid:(NSString *)orderID{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (isJudge) {
        para[@"type"] = @"0";
    } else {
        para[@"type"] = @"1";
    }
    para[@"orderid"] = orderID;
    
    [YBLRequstTools HTTPPostWithUrl:url_purchasingorder_cancle
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              if (isJudge) {
                                  BOOL flag = [result[@"flag"] boolValue];
                                  [subject sendNext:@(flag)];
                              } else {
                                  YBLPurchaseOrderModel *oderModel = [YBLPurchaseOrderModel yy_modelWithJSON:result[@"porder"]];
                                  [self handleModel:oderModel];
                                  [subject sendNext:oderModel];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)signalForReleaseAgainWithId:(NSString *)_id{
    return [[self alloc] signalForReleaseAgainWithId:_id];
}

- (RACSignal *)signalForReleaseAgain{
    
    return [self signalForReleaseAgainWithId:self.purchaseDetailModel._id];
}

- (RACSignal *)signalForReleaseAgainWithId:(NSString *)_id
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"再次发布中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"purchaseorderid"] = _id;

    [YBLRequstTools HTTPPostWithUrl:url_purchasingorder
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"发布成功~"];
                              YBLPurchaseOrderModel *purchaseOrderModel = [YBLPurchaseOrderModel yy_modelWithJSON:result];
                              [self handleModel:purchaseOrderModel];
                              [subject sendNext:purchaseOrderModel];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}
/*
 - (RACSignal *)signalForPurchaseBiddingSearchWithOrderid:(NSString *)orderid
 isCheapest:(BOOL)isCheapest
 bidid:(NSString *)bidid
 isReload:(BOOL)isReload
 pageSize:(NSInteger)pageSize{
 
 RACReplaySubject *subject = [RACReplaySubject subject];
 NSMutableDictionary *para = [NSMutableDictionary dictionary];
 NSString *url = url_purchasingorder_biddings;
 if (orderid) {
 para[@"orderid"] = orderid;
 }
 if (bidid) {
 para[@"bidid"] = bidid;
 
 }
 para[@"cheapest"] = @(isCheapest);
 if (isReload) {
 page = 0;
 }
 page++;
 para[@"page"] = @(page);
 para[@"per_page"] = @(pageSize);
 
 [YBLRequstTools HTTPGetDataWithUrl:url
 Parames:para
 commplete:^(id result, NSInteger statusCode) {
 if (bidid) {
 //单个竞标信息
 YBLPurchaseOrderModel *bidModel = [YBLPurchaseOrderModel yy_modelWithJSON:result];
 [subject sendNext:bidModel];
 } else {
 YBLAddressModel *addressModel = [YBLAddressModel yy_modelWithJSON:result[@"address"]];
 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLPurchaseOrderModel class] json:result[@"bidding"]];
 if (isCheapest||pageSize==1) {
 //查询最低报价
 YBLPurchaseOrderModel *purchaseOrderModel = nil;
 if (dataArray.count!=0) {
 purchaseOrderModel = dataArray[0];
 }
 if (!purchaseOrderModel) {
 [subject sendNext:nil];
 } else {
 [subject sendNext:@[addressModel,purchaseOrderModel]];
 }
 } else {
 //查询所有报价记录
 if (isReload) {
 [self.recordsDataArray removeAllObjects];
 }
 for (YBLPurchaseOrderModel *itemModel in dataArray) {
 
 }
 [self.recordsDataArray addObjectsFromArray:[dataArray mutableCopy]];
 }
 
 }
 [subject sendCompleted];
 }
 failure:^(NSError *error, NSInteger errorCode) {
 if (page!=0) {
 page -= 1;
 }
 [subject sendError:error];
 }];
 
 return subject;
 }
 
 */
@end

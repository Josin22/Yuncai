//
//  YBLEdictPurchaseViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEdictPurchaseViewModel.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLGoodModel.h"
#import "YBLpurchaseInfosModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLPurchaseBiddingViewModel.h"

@implementation YBLCheckGoldModel

@end

@implementation YBLEdictPurchaseViewModel

- (void)updateArray{
    
    if (self.cellDataArray.count>0) {
        [self.cellDataArray removeAllObjects];
    }
    NSString *goodTitle = self.goodModel.title;
    NSString *spec = self.goodModel.specification;
    NSString *code = [NSString stringWithFormat:@"%ld",(long)self.goodModel.qrcode.integerValue];
    NSString *caiCount = nil;
    NSString *caiprice = nil;
    NSString *unit = nil;
    NSString *pay = nil;
    NSString *pay_distribution_titles = nil;
    NSString *full_address = nil;
    NSMutableArray *pay_dis_array_ids = [NSMutableArray array];
    if (self.purchaseOrderModel) {
        goodTitle = self.purchaseOrderModel.title;
        spec = self.purchaseOrderModel.specification;
        code = [NSString stringWithFormat:@"%ld",(long)self.goodModel.qrcode.integerValue];
        caiCount = [NSString stringWithFormat:@"%ld",(long)self.purchaseOrderModel.quantity.integerValue];
        caiprice = [NSString stringWithFormat:@"%.2f",self.purchaseOrderModel.price.doubleValue];
        full_address = self.purchaseOrderModel.address_info.full_address;
        unit  = self.purchaseOrderModel.unit;
        NSString *payTitle = [YBLMethodTools getAppendingTitleStringWithArray:self.purchaseOrderModel.purchase_pay_types appendingKey:@"+"];
        NSString *distributionTitle = [YBLMethodTools getAppendingTitleStringWithArray:self.purchaseOrderModel.purchase_distributions appendingKey:@" "];
        pay_distribution_titles = [NSString stringWithFormat:@"%@ %@",payTitle,distributionTitle];
        NSString *payIds = [YBLMethodTools getAppendingStringWithArray:self.purchaseOrderModel.purchase_pay_types appendingKey:@","];
        NSString *distributionIds = [YBLMethodTools getAppendingStringWithArray:self.purchaseOrderModel.purchase_distributions appendingKey:@","];
        [pay_dis_array_ids addObject:payIds];
        [pay_dis_array_ids addObject:distributionIds];
        
    }
    [self.cellDataArray addObject:[self getModelWith:@"商品名称 : "
                                           value:goodTitle
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"title"
                                   paraValueString:goodTitle]];
    
    [self.cellDataArray addObject:[self getModelWith:@"商品规格 : "
                                           value:spec
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"specification"
                                   paraValueString:spec]];
    
    [self.cellDataArray addObject:[self getModelWith:@"商品条码 : "
                                           value:code
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"qrcode"
                                   paraValueString:code]];

    [self.cellDataArray addObject:[self getModelWith:@"采购价格 : "
                                           value:caiprice
                                      isRequired:YES
                                            type:EditTypeCellOnlyWrite
                                      paraString:@"price"
                                   paraValueString:caiprice]];

    [self.cellDataArray addObject:[self getModelWith:@"采购数量 : "
                                               value:caiCount
                                          isRequired:YES
                                                type:EditTypeCellOnlyWrite
                                          paraString:@"quantity"
                                     paraValueString:caiCount]];
    
    [self.cellDataArray addObject:[self getModelWith:@"包装单位 : "
                                               value:unit
                                          isRequired:YES
                                                type:EditTypeCellOnlyClick
                                          paraString:@"unit"
                                     paraValueString:unit]];
    
    [self.cellDataArray addObject:[self getModelWith:@"发布时限 : "
                                           value:self.purchaseOrderModel.purchasetime_title
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"purchase_time_id"
                                   paraValueString:self.purchaseOrderModel.purchasetime]];
    
    [self.cellDataArray addObject:[self getModelWith:@"采购方式 : "
                                           value:@"手动选择报价供应商"
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"rule_id"
                                   paraValueString:@"58f5fa0fccf9592bc893267c"]];
    
//    [self.cellDataArray addObject:[self getModelWith:@"保质期时间 : "
//                                           value:self.purchaseOrderModel.shelflifes_title
//                                      isRequired:YES
//                                            type:EditTypeCellOnlyClick
//                                      paraString:@"shelf_lifes_id"
//                                   paraValueString:self.purchaseOrderModel.shelflifes]];
    
    [self.cellDataArray addObject:[self getModelWith:@"销售效期 : "
                                           value:self.purchaseOrderModel.sellshelflifes_title
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"sell_shelf_lifes_id"
                                   paraValueString:self.purchaseOrderModel.sellshelflifes]];
    
    YBLEditItemGoodParaModel *pay_distribution_model = [self getModelWith:@"配送时效 : "
                                                                    value:pay_distribution_titles
                                                               isRequired:YES
                                                                     type:EditTypeCellOnlyClick
                                                               paraString:@"paytype"
                                                          paraValueString:pay];
    pay_distribution_model.undefineValue = pay_dis_array_ids;
    [self.cellDataArray addObject:pay_distribution_model];
    
//    [self.cellDataArray addObject:[self getModelWith:@"配送时效 : "
//                                           value:ship_han
//                                      isRequired:YES
//                                            type:EditTypeCellOnlyClick
//                                      paraString:@"distributionid"
//                                   paraValueString:ship]];
    
    [self.cellDataArray addObject:[self getModelWith:@"收货地址 : "
                                           value:full_address
                                      isRequired:YES
                                            type:EditTypeCellOnlyClick
                                      paraString:@"address_id"
                                     paraValueString:self.purchaseOrderModel.address_info.id]];

}

- (NSMutableArray *)cellDataArray{
    
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

- (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                           paraValueString:(NSString *)paraValueString{
    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel new];
    model.title = title;
    model.value = value;
    model.editTypeCell = type;
    model.isRequired = isRequired;
    model.paraString = paraString;
    model.paraValueString = paraValueString;
    return model;
}

- (RACSignal *)signalForPurchaseProduct{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *wid = nil;
    if (self.goodModel.id) {
        wid = self.goodModel.id;
    } else {
        wid = self.purchaseOrderModel.warehouse_product_id;
    }
    para[@"warehouse_product_id"] = wid;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchasingorder_purchaseproduct
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.goodModel = [YBLGoodModel yy_modelWithJSON:result];
                                 [self updateArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)signalForPurchaseinfosWithType:(NSInteger)type {
    
    return [[self alloc] signalForPurchaseinfosWithType:type];
}

- (RACSignal *)signalForPurchaseinfosWithType:(NSInteger)type{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"type"] = @(type);
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchasingorder_purchaseinfos
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [SVProgressHUD dismiss];
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLPurchaseInfosModel class] json:result];
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)signalForSavePurchaseOrder{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    [SVProgressHUD showWithStatus:@"保存中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"productid"] = self.goodModel._id;
    for (YBLEditItemGoodParaModel *paraModel in self.cellDataArray) {
        if ([paraModel.paraString isEqualToString:@"paytype"]) {
            NSMutableArray *dataArray = (NSMutableArray *)paraModel.undefineValue;
            para[@"paytype"] = dataArray[0];
            para[@"distributionid"] = dataArray[1];
        } else {
            para[paraModel.paraString] = paraModel.paraValueString;
        }
    }
    [YBLRequstTools HTTPPostWithUrl:url_purchasingorder
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              YBLPurchaseOrderModel *purcherModel = [YBLPurchaseOrderModel yy_modelWithJSON:result];
                              [subject sendNext:purcherModel];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)signalForCheckGold{
    
    float deposit = [self calculateFinalDepositMoney];
    return [self siganlForCheckGoldWith:deposit isBidding:NO];
}

+ (RACSignal *)signalBiddingForCheckGoldWith:(float)gold{
   return [[self alloc] siganlForCheckGoldWith:gold isBidding:YES];
}

+ (RACSignal *)signalReleasePurchaseForCheckGoldWith:(float)gold{
   return [[self alloc] siganlForCheckGoldWith:gold isBidding:NO];
}

- (RACSignal *)siganlForCheckGoldWith:(float)gold isBidding:(BOOL)isBidding{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];

    para[@"gold"] = @(gold);
    [YBLRequstTools HTTPGetDataWithUrl:url_wallets_check_gold
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 YBLCheckGoldModel *model = [YBLCheckGoldModel yy_modelWithJSON:result];
                                 if (!model.flag.boolValue) {
                                     float less_gold = gold-model.gold.doubleValue;
                                     model.less_gold = @(less_gold);
                                     NSString *other = @"发布";
                                     if (isBidding) {
                                         other = @"报价";
                                     }
                                     NSString *less_text = [NSString stringWithFormat:@"您的云币不足还需%d个云币才能%@哟~",model.less_gold.intValue,other]
                                     ;
                                     model.less_show_text = less_text;
                                 }
                                 [subject sendNext:model];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)signalForPurchaseOtherInfoWithType:(NSInteger)type{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"warehouse_product_id"] = self.goodModel.warehouse_product_id;
    NSString *typeString = nil;
    switch (type) {
        case 0:
        {
            typeString = @"title";
        }
            break;
        case 1:
        {
            typeString = @"specification";
        }
            break;
        case 2:
        {
            typeString = @"qrcode";
        }
            break;
        default:
            break;
    }
    para[@"type"] = typeString;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchasingorder_otherinfo
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [SVProgressHUD dismiss];
                                 NSMutableArray *dataArray = [NSMutableArray array];
                                 for (id objecx in result[@"dataarray"]) {
                                     [dataArray addObject:objecx];
                                 }
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (BOOL)isDoneAction{
    
    BOOL isDone = YES;
    for (YBLEditItemGoodParaModel *paraModel in self.cellDataArray) {
        if (paraModel.value.length == 0) {
            isDone = NO;
        }
    }
    return isDone;
}

- (RACSignal *)siganlForAllPayShipingMent{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    if (self.allPayShipModel) {
        [subject sendCompleted];
        return subject;
    }
    
    [[YBLPurchaseBiddingViewModel siganlForAllPurchaseInfos] subscribeNext:^(id  _Nullable x) {
        
        self.allPayShipModel = (YBLAllPurchaseInfoModel *)x;
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        
        [subject sendError:error];
    }];
    
    return subject;
}

- (float)calculateFinalDepositMoney{
    
    //3  4
    YBLEditItemGoodParaModel *numModel = self.cellDataArray[3];
    YBLEditItemGoodParaModel *priceModel = self.cellDataArray[4];
    float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:numModel.value.integerValue Price:priceModel.value.doubleValue];
    return baozhengjin;
}

@end

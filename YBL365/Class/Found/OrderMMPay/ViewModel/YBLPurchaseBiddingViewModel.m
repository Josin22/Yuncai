//
//  YBLPurchaseBiddingViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseBiddingViewModel.h"
#import "YBLEdictPurchaseViewModel.h"
#import "YBLPurchaseOrderModel.h"

@implementation PurchaseBiddingParaModel

@end

@implementation YBLPurchaseBiddingViewModel

- (RACSignal *)purhcaseBiddingSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = self.paraModel._id;
    para[@"price"] = self.paraModel.out_price;
    para[@"pay_type_id"] = self.paraModel.paytype_id;
    para[@"distribution_id"] = self.paraModel.distribution_id;
    if (self.paraModel.address_id.length>0) {
        para[@"address_id"] = self.paraModel.address_id;   
    }
    
    [YBLRequstTools HTTPPostWithUrl:url_purchasingorder_bidding
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)siganlForAllPurchaseInfos{
    return [[self alloc] siganlForAllPurchaseInfosISef:NO];
}

- (RACSignal *)siganlForAllPurchaseInfos{
    
    return [self siganlForAllPurchaseInfosISef:YES];
}

- (RACSignal *)siganlForAllPurchaseInfosISef:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showSuccessWithStatus:@"加载中..."];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchase_paytype_distribution
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [SVProgressHUD dismiss];
                                 
                                 YBLAllPurchaseInfoModel *model = [YBLAllPurchaseInfoModel yy_modelWithJSON:result];
                                 //遍历支付方式
                                 NSMutableArray *all_pay_distribution_array = [NSMutableArray array];
                                 for (YBLPurchaseInfosModel *payModel in model.paytypes) {
                                     //
                                     NSMutableArray *all_distribution_array = [NSMutableArray array];
                                     NSMutableArray *same_ciry_array = [NSMutableArray array];
                                     NSMutableArray *no_same_ciry_array = [NSMutableArray array];
                                     //遍历其下配送时效id
                                     for (NSString *distribution_id in payModel.purchase_distribution_ids) {
                                         //遍历distributions找相同id
                                         for (YBLPurchaseInfosModel *distribution_model in model.distributions) {
                                             if ([distribution_model._id isEqualToString:distribution_id]) {
                                                 if (distribution_model.same_city.boolValue) {
                                                     [same_ciry_array addObject:distribution_model];
                                                 } else {
                                                     [no_same_ciry_array addObject:distribution_model];
                                                 }
                                             }
                                         }
                                     }
                                     //过滤后同城
                                     if (same_ciry_array.count>0) {
                                         [all_distribution_array addObject:same_ciry_array];
                                     }
                                     //过滤异地
                                     if (no_same_ciry_array.count>0) {
                                         [all_distribution_array addObject:no_same_ciry_array];
                                     }
                                     payModel.filter_purchase_distribution_data = all_distribution_array;
                                     [all_pay_distribution_array addObject:payModel];
                                 }
                                 model.filter_infos_data_array = all_pay_distribution_array;
                                 
                                 if (isSelf) {
                                     self.allPurchaseModel =  model;
                                 } else {
                                     [subject sendNext:model];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];

    return subject;
}

- (RACSignal *)siganlCheckSameCity{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"orderid"] = self.paraModel._id;
    para[@"address_id"] = self.paraModel.address_id;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchasingorder_same_city
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.sameCity = [result[@"same_city"] boolValue];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end


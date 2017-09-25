//
//  YBLCreditsPayViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCreditsPayViewModel.h"

@implementation YBLCreditsPayViewModel

- (RACSignal *)signalForPayCreditsWithPayModel:(NSInteger)index{
 
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    self.isPaying = NO;
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"standard_id"] = self.payModel.id;
    para[@"pay_mode"] = @(index);
    
    NSString *url = @"";
    if (_takeOrderType == TakeOrderTypeRechargeYunMoeny) {
        url = url_credit_recharge;
    } else {
        if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
            url = url_credit;
        } else if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeMember) {
            url = url_credit_member;
        }
    }
    
    [YBLRequstTools HTTPPostWithUrl:url
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              //开启支付了
                              self.isPaying = YES;
                              self.payOrderModel = [YBLCreditOrderModel yy_modelWithJSON:result];
                              [subject sendCompleted];
                              [SVProgressHUD dismiss];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)signalForCheckPayResult{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    self.isSearchPayResult = YES;
    
    NSString *url = nil;
    if (_takeOrderType == TakeOrderTypeRechargeYunMoeny) {
        url = url_credit_recharge_check(self.payOrderModel.id);
    } else {
        if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
            url = url_credit_check(self.payOrderModel.id);
        } else if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeMember) {
            url = url_credit_memeber_check(self.payOrderModel.id);
            
        }
    }
    
    [YBLRequstTools HTTPGetDataWithUrl:url
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 YBLCreditOrderModel *resultModel = [YBLCreditOrderModel yy_modelWithJSON:result];
                                 if (resultModel.state.integerValue == 1) {
                                     
                                     [SVProgressHUD showSuccessWithStatus:@"支付成功~"];
                                     
                                 } else {
                                     self.isSearchPayResult = NO;
                                     [SVProgressHUD showErrorWithStatus:@"支付失败~"];
                                 }
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [subject sendNext:@(resultModel.state.integerValue)];
                                     [subject sendCompleted];
                                 });
                                 
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   self.isSearchPayResult = NO;
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

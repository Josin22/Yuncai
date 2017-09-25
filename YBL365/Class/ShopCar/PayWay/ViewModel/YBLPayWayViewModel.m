//
//  YBLPayWayViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayWayViewModel.h"
#import "YBLTakeOrderModel.h"

@implementation YBLPayWayViewModel

- (RACSignal *)orderPaySignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"努力加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *payment_method = nil;
    switch (self.payWayType) {
        case PayWayTypeTonglian:
        {
            payment_method = @"TongLianPay";
        }
            break;
        case PayWayTypeWXPay:
        {
            payment_method = @"WxPay";
        }
            break;
        case PayWayTypeAlipay:
        {
            payment_method = @"AliPay";
        }
            break;
            
        default:
            break;
    }
    para[@"payment_method"] = payment_method;
    
    [YBLRequstTools HTTPPostWithUrl:url_payment(@"")
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD dismiss];
                              if (result[@"wxpay_url"]) {
                                  self.wxPayParaDict = result[@"wxpay_url"];
                              } else if (result[@"alipay_url"]) {
                                  self.aliPayParaString = result[@"alipay_url"];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (NSDictionary *)wxPayParaDict{
    
    if (!_wxPayParaDict) {
        _wxPayParaDict = [NSDictionary dictionary];
    }
    return _wxPayParaDict;
}

@end

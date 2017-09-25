//
//  YBLOpenCreditsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOpenCreditsViewModel.h"
#import "YBLCreditPriceStandardsModel.h"

@implementation YBLOpenCreditsViewModel

- (NSArray *)credit_price_standards_array{
    
    if (!_credit_price_standards_array) {
        _credit_price_standards_array = [NSArray array];
    }
    return _credit_price_standards_array;
}

- (RACSignal *)creditPriceStandardsSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
        para[@"type"] = @"credit";
    } else {
        para[@"type"] = @"member";
    }
    [YBLRequstTools HTTPGetDataWithUrl:url_credit_price_standards
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.credit_price_standards_array = [NSArray yy_modelArrayWithClass:[YBLCreditPriceStandardsModel class] json:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

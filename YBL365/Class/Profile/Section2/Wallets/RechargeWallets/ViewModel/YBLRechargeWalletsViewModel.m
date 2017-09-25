//
//  YBLRechargeWalletsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRechargeWalletsViewModel.h"

@implementation YBLRechargeWalletsViewModel

- (NSMutableArray *)rechargeDataArray{
    
    if (!_rechargeDataArray) {
        _rechargeDataArray = [NSMutableArray array];
    }
    return _rechargeDataArray;
}

- (RACSignal *)rechargeWalletsSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_credit_recharge_price_standards
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [SVProgressHUD dismiss];
                                 
                                 self.rechargeDataArray = [[NSArray yy_modelArrayWithClass:[YBLRechargeWalletsModel class] json:result] mutableCopy];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

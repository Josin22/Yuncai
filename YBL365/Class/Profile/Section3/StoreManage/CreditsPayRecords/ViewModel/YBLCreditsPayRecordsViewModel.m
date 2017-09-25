//
//  YBLCreditsPayRecordsViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCreditsPayRecordsViewModel.h"


@implementation YBLCreditsPayRecordsViewModel

- (NSMutableArray *)recordsDataArray{
    
    if (!_recordsDataArray) {
        _recordsDataArray = [NSMutableArray array];
    }
    return _recordsDataArray;
}

- (RACSignal *)siganlForCreditRecords{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
        para[@"type"] = @"credit";
    } else {
        para[@"type"] = @"member";
    }
    
    [YBLRequstTools HTTPGetDataWithUrl:url_credit_payments
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLCreditsPayRecordsModel class] json:result];
                                 self.recordsDataArray = [dataArray mutableCopy];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

//
//  YBLOrderDeliverViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDeliverViewModel.h"
#import "YBLDeliveritemModel.h"

@implementation YBLOrderDeliverViewModel

- (NSMutableArray *)deliverDataArray{
    if (!_deliverDataArray) {
        _deliverDataArray = [NSMutableArray array];
    }
    return _deliverDataArray;
}

- (RACSignal *)deliverSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_orders_order_tracks(self.orderID)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLDeliveritemModel class] json:result];
                                 self.deliverDataArray = [dataArray mutableCopy];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

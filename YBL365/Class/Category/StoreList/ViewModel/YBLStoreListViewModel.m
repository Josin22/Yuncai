//
//  YBLStoreListViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreListViewModel.h"
#import "shop.h"

@implementation YBLStoreListViewModel

- (NSMutableArray *)storeDataArray{
    if (!_storeDataArray) {
        _storeDataArray = [NSMutableArray array];
    }
    return _storeDataArray;
}

- (RACSignal *)siganlForStoreData{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
   
//    [SVProgressHUD showWithStatus:@"加载中..."];
    [YBLLogLoadingView showInWindow];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"shopname"] = self.storeName;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shops_search
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
//                                 [SVProgressHUD dismiss];
                                 [YBLLogLoadingView dismissInWindow];
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[shop class] json:result];
                                 self.storeDataArray = [dataArray mutableCopy];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end


//
//  YBLStoreRedbagViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreRedbagViewModel.h"

@implementation YBLStoreRedbagViewModel
/*
- (NSMutableArray *)storeDataArray{
    if (!_storeDataArray) {
        _storeDataArray = [NSMutableArray array];
    }
    return _storeDataArray;
}

- (RACSignal *)siganlForBaseStoreRedbag{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLLogLoadingView showInWindow];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_get_unfollow_shops
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [YBLLogLoadingView dismissInWindow];
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"YBLUserInfoModel") json:result];
                                 self.storeDataArray = dataArray.mutableCopy;
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}
*/

- (RACSignal *)siganlForBaseStoreRedbagIsReload:(BOOL)isReload{
    
    return [self siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                       isReload:isReload
                                                            url:url_get_unfollow_shops
                                                        dictKey:nil
                                                  jsonClassName:@"YBLUserInfoModel"];
}

@end

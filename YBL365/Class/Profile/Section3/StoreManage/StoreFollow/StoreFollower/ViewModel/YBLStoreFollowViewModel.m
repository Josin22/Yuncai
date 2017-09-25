//
//  YBLStoreFollowViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreFollowViewModel.h"

@implementation YBLStoreFollowViewModel

- (RACSignal *)signalForFollowGoodsIsReload:(BOOL)isReload{
    
    NSString *url = url_store_my_followers;
    NSString *dict_key = @"shops";
    NSString *className = @"YBLUserInfoModel";
    if (self.followType == FollowTypeShares) {
        url = url_products_sharers(self.rewardID);
        dict_key = @"product_sharers";
        className = @"YBLGoodSharersModel";
    }
    
   return [self siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                      isReload:isReload
                                                           url:url
                                                       dictKey:dict_key
                                                 jsonClassName:className];
}

- (RACSignal *)siganlForFollowPayMoneyWith:(NSString *)follow_id{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPPostWithUrl:url_store_pay(follow_id)
                            Parames:nil
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end

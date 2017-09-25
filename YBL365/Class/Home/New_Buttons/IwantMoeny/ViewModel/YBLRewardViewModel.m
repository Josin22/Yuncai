//
//  YBLRewardViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRewardViewModel.h"

@implementation YBLRewardViewModel

+ (RACSignal *)singalForAddShareCountWithRewardID:(NSString *)rewardID{
    
    return [[self alloc] singalForAddShareCountWithRewardID:rewardID];
}

- (RACSignal *)singalForAddShareCountWithRewardID:(NSString *)rewardID{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = rewardID;
    
    [YBLRequstTools HTTPPostWithUrl:url_products_add_share_count
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"分享成功~"];
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end

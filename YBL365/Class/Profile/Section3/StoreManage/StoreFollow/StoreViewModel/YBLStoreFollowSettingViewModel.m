
//
//  YBLStoreFollowSettingViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreFollowSettingViewModel.h"

@implementation YBLStoreFollowSettingViewModel

+ (RACSignal *)siganlForFollowOptions{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_store_follow_options
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

+ (RACSignal *)signalForSettingFollowOptionsWithMoney:(float)money types:(NSString *)types{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"follow_shop_money"] = @(money);
    para[@"follow_company_types"] = types;
    
    [YBLRequstTools HTTPPostWithUrl:url_store_follow_options
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  [subject sendNext:result];
                                  [subject sendCompleted];
                              });
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)siganlForStoreTransferWithDirection:(NSString *)dirction amount:(float)amount{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"quota_field"] = @"follow_quota";
    para[@"direction"] = dirction;
    para[@"amount"] = @(amount);
    
    [YBLRequstTools HTTPPostWithUrl:url_store_transfer
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD dismiss];
                              
                              if ([result[@"result"] isEqualToString:@"SUCCESS"]) {
                                  [subject sendNext:@(YES)];
                              } else {
                                  [subject sendNext:@(NO)];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end

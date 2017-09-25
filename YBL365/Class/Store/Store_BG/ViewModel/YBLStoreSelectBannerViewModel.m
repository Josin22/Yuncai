//
//  YBLStoreSelectBannerViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreSelectBannerViewModel.h"
#import "YBLStoreBannerModel.h"

@implementation YBLStoreSelectBannerViewModel

- (NSMutableArray *)pureImageURLArray{
    if (!_pureImageURLArray) {
        _pureImageURLArray = [NSMutableArray array];
    }
    return _pureImageURLArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSignal *)siganlForAllStoreBanner{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"self_picture"] = @(false);
    
    [YBLRequstTools HTTPGetDataWithUrl:url_shopfixtrue_picture
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLStoreBannerModel class] json:result];
                                 self.dataArray = [dataArray mutableCopy];
                                 for (YBLStoreBannerModel *itemModel in dataArray) {
                                     [self.pureImageURLArray addObject:itemModel.picture];
                                 }
                                 [subject sendNext:dataArray];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)siganlForSettingStoreBanner{
    
    RACReplaySubject *subejct = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"设置中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"fixture_picture_id"] = self.select_id;
    para[@"model"] = @"banner";
    
    [YBLRequstTools HTTPPostWithUrl:url_shopfixtrue
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"设置成功~"];
                              YBLStoreBannerModel *model = [YBLStoreBannerModel yy_modelWithJSON:result];
                              [subejct sendNext:model];
                              [subejct sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subejct sendError:error];
                            }];
    
    return subejct;
}

@end

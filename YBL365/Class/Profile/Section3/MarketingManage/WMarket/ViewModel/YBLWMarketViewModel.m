
//
//  YBLWMarketViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWMarketViewModel.h"
#import "YBLWMarketGoodModel.h"

@interface YBLWMarketViewModel ()

@end

@implementation YBLWMarketViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (RACSignal *)signalForDeleteWmarketGoodWithID:(NSString *)Mid index:(NSInteger)index{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    [SVProgressHUD showWithStatus:@"删除中..."];
    WEAK
    [YBLRequstTools HTTPDELETEWithUrl:url_small_marketing_set(Mid)
                              Parames:nil
                            commplete:^(id result, NSInteger statusCode) {
                                STRONG
                                [self.singleDataArray removeObjectAtIndex:index];
//                                NSMutableArray *indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:index appendingCount:1];
                                [subject sendNext:result];
                                [subject sendCompleted];
                            }
                              failure:^(NSError *error, NSInteger errorCode) {
                                  [subject sendError:error];
                              }];
    
    return subject;
}

- (RACSignal *)siganlForWMarketGoodWithProductIDs:(NSMutableArray *)product_ids{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    [YBLLogLoadingView showInWindow];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"product_ids"] = [product_ids yy_modelToJSONString];
    WEAK
    [YBLRequstTools HTTPPostWithUrl:url_small_marketing
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              STRONG
                              [YBLLogLoadingView dismissInWindow];
                              NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"YBLWMarketGoodModel") json:result[@"small_marketings"]];
                              NSMutableArray *indexPaths = @[].mutableCopy;
                              NSInteger index = 0;
                              for (YBLWMarketGoodModel *itemModel in dataArray) {
                                  [self.singleDataArray insertObject:itemModel atIndex:0];
                                  NSIndexPath *pps = [NSIndexPath indexPathForRow:index inSection:0];
                                  [indexPaths addObject:pps];
                                  index++;
                              }
                              [subject sendNext:indexPaths];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)siganlForWMarketGoodIsReload:(BOOL)isReload{
    
    return [self js_siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                          isReload:isReload
                                                               url:url_small_marketing
                                                           dictKey:@"small_marketings"
                                                     jsonClassName:@"YBLWMarketGoodModel"];
    /*
    RACReplaySubject *subject = [RACReplaySubject subject];
    WEAK
    [[self siganlForSingleListViewRequestLoadMoreWithPara:nil
                                                     url:url_small_marketing
                                                isReload:isReload] subscribeNext:^(id  _Nullable result) {
        STRONG
        if (isReload) {
            [self.wMarketDataArray removeAllObjects];
        }
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"YBLWMarketGoodModel") json:result[@"small_marketings"]];
        self.totalCount = [result[@"total"] integerValue];
//        NSMutableArray *indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:self.wMarketDataArray.count appendingCount:dataArray.count];
        NSMutableArray *indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:self.wMarketDataArray.count appendingCount:dataArray.count inSection:0];
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.wMarketDataArray addObjectsFromArray:dataArray];
        }
        [subject sendNext:indexps];
        [subject sendCompleted];

    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
  
    if (isReload) {
        [YBLLogLoadingView showInWindow];
        page_index = 0;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    page_index++;
    para[@"page"] = @(page_index);
    para[@"per_page"] = @(page_size);
    self.isReqesuting = YES;
    [YBLRequstTools HTTPGetDataWithUrl:url_small_marketing
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.isReqesuting = NO;
                                 if (isReload) {
                                     [YBLLogLoadingView dismissInWindow];
                                     [self.wMarketDataArray removeAllObjects];
                                 }
                                 NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(@"YBLWMarketGoodModel") json:result[@"small_marketings"]];
                                 self.totalCount = [result[@"total"] integerValue];
                                 NSMutableArray *indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:self.wMarketDataArray.count appendingCount:dataArray.count];
                                 if (dataArray.count==0) {
                                     self.isNoMoreData = YES;
                                 } else {
                                     self.isNoMoreData = NO;
                                     [self.wMarketDataArray addObjectsFromArray:dataArray];
                                 }
                                 [subject sendNext:indexps];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   self.isReqesuting = NO;
                                   [subject sendError:error];
                               }];
    
    return subject;
      */
}

+ (RACSignal *)siganlForWmarketGoodID:(NSString *)goodID{
    
    return [[self alloc] siganlForWmarketGoodID:goodID];
}

- (RACSignal *)siganlForWmarketGoodID:(NSString *)goodID{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_small_marketing_set(goodID)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 YBLWMarketGoodModel *model = [YBLWMarketGoodModel yy_modelWithJSON:result];
                                 [subject sendNext:model];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

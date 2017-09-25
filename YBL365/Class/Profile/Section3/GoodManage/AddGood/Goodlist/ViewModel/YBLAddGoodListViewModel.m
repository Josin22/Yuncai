//
//  YBLAddGoodListViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddGoodListViewModel.h"

@interface YBLAddGoodListViewModel ()
{
    NSInteger page;
}
@end

@implementation YBLAddGoodListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        page = 0;
    }
    return self;
}

- (NSMutableArray *)goodListArray{
    
    if (!_goodListArray) {
        _goodListArray = [NSMutableArray array];
    }
    return _goodListArray;
}

- (RACSignal *)singalForMoreCategoryDataListRealod:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *url = nil;
    if (self.goodCategoryType == GoodCategoryTypeForPurchaseWithTabbar||self.goodCategoryType == GoodCategoryTypeForPurchaseWithOutTabbar) {
        url = url_purchase_products(self.category_id);
    } else {
        url = url_category_products(self.category_id);
    }
    [[self siganlForRequestSearchIsReload:isReload para:para URL:url] subscribeNext:^(id  _Nullable result) {
        if (isReload) {
            [self.goodListArray removeAllObjects];
        }
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result];
//        NSMutableArray *indexPs = [YBLMethodTools getNewAppendingIndexPathsWithIndex:self.goodListArray.count appendingCount:dataArray.count];
        NSMutableArray *indexPs = [YBLMethodTools getRowAppendingIndexPathsWithIndex:self.goodListArray.count appendingCount:dataArray.count inSection:0];
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.goodListArray addObjectsFromArray:dataArray];
        }
        [subject sendNext:indexPs];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

+ (RACSignal *)singalForSaveToStoreWithId:(NSString *)_id{
    
    return [[self alloc] singalForSaveToStoreWithId:_id];
}
- (RACSignal *)singalForSaveToStoreWithId:(NSString *)_id{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPPostWithUrl:url_products_savetostore(_id)
                            Parames:nil
                          commplete:^(id result,NSInteger statusCode) {
                              NSString *errorInfo = result[@"error"];
                              if (errorInfo) {
                                  [SVProgressHUD showErrorWithStatus:errorInfo];
                                  [subject sendNext:@(NO)];
                              } else {
                                  [SVProgressHUD showSuccessWithStatus:@"添加到店铺成功~"];
                                  [subject sendNext:@(YES)];
                              }
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

- (RACSignal *)siganlForProductSearchIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"category_id"] = nil;
    para[@"title"] = self.keyword;
    
    [[self siganlForRequestSearchIsReload:isReload para:para URL:url_product_search] subscribeNext:^(id  _Nullable result) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result[@"products"]];
        if (isReload) {
            [self.goodListArray removeAllObjects];
        }
//        NSMutableArray *indexPs = [YBLMethodTools getNewAppendingIndexPathsWithIndex:self.goodListArray.count appendingCount:dataArray.count ];
        NSMutableArray *indexPs = [YBLMethodTools getRowAppendingIndexPathsWithIndex:self.goodListArray.count appendingCount:dataArray.count inSection:0];
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.goodListArray addObjectsFromArray:dataArray];
        }
        [subject sendNext:indexPs];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

- (RACSignal *)siganlForRequestSearchIsReload:(BOOL)isReload para:(NSMutableDictionary*)para URL:(NSString *)url{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    self.isRequesting = YES;
    page++;
    para[@"page"] = @(page);
    para[@"per_page"] = @(page_size);
    if (isReload) {
        page = 1;
        para[@"page"] = @(page);
        [YBLLogLoadingView showInWindow];
    }
    [YBLRequstTools HTTPGetDataWithUrl:url
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 if (isReload) {
                                     [YBLLogLoadingView dismissInWindow];
                                 }
                                 self.isRequesting = NO;
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   self.isRequesting = NO;
                                   if (page>0) {
                                       page--;
                                   }
                                   [subject sendError:error];
                               }];
    
    return subject;
}

@end

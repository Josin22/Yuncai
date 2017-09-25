//
//  YBLPerPageBaseViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPerPageBaseViewModel.h"

@implementation YBLPerPageBaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectTitle = self.all_title_data_array[0];
        page_index = 0;
    }
    return self;
}


- (NSMutableArray *)singleDataArray{
    if (!_singleDataArray) {
        _singleDataArray = [NSMutableArray array];
    }
    return _singleDataArray;
}

- (void)hanldeTitleData{
    
    [self.all_title_data_array removeAllObjects];
    
    NSInteger index = 0;
    for (NSString *title in self.titleArray[0]) {
        YBLCategoryTreeModel *commentModel = [YBLCategoryTreeModel new];
        commentModel.id = [NSString stringWithFormat:@"%@",@(index)];
        commentModel.title = title;
        if (self.titleArray.count>1) {
            commentModel.para_value  = self.titleArray[1][index];
        }
        if (self.titleArray.count>2) {
            commentModel.para_three_value = self.titleArray[2][index];
        }
        [self.all_title_data_array addObject:commentModel];
        index++;
    }
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSMutableDictionary *)all_purchase_order_data_dict{
    
    if (!_all_purchase_order_data_dict) {
        _all_purchase_order_data_dict = [NSMutableDictionary dictionary];
    }
    return _all_purchase_order_data_dict;
}

- (NSMutableDictionary *)all_is_nomore_data_dict{
    if (!_all_is_nomore_data_dict) {
        _all_is_nomore_data_dict = [NSMutableDictionary dictionary];
    }
    return _all_is_nomore_data_dict;
}

- (NSMutableDictionary *)all_page_data_dict{
    if (!_all_page_data_dict) {
        _all_page_data_dict = [NSMutableDictionary dictionary];
    }
    return _all_page_data_dict;
}

- (NSMutableArray *)all_title_data_array{
    
    if (!_all_title_data_array) {
        _all_title_data_array = [NSMutableArray array];
        //默认
        YBLCategoryTreeModel *morenModel = [YBLCategoryTreeModel new];
        morenModel.id = @"0";
        morenModel.title = @"全部";
        [_all_title_data_array addObject:morenModel];
    }
    return _all_title_data_array;
}

- (NSMutableArray *)getCurrentDataArrayWithIndex:(NSInteger)index{
    YBLCategoryTreeModel *check_title_id_model = self.all_title_data_array[index];
    NSMutableArray *check_array = self.all_purchase_order_data_dict[check_title_id_model.id];
    return check_array;
}

- (BOOL)isSatisfyRequestWithIndex:(NSInteger)index{
    BOOL isNomoreData = [self.all_is_nomore_data_dict[[NSString stringWithFormat:@"%@",@(index)]] boolValue];
    return (!self.isReqesuting&&!isNomoreData);
}

- (BOOL)isSatisfyLoadMoreRequest{
    return (!self.isNoMoreData&&!self.isReqesuting);
}

- (RACSignal *)siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                     isReload:(BOOL)isReload
                                                          url:(NSString *)url
                                                      dictKey:(NSString *)dictKey
                                                jsonClassName:(NSString *)jsonClassName{
    
    return [self siganlForSingleListViewRequestLoadMoreWithPara:para
                                                       isReload:isReload
                                                            url:url
                                                        dictKey:dictKey
                                                  jsonClassName:jsonClassName
                                                    isNewMethod:NO
            ];
}
- (RACSignal *)js_siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                     isReload:(BOOL)isReload
                                                          url:(NSString *)url
                                                      dictKey:(NSString *)dictKey
                                                jsonClassName:(NSString *)jsonClassName{
    
    return [self siganlForSingleListViewRequestLoadMoreWithPara:para
                                                       isReload:isReload
                                                            url:url
                                                        dictKey:dictKey
                                                  jsonClassName:jsonClassName
                                                    isNewMethod:YES
            ];
}
- (RACSignal *)siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                     isReload:(BOOL)isReload
                                                          url:(NSString *)url
                                                      dictKey:(NSString *)dictKey
                                                jsonClassName:(NSString *)jsonClassName
                                                  isNewMethod:(BOOL)isNewMethod{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self siganlForSingleListViewRequestLoadMoreWithPara:para
                                                     url:url
                                                isReload:isReload] subscribeNext:^(id  _Nullable x) {
        if (isReload) {
            [self.singleDataArray removeAllObjects];
        }
        NSArray *separateKeyArray = [dictKey componentsSeparatedByString:@"/"];
        for (NSString *sepret_key in separateKeyArray) {
            x = x[sepret_key];
        }
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(jsonClassName) json:x];
        if (isNewMethod) {
            [subject sendNext:dataArray];
        }
        NSInteger index_from = self.singleDataArray.count;
//        NSMutableArray *fin_indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:index_from appendingCount:dataArray.count];
        NSMutableArray *fin_indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:index_from appendingCount:dataArray.count inSection:0];
       
        if (dataArray.count==0) {
            self.isNoMoreData = YES;
        } else {
            self.isNoMoreData = NO;
            [self.singleDataArray addObjectsFromArray:dataArray];
        }
        if (!isNewMethod) {
            [subject sendNext:fin_indexps];
        }
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
    
}

- (RACSignal *)siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                          url:(NSString *)url
                                                     isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (![self isSatisfyLoadMoreRequest]&&!isReload) {
        return subject;
    }
    if (!para) {
        para = [NSMutableDictionary dictionary];
    }
    if (isReload) {
        [YBLLogLoadingView showInWindow];
        page_index = 0;
    }
    page_index++;
    para[@"page"] = @(page_index);
    para[@"per_page"] = @(page_size);
    self.isReqesuting = YES;
    [YBLRequstTools HTTPGetDataWithUrl:url
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.isReqesuting = NO;
                                 if (isReload) {
                                     [YBLLogLoadingView dismissInWindow];
                                 }
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   self.isReqesuting = NO;
                                   if (page_index>0) {
                                       page_index--;
                                   }
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                        url:(NSString *)url
                                                   isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (![self isSatisfyRequestWithIndex:self.currentFoundIndex]&&!isReload) {
        return subject;
    }
    if (isReload) {
        [YBLLogLoadingView showInWindow];
    }
    self.isReqesuting = YES;
    if (!para) {
        para = [NSMutableDictionary dictionary];
    }
    YBLCategoryTreeModel *model = self.all_title_data_array[self.currentFoundIndex];
    NSString *categoryID  = model.id;
    if (!self.all_page_data_dict[categoryID]||isReload) {
        [self.all_page_data_dict setObject:@(0) forKey:categoryID];
    }
    NSNumber *pageNumber = self.all_page_data_dict[categoryID];
    __block NSInteger page = pageNumber.integerValue;
    page++;
    para[@"page"] = @(page);
    para[@"per_page"] = @(page_size);
    
    [YBLRequstTools HTTPGetDataWithUrl:url
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.isReqesuting = NO;
                                 if (isReload ) {
                                     [YBLLogLoadingView dismissInWindow];
                                     //刷新删除旧数据
                                     [self.all_purchase_order_data_dict removeObjectForKey:categoryID];
                                 }
                                 [self.all_page_data_dict setObject:@(page) forKey:categoryID];
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   if (page > 0) {
                                       page--;
                                   }
                                   [self.all_page_data_dict setObject:@(page) forKey:categoryID];
                                   self.isReqesuting = NO;
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (NSMutableArray *)getNewIndexpathWithDataArray:(NSArray *)dataArray
                                      categotyID:(NSString *)categoryID
                                        isReload:(BOOL)isReload{
    return [self getNewIndexpathWithDataArray:dataArray categotyID:categoryID isReload:isReload isFromSection:NO];
}

- (NSMutableArray *)getNewIndexpathWithDataArray:(NSArray *)dataArray categotyID:(NSString *)categoryID isReload:(BOOL)isReload isFromSection:(BOOL)isFromSection{
    if (isReload) {
        //刷新删除旧数据
        [self.all_purchase_order_data_dict removeObjectForKey:categoryID];
    }
    NSMutableArray *array_frome_array = self.all_purchase_order_data_dict[categoryID];
    if (!array_frome_array) {
        NSMutableArray *first_data_array = [NSMutableArray array];
        [self.all_purchase_order_data_dict setObject:first_data_array forKey:categoryID];
        array_frome_array = self.all_purchase_order_data_dict[categoryID];
    }
    /*jisuan indexpath*/
    NSInteger index_from = array_frome_array.count;
    NSMutableArray *fin_indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:index_from appendingCount:dataArray.count inSection:0];
    if (dataArray.count==0) {
        [self.all_is_nomore_data_dict setObject:@(YES) forKey:categoryID];
    } else {
        [self.all_is_nomore_data_dict setObject:@(NO) forKey:categoryID];
        [array_frome_array addObjectsFromArray:dataArray];
    }
    return fin_indexps;
}

- (RACSignal *)siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                   isReload:(BOOL)isReload
                                                        url:(NSString *)url
                                                    dictKey:(NSString *)dictKey
                                              jsonClassName:(NSString *)jsonClassName
{
    return [self siganlForManyListViewRequestLoadMoreWithPara:para
                                                     isReload:isReload
                                                          url:url
                                                      dictKey:dictKey
                                                jsonClassName:jsonClassName
                                                  isNewMethod:NO];
}

- (RACSignal *)js_siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                   isReload:(BOOL)isReload
                                                        url:(NSString *)url
                                                    dictKey:(NSString *)dictKey
                                              jsonClassName:(NSString *)jsonClassName
{
    return [self siganlForManyListViewRequestLoadMoreWithPara:para
                                                     isReload:isReload
                                                          url:url
                                                      dictKey:dictKey
                                                jsonClassName:jsonClassName
                                                  isNewMethod:YES];
}

- (RACSignal *)siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                   isReload:(BOOL)isReload
                                                        url:(NSString *)url
                                                    dictKey:(NSString *)dictKey
                                              jsonClassName:(NSString *)jsonClassName
                                                isNewMethod:(BOOL)isNewMethod{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    YBLCategoryTreeModel *commentModel = self.all_title_data_array[self.currentFoundIndex];
    NSString *categoryID = commentModel.id;
    [[self siganlForManyListViewRequestLoadMoreWithPara:para
                                                    url:url
                                               isReload:isReload] subscribeNext:^(id  _Nullable x) {
        NSArray *separateKeyArray = [dictKey componentsSeparatedByString:@"/"];
        for (NSString *sepret_key in separateKeyArray) {
            x = x[sepret_key];
        }
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:NSClassFromString(jsonClassName) json:x];
        if (isNewMethod) {
            [subject sendNext:dataArray];
        }
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:dataArray categotyID:categoryID isReload:isReload];
        if (!isNewMethod) {
            [subject sendNext:fin_indexps];
        }
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    return subject;
}

@end

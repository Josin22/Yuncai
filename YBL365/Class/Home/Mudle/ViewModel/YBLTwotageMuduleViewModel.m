//
//  YBLTwotageMuduleViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTwotageMuduleViewModel.h"

@interface YBLTwotageMuduleViewModel()

@property (nonatomic, strong) NSMutableArray *singleItemData;

@end

@implementation YBLTwotageMuduleViewModel

- (NSMutableDictionary *)allModuleDataDict{
    
    if (!_allModuleDataDict) {
        _allModuleDataDict = [NSMutableDictionary dictionary];
    }
    return _allModuleDataDict;
}

- (NSMutableDictionary *)allModulePageDict{
    
    if (!_allModulePageDict) {
        _allModulePageDict = [NSMutableDictionary dictionary];
    }
    return _allModulePageDict;
}

- (NSMutableDictionary *)allModuleNoMoreDataDict{
    if (!_allModuleNoMoreDataDict) {
        _allModuleNoMoreDataDict = [NSMutableDictionary dictionary];
    }
    return _allModuleNoMoreDataDict;
}

- (RACSignal *)siganlForGoodListIdex:(NSInteger)index isReload:(BOOL)isReload{
    NSString *category_id = [self getCurrentModuleCategoryIDWithIndex:index];
    return [self siganlForGoodListIdex:index categoryID:category_id isReload:isReload];
}

- (RACSignal *)siganlForGoodListCategoryID:(NSString *)categoryID
                                userinfoID:(NSString *)userinfoID
                                searchText:(NSString *)searchText
                                orderField:(NSString *)orderField
                                  orderAsc:(NSString *)orderAsc
                                      page:(NSInteger)page{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"category_id"] = categoryID;
    para[@"userinfo_id"] = userinfoID;
    para[@"title"] = searchText;
    para[@"order_field"] = orderField;
    para[@"order_asc"] = orderAsc;
    para[@"page"] = @(page);
    para[@"per_page"] = @(page_size);
    
    self.isReqesuting = YES;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_products_products
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.isReqesuting = NO;
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   self.isReqesuting = NO;
                                   [subject sendError:error];
                               }];
    
    return  subject;

}


- (RACSignal *)siganlForGoodListIdex:(NSInteger)index categoryID:(NSString *)categoryID isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];

    /**
     *  Ascending===>>>升序
     *  Descending===>>>降序
     */
    NSInteger page = [self getCurrentPageWithIndex:index];
    if (isReload) {
        page = 0;
        [YBLLogLoadingView showInWindow];
    }
    page++;

    [[self siganlForGoodListCategoryID:categoryID
                           userinfoID:nil
                           searchText:nil
                           orderField:@"sale_order_count"
                             orderAsc:@"desc"
                                 page:page] subscribeNext:^(id x) {

        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:x[@"products"]];
        if (isReload) {
            [YBLLogLoadingView dismissInWindow];
            [self.allModuleDataDict removeObjectForKey:@(index)];
            [self.allModulePageDict removeObjectForKey:@(index)];
        }
        NSMutableArray *data = [self getSingleItemDataArrayWithIndex:index];
//        NSMutableArray *indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:data.count appendingCount:dataArray.count];
        NSMutableArray *indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:data.count appendingCount:dataArray.count inSection:0];
        if (dataArray.count==0) {
            [self.allModuleNoMoreDataDict setObject:@(YES) forKey:@(index)];
        } else {
            [self.allModuleNoMoreDataDict setObject:@(NO) forKey:@(index)];
            NSMutableArray *data = [self getSingleItemDataArrayWithIndex:index];
            if (!data) {
                [self.allModuleDataDict setObject:dataArray forKey:@(index)];
            } else {
                [data addObjectsFromArray:dataArray];
            }
        }
        [self.allModulePageDict setObject:@(page) forKey:@(index)];
        [subject sendNext:indexps];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
       [subject sendError:error];
    }];
    return  subject;
}

- (NSMutableArray *)getSingleItemDataArrayWithIndex:(NSInteger)index{
    
    return  self.allModuleDataDict[@(index)];
}

- (NSInteger)getCurrentPageWithIndex:(NSInteger)index{
    
    return [self.allModulePageDict[@(index)] integerValue];
}

- (NSString *)getCurrentModuleCategoryIDWithIndex:(NSInteger)index{
    
    YBLFloorsModel *model = self.moduleArray[index];
    return model.id;
}

@end

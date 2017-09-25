//
//  YBLGoodsManageViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsManageViewModel.h"

@implementation YBLGoodsManageViewModel
/*

- (NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
        [_titleArray addObject:@"全部"];
    }
    return _titleArray;
}
- (NSMutableDictionary *)allGoodListDict{
    if (!_allGoodListDict) {
        _allGoodListDict = [NSMutableDictionary dictionary];
    }
    return _allGoodListDict;
}

*/
- (RACSignal *)siganlForStoreWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (isReload) {
        [YBLLogLoadingView showInWindow];
    }
    self.isReqesuting = YES;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    YBLCategoryTreeModel *model = self.all_title_data_array[index];
    NSString *categoryID  = model.id;
    if (!self.all_page_data_dict[categoryID]||isReload) {
        [self.all_page_data_dict setObject:@(0) forKey:categoryID];
    }
    NSNumber *pageNumber = self.all_page_data_dict[categoryID];
    __block NSInteger page = pageNumber.integerValue;
    page++;
    para[@"page"] = @(page);
    para[@"per_page"] = @(page_size);
    NSString *new_url = [YBLMethodTools updateURL:url_products_goodlist(categoryID) versionWithSiganlNumber:2];
    [YBLRequstTools HTTPGetDataWithUrl:new_url
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {

                                 self.isReqesuting = NO;
                                 NSArray *purhcaseOrderDataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result[@"products"]];
                                 NSArray *categorisDataArray = result[@"categories"];
                                 NSMutableArray *new_categorisDataArray = @[].mutableCopy;
                                 for (NSArray *itemArray in categorisDataArray) {
                                     YBLCategoryTreeModel *treeModel = [YBLCategoryTreeModel new];
                                     treeModel.id = itemArray[0];
                                     treeModel.title = itemArray[1];;
                                     [new_categorisDataArray addObject:treeModel];
                                 }
                                 if (isReload ) {
                                     [YBLLogLoadingView dismissInWindow];
                                     //刷新删除旧数据
                                     [self.all_purchase_order_data_dict removeObjectForKey:categoryID];
                                 }
                                 NSMutableArray *array_frome_dict = self.all_purchase_order_data_dict[categoryID];
                                 /*jisuan indexpath*/
                                 NSMutableArray *final_array_frome_dict = self.all_purchase_order_data_dict[categoryID];
                                 NSInteger index_from = final_array_frome_dict.count;
//                                 NSMutableArray *fin_indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:index_from appendingCount:purhcaseOrderDataArray.count];
                                 NSMutableArray *fin_indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:index_from appendingCount:purhcaseOrderDataArray.count inSection:0];
                                 if (array_frome_dict.count==0) {
                                     //首次储存数据
                                     NSMutableArray *first_data_array = [NSMutableArray array];
                                     [first_data_array addObjectsFromArray:purhcaseOrderDataArray];
                                     [self.all_purchase_order_data_dict setObject:first_data_array forKey:categoryID];
                                     [self.all_is_nomore_data_dict setObject:@(YES) forKey:categoryID];
                                 } else {
                                     [self.all_is_nomore_data_dict setObject:@(NO) forKey:categoryID];
                                     //取储存数据
                                     NSMutableArray *get_array_frome_dict = self.all_purchase_order_data_dict[categoryID];
                                     [get_array_frome_dict addObjectsFromArray:purhcaseOrderDataArray];
                                 }
                                 if ([categoryID isEqualToString:@"0"]) {
                                     [self.all_title_data_array removeObjectsInRange:NSMakeRange(1, self.all_title_data_array.count-1)];
                                     [self.all_title_data_array addObjectsFromArray:new_categorisDataArray.copy];
                                 }
                                 [self.all_page_data_dict setObject:@(page) forKey:categoryID];
                                 [subject sendNext:fin_indexps];
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
/*
- (RACSignal *)GoodListSignal{

    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLLogLoadingView showInWindow];

    [YBLRequstTools HTTPGetDataWithUrl:url_products_goodlist(@"0")
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 [YBLLogLoadingView dismissInWindow];
//                                 [SVProgressHUD dismiss];
                                 NSInteger index = 0;
                                 NSMutableArray *allGoodListArray = [[NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:result[@"products"]] mutableCopy];
                                 [self.allGoodListDict setObject:allGoodListArray forKey:@(index)];
                                 
                                 for (YBLGoodModel *goodModel in allGoodListArray) {
                                     if (![self.titleArray containsObject:goodModel.category_title]) {
                                         [self.titleArray addObject:goodModel.category_title];
                                     }
                                 }
                                 NSInteger index_1 = 0;
                                 for (NSString *category_title in self.titleArray) {
                                     if (index_1!=0) {
                                         NSMutableArray *leveArray = [NSMutableArray array];
                                         for (YBLGoodModel *goodModel in allGoodListArray) {
                                             if ([goodModel.category_title isEqualToString:category_title]) {
                                                 [leveArray addObject:goodModel];
                                             }
                                         }
                                         [self.allGoodListDict setObject:leveArray forKey:@(index_1)];
                                     }
                                     index_1++;
                                 }

                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}
*/
+ (RACSignal *)siganlForChangeGoodStatusWithID:(NSString *)_id isOnline:(BOOL)isOnline{
    
    return [[self alloc] siganlForChangeGoodStatusWithId:_id status:isOnline==YES?@"online":@"offline"];
}

- (RACSignal *)siganlForOnlineGoodWithId:(NSString *)_id{
    
    return [self siganlForChangeGoodStatusWithId:_id status:@"online"];
}

- (RACSignal *)siganlForOfflineGoodWithId:(NSString *)_id{
    
    return [self siganlForChangeGoodStatusWithId:_id status:@"offline"];
}

+ (RACSignal *)siganlForDeleteGoodWithId:(NSString *)_id{
    return [[self alloc] siganlForDeleteGoodWithId:_id];
}

- (RACSignal *)siganlForDeleteGoodWithId:(NSString *)_id{
    return [self siganlForChangeGoodStatusWithId:_id status:@"trash"];
}

- (RACSignal *)siganlForChangeGoodStatusWithId:(NSString *)_id status:(NSString *)status{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"status"] = status;
    
    [YBLRequstTools HTTPPUTWithUrl:url_product_change_status(_id)
                           Parames:para
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

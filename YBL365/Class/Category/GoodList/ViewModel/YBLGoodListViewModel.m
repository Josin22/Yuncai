//
//  YBLGoodListViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodListViewModel.h"
#import "shop.h"

@interface YBLGoodListViewModel ()

@end

@implementation YBLGoodListViewModel

- (NSMutableArray *)searchDataArray{
    if (!_searchDataArray) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

- (RACSignal *)siganlForSearchGoodsAgain:(BOOL)isNewSearch{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    /**
     *  默认综合-->升序
     */
    NSString *orderField = @"sale_order_count";
    NSString *orderAsc = nil;
    switch (self.orderSequenceText) {
        case OrderSequenceTextComposite:
//            orderField = nil;
            break;
        case OrderSequenceTextSaleCount:
            orderField = @"sale_order_count";
            break;
        case OrderSequenceTextPrice:
            orderField = @"price";
            break;
            
        default:
            break;
    }
    switch (self.orderSequence) {
        case OrderSequenceDescending:
            orderAsc = @"desc";
            break;
        case OrderSequenceAscending:
            orderAsc = @"asc";
            break;
            
        default:
            break;
    }
    if (isNewSearch) {
        self.page_list = 0;
        [YBLLogLoadingView showInWindow];
    }
    self.page_list++;
    [[self siganlForGoodListCategoryID:self.category_id
                           userinfoID:self.userinfo_id
                           searchText:self.keyWord
                           orderField:orderField
                             orderAsc:orderAsc
                                 page:self.page_list] subscribeNext:^(id x) {
        NSArray *dataArray = [NSArray yy_modelArrayWithClass:[YBLGoodModel class] json:x[@"products"]];
        self.page_count = ceil([x[@"total_count"] integerValue]/page_size);
        if (isNewSearch) {
            [YBLLogLoadingView dismissInWindow];
            [self.searchDataArray removeAllObjects];
        }
        NSMutableArray *indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:self.searchDataArray.count appendingCount:dataArray.count inSection:0];
        if (dataArray.count!=0) {
            [self.searchDataArray addObjectsFromArray:dataArray];
            self.isNoMoreData = NO;
        } else {
            self.isNoMoreData = YES;
        }
        [subject sendNext:indexps];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        if (self.page_list>0) {
            self.page_list--;
        }
        [subject sendError:error];
    }];
    
    return subject;
}


@end

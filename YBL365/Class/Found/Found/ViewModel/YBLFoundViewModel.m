//
//  YBLFoundViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLGoodParameterView.h"
#import "YBLCategoryTreeModel.h"
#import "YBLGoodGridFlowLayout.h"

@interface YBLFoundViewModel ()

@end

@implementation YBLFoundViewModel

- (RACSignal *)signalForPurchaseDataCount{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchase_datacount
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 self.dataModel = [YBLPurchaseDataCountModel yy_modelWithJSON:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

- (RACSignal *)signalForAllPurchaseOrderWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    YBLCategoryTreeModel *commentModel = self.all_title_data_array[self.currentFoundIndex];
    NSString *categoryID = commentModel.id;
    NSString *new_url = url_purchasingorder_purchaseorders;
    if (self.area_id&&self.area_type) {
        new_url = [YBLMethodTools updateURL:new_url versionWithSiganlNumber:2];
        para[@"area_id"] = self.area_id;
        para[@"area_type"] = self.area_type;
    }
    para[@"type"] = @(1);
    para[@"category_id"] = categoryID;
    if (self.product_name) {
        para[@"product_name"] = self.product_name;
    }
    [[self siganlForManyListViewRequestLoadMoreWithPara:para
                                                    url:new_url
                                              isReload:isReload] subscribeNext:^(id  _Nullable x) {
    
        NSArray *purhcaseOrderDataArray = [NSArray yy_modelArrayWithClass:[YBLPurchaseOrderModel class] json:x[@"purchaseorder"]];
        for (YBLPurchaseOrderModel *itemModel in purhcaseOrderDataArray) {
            itemModel.text_font = YBLFont(14);
            itemModel.text_max_width = GridViewItemWidth-8;
            [itemModel calulateTextSize:itemModel.title];
            itemModel.text_height = itemModel.text_height>35?35:itemModel.text_height;
            [itemModel handleAttPrice];
        }
        NSArray *categorisDataArray = [NSArray yy_modelArrayWithClass:[YBLCategoryTreeModel class] json:x[@"categories"]];
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:purhcaseOrderDataArray categotyID:categoryID isReload:isReload];
        if ([categoryID isEqualToString:@"0"]) {
            [self.all_title_data_array removeObjectsInRange:NSMakeRange(1, self.all_title_data_array.count-1)];
            [self.all_title_data_array addObjectsFromArray:categorisDataArray];
        }
         
        //indexpath
        [subject sendNext:fin_indexps];
        [subject sendCompleted];
        /*
         if (isReload ) {
         //刷新删除旧数据
         [self.all_purchase_order_data_dict removeObjectForKey:categoryID];
         }
         
         NSMutableArray *array_frome_dict = self.all_purchase_order_data_dict[categoryID];
         NSInteger index_from = array_frome_dict.count;
         //        NSMutableArray *fin_indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:index_from appendingCount:purhcaseOrderDataArray.count];
         NSMutableArray *fin_indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:index_from appendingCount:purhcaseOrderDataArray.count inSection:0];
         
         if (purhcaseOrderDataArray.count==0) {
         [self.all_is_nomore_data_dict setObject:@(YES) forKey:categoryID];
         } else {
         [self.all_is_nomore_data_dict setObject:@(NO) forKey:categoryID];
         }
         if (array_frome_dict.count==0) {
         //首次储存数据
         NSMutableArray *first_data_array = [NSMutableArray array];
         [first_data_array addObjectsFromArray:purhcaseOrderDataArray];
         [self.all_purchase_order_data_dict setObject:first_data_array forKey:categoryID];
         } else {
         //取储存数据
         NSMutableArray *get_array_frome_dict = self.all_purchase_order_data_dict[categoryID];
         [get_array_frome_dict addObjectsFromArray:purhcaseOrderDataArray];
         }
         */
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    /*
    if (isReload) {
        [YBLLogLoadingView showInWindow];
    }
    YBLCategoryTreeModel *model = self.all_title_data_array[index];
    NSString *categoryID  = model.id;
    if (!self.all_page_data_dict[categoryID]||isReload) {
        [self.all_page_data_dict setObject:@(0) forKey:categoryID];
    }
    NSNumber *pageNumber = self.all_page_data_dict[categoryID];
    __block NSInteger page = pageNumber.integerValue;
    page++;
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (self.area_id&&self.area_type) {
        para[@"area_type"] = self.area_type;
        para[@"area_id"] = self.area_id;
    }
    [[self signalForAllPurchaseOrderRequestWithType:1
                                           paraDict:para
                                    purchaseOrderID:nil
                                         userinfoID:nil
                                         categoryID:model.id
                                               page:page
                                           isReload:isReload] subscribeNext:^(id  _Nullable x) {
        if (isReload) {
            [YBLLogLoadingView dismissInWindow];
        }
        NSArray *purhcaseOrderDataArray = [NSArray yy_modelArrayWithClass:[YBLPurchaseOrderModel class] json:x[@"purchaseorder"]];
        for (YBLPurchaseOrderModel *itemModel in purhcaseOrderDataArray) {
            itemModel.text_font = YBLFont(14);
            itemModel.text_max_width = GridViewItemWidth-8;
            [itemModel calulateTextSize:itemModel.title];
            itemModel.text_height = itemModel.text_height>35?35:itemModel.text_height;
            [itemModel handleAttPrice];
        }
        NSArray *categorisDataArray = [NSArray yy_modelArrayWithClass:[YBLCategoryTreeModel class] json:x[@"categories"]];
   
        if (isReload ) {
            //刷新删除旧数据
            [self.all_purchase_order_data_dict removeObjectForKey:categoryID];
        }
        NSMutableArray *array_frome_dict = self.all_purchase_order_data_dict[categoryID];
        NSInteger index_from = array_frome_dict.count;
//        NSMutableArray *fin_indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:index_from appendingCount:purhcaseOrderDataArray.count];
        NSMutableArray *fin_indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:index_from appendingCount:purhcaseOrderDataArray.count inSection:0];
        if (purhcaseOrderDataArray.count==0) {
            [self.all_is_nomore_data_dict setObject:@(YES) forKey:categoryID];
        } else {
            [self.all_is_nomore_data_dict setObject:@(NO) forKey:categoryID];
        }
        if (array_frome_dict.count==0) {
            //首次储存数据
            NSMutableArray *first_data_array = [NSMutableArray array];
            [first_data_array addObjectsFromArray:purhcaseOrderDataArray];
            [self.all_purchase_order_data_dict setObject:first_data_array forKey:categoryID];
        } else {
            //取储存数据
            NSMutableArray *get_array_frome_dict = self.all_purchase_order_data_dict[categoryID];
            [get_array_frome_dict addObjectsFromArray:purhcaseOrderDataArray];
        }
       
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:categorisDataArray categotyID:categoryID isReload:isReload];
        if ([categoryID isEqualToString:@"0"]) {
            [self.all_title_data_array removeObjectsInRange:NSMakeRange(1, self.all_title_data_array.count-1)];
            [self.all_title_data_array addObjectsFromArray:categorisDataArray];
        }
        [self.all_page_data_dict setObject:@(page) forKey:categoryID];
        //jisuan indexpath
        [subject sendNext:fin_indexps];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        if (page > 0) {
            page--;
        }
        [self.all_page_data_dict setObject:@(page) forKey:categoryID];
        [subject sendError:error];
    }];
      */
    return subject;
}

@end


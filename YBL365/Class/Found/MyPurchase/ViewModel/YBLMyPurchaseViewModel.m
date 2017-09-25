//
//  YBLMyPurchaseViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyPurchaseViewModel.h"
#import "YBLCategoryTreeModel.h"

@interface YBLMyPurchaseViewModel ()

{
    NSArray *_myppTitleArray;
    NSArray *_recordsTitleArray;
}

@end

@implementation YBLMyPurchaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //△▽Δ
        _myppTitleArray     = @[@[@"我的采购",     @"全部采购", @"待支付",  @"已中标", @"未中标",   @"已取消",  @"系统自选"],
                               @[@"purchaseing",  @"null"   ,    @"unpaid", @"bidded", @"no_bid", @"cancel", @"choice_but_unselected"]];
       
        _recordsTitleArray  = @[@[@"报价记录",@"采购中",      @"已中标",  @"未中标",    @"已取消",   @"系统自选"],
                               @[@"null",   @"purchaseing", @"bidded", @"no_bid",  @"cancel",  @"choice_but_unselected"]];
        //默认
        self.seg1Value = @"purchaseing";
        
        if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
            self.titleArray = @[@[@"我的采购△",@"报价记录△"],
                                @[@"4",@"5"],];
        } else {
            self.titleArray = @[@[@"我的采购△"],
                                @[@"4"],];
        }
        [self hanldeTitleData];
    }
    return self;
}

- (NSArray *)segTitleDataArray{
    if (!_segTitleDataArray) {
        _segTitleDataArray = @[_myppTitleArray,_recordsTitleArray];
    }
    return _segTitleDataArray;
}

- (NSArray *)getCurrentTitleWithIndex:(NSInteger)index{
    NSArray *currentTitleArray = self.segTitleDataArray[index];
    NSArray *showTitleArray = currentTitleArray[0];
    return showTitleArray;
}

- (void)handleSegValueWithIndex:(NSInteger)index selectIndex:(NSInteger)selectIndex{
    NSArray *currentTitleArray = self.segTitleDataArray[index];
    NSArray *showParaArray = currentTitleArray[1];
    NSString *segvv = showParaArray[selectIndex];
    if (index == 0) {
        self.seg1Value = segvv;
    } else {
        self.seg2Value = segvv;
    }
}

//- (RACSignal *)siganlForPersonPurchaseOrderIsReload:(BOOL)isReload{
//    return [self siganlForPersonPurchaseOrderWithStatus:nil isReload:isReload];
//}

- (RACSignal *)siganlForPersonPurchaseOrderIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    YBLCategoryTreeModel *commentModel = self.all_title_data_array[self.currentFoundIndex];
    NSString *categotyID = commentModel.id;
    para[@"type"] = commentModel.para_value;
    if (self.currentFoundIndex==0&&![self.seg1Value isEqualToString:@"null"]) {
        para[@"status"] = self.seg1Value;
    } else if(![self.seg2Value isEqualToString:@"null"]){
        para[@"status"] = self.seg2Value;
    }
    [[self siganlForManyListViewRequestLoadMoreWithPara:para
                                                   url:url_purchasingorder_purchaseorders
                                              isReload:isReload] subscribeNext:^(id  _Nullable x) {
        NSArray *purhcaseOrderDataArray = [NSArray yy_modelArrayWithClass:[YBLPurchaseOrderModel class] json:x[@"purchaseorder"]];
        /**
         *  dynic
         */
        for (YBLPurchaseOrderModel *toll_model in purhcaseOrderDataArray) {
            toll_model.myPurchaseType = self.currentFoundIndex;
            
            [self reSetPurchaseDetailModel:toll_model];
            
            [self handleModel:toll_model];
        }
        NSMutableArray *fin_indexps = [self getNewIndexpathWithDataArray:purhcaseOrderDataArray categotyID:categotyID isReload:isReload];
        [subject sendNext:fin_indexps];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

/*
- (NSMutableDictionary *)personal_page_data_dict{
    if (!_personal_page_data_dict) {
        _personal_page_data_dict = [NSMutableDictionary dictionary];
    }
    return _personal_page_data_dict;
}


- (NSMutableDictionary *)personalPurchaseOrderDict{
    if (!_personalPurchaseOrderDict) {
        _personalPurchaseOrderDict = [NSMutableDictionary dictionary];
    }
    return _personalPurchaseOrderDict;
}

- (NSMutableDictionary *)personal_nomore_data_dict{
    
    if (!_personal_nomore_data_dict) {
        _personal_nomore_data_dict = [NSMutableDictionary dictionary];
    }
    return _personal_nomore_data_dict;
}

- (RACSignal *)signalForPersonalPurchaseOrderWithIndex:(NSInteger)index isReload:(BOOL)isReload isAllRecords:(BOOL)isAllRecords{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    ///4我的采购   or   5报价记录 //3所有采购记录
    NSInteger type = (index+4);
    NSInteger index_new = index;
    if (isAllRecords) {
        type = 3;
        index_new = 0;
    }
    if (!self.personal_page_data_dict[@(index_new)]||isReload) {
        [self.personal_page_data_dict setObject:@(0) forKey:@(index_new)];
    }
    if (isReload) {
        [YBLLogLoadingView showInWindow];
    }
    NSNumber *pageNumber = self.personal_page_data_dict[@(index_new)];
    NSInteger page = pageNumber.integerValue;
    page++;
    [[self signalForAllPurchaseOrderRequestWithType:type
                                           paraDict:nil
                                   purchaseOrderID:nil
                                        userinfoID:nil
                                        categoryID:nil
                                              page:page
                                          isReload:isReload] subscribeNext:^(id  _Nullable x) {
        NSArray *purhcaseOrderDataArray = [NSArray yy_modelArrayWithClass:[YBLPurchaseOrderModel class] json:x[@"purchaseorder"]];
//        NSArray *categorisDataArray = [NSArray yy_modelArrayWithClass:[YBLCategoryTreeModel class] json:x[@"categories"]];
        if (isReload ) {
            [YBLLogLoadingView dismissInWindow];
            //刷新删除旧数据
            [self.personalPurchaseOrderDict removeObjectForKey:@(index)];
        }
        if (purhcaseOrderDataArray.count==0) {
            [self.personal_nomore_data_dict setObject:@(YES) forKey:@(index)];
        } else {
            [self.personal_nomore_data_dict setObject:@(NO) forKey:@(index)];
        }
        for (YBLPurchaseOrderModel *toll_model in purhcaseOrderDataArray) {
            if (isAllRecords) {
                toll_model.myPurchaseType = MyPurchaseTypePurchaseAllRecords;
            } else {
                toll_model.myPurchaseType = index;
            }
            [self reSetPurchaseDetailModel:toll_model];
            
            toll_model.text_font = YBLFont(14);
            toll_model.text_max_width = YBLWindowWidth-100-space*2;
            [toll_model calulateTextSize:toll_model.title];
            [toll_model handleAttText];
            [toll_model handleAttPrice];

        }
        NSMutableArray *get_personal_data_array = self.personalPurchaseOrderDict[@(index)];
//        NSMutableArray *indexps = [YBLMethodTools getNewAppendingIndexPathsWithIndex:get_personal_data_array.count appendingCount:purhcaseOrderDataArray.count];
        NSMutableArray *indexps = [YBLMethodTools getRowAppendingIndexPathsWithIndex:get_personal_data_array.count appendingCount:purhcaseOrderDataArray.count inSection:0];
        if (get_personal_data_array.count==0) {
            NSMutableArray *first_data_array = [NSMutableArray array];
            [first_data_array addObjectsFromArray:purhcaseOrderDataArray];
            [self.personalPurchaseOrderDict setObject:first_data_array forKey:@(index)];
        } else {
            NSMutableArray *get_array_frome_dict = self.personalPurchaseOrderDict[@(index)];
            [get_array_frome_dict addObjectsFromArray:purhcaseOrderDataArray];
        }
        [self.personal_page_data_dict setObject:@(page) forKey:@(index)];
        [subject sendNext:indexps];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [self.personal_page_data_dict setObject:@(page) forKey:@(index)];
        [subject sendError:error];
    }];
    
    return subject;
}
*/
@end

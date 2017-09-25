//
//  YBLBaseFoundViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseFoundViewModel.h"

@implementation YBLBaseFoundViewModel

- (void)handleModel:(YBLPurchaseOrderModel *)toll_model
{
    toll_model.text_font = YBLFont(14);
    toll_model.text_max_width = YBLWindowWidth-100-space*2;
    [toll_model calulateTextSize:toll_model.title];
    [toll_model handleAttText];
    [toll_model handleAttPrice];
}

- (void)reSetPurchaseDetailModel:(YBLPurchaseOrderModel *)purchaseDetailModel{
    //处理订单状态
    //    PurchaseOrderType type = [YBLMethodTools getPurchaseOrderTypeWithAasmState:_purchaseDetailModel.aasm_state];
    //    NSString *title = [YBLMethodTools getPurchaseOrderStatusTitleWithAasmState:_purchaseDetailModel.aasm_state];
    //    UIColor *bgColor = [YBLMethodTools getPurchaseOrderStatusBGColorWithAasmState:_purchaseDetailModel.aasm_state];
    //    [_purchaseDetailModel setValue:@(type) forKey:@"purchaseOrderType"];
    //    [_purchaseDetailModel setValue:title forKey:@"purchaseOrderStatues"];
    //    [_purchaseDetailModel setValue:bgColor forKey:@"purchaseOrderStatuesBGColor"];
    NSString *myselfid = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
    if ([myselfid isEqualToString:purchaseDetailModel.userinfo_id]) {
        [purchaseDetailModel setValue:@YES forKey:@"isMyselfPurchaseOrder"];
    } else {
        [purchaseDetailModel setValue:@NO forKey:@"isMyselfPurchaseOrder"];
    }
    //处理数据
    NSMutableArray *payshippingDataArray = [NSMutableArray array];
    
    NSString *payTitle = @"";
    if (purchaseDetailModel.purchase_pay_types.count!=0) {
        payTitle = [YBLMethodTools getAppendingTitleStringWithArray:purchaseDetailModel.purchase_pay_types appendingKey:@" "];
    } else {
        payTitle = [YBLMethodTools getAppendingTitleStringWithArray:@[purchaseDetailModel.pay_type] appendingKey:@" "];
    }
    [payshippingDataArray addObject:payTitle];
    
    if (purchaseDetailModel.purchase_distributions.count!=0) {
        for (YBLPurchaseInfosModel *distributionModel in purchaseDetailModel.purchase_distributions) {
            NSString *distributionTitle=distributionTitle = [YBLMethodTools getAppendingTitleStringWithArray:@[distributionModel] appendingKey:@" "];
            [payshippingDataArray addObject:distributionTitle];
        }
    } else {
        NSString *distributionTitle = [YBLMethodTools getAppendingTitleStringWithArray:@[purchaseDetailModel.distributions ] appendingKey:@" "];
        [payshippingDataArray addObject:distributionTitle];
    }
    
    [purchaseDetailModel setValue:payshippingDataArray forKey:@"all_pay_ship_ment_titles"];
    
}

- (RACSignal *)siganlForPurchaseOrderRequestWithType:(NSInteger)type
                                          categoryID:(NSString *)categoryID
                                          productName:(NSString *)productName
                                              status:(NSString *)status{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    
    
    
    return subject;
}

- (RACSignal *)signalForAllPurchaseOrderRequestWithType:(NSInteger)type
                                               paraDict:(NSMutableDictionary *)paraDict
                                        purchaseOrderID:(NSString *)purchaseOrderID
                                             userinfoID:(NSString *)userinfoID
                                             categoryID:(NSString *)categoryID
                                                   page:(NSInteger)page
                                               isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    if (!paraDict) {
        paraDict = [NSMutableDictionary dictionary];
    }
    NSString *url_string = nil;
    __block NSInteger new_page = page;
    url_string = url_purchasingorder_purchaseorders;
    
    paraDict[@"page"] = @(new_page);
    paraDict[@"category_id"] = categoryID;

    self.isReqesuting = YES;
    if (paraDict[@"area_type"]&&paraDict[@"area_id"]) {
        url_string = [YBLMethodTools updateURL:url_string versionWithSiganlNumber:2];
    } else {
        paraDict[@"type"] = @(type);
    }
    [YBLRequstTools HTTPGetDataWithUrl:url_string
                               Parames:paraDict
                             commplete:^(id result, NSInteger statusCode) {
                                 self.isReqesuting = NO;
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   self.isReqesuting = NO;
                                   [subject sendError:error];
                               }];
    
    return subject;
}



- (RACSignal *)signalForSearchBiddingsWithOrderID:(NSString *)orderID
                                            bidID:(NSString *)bidID
                                       isCheapest:(BOOL)isCheapest
                                             page:(NSInteger)page
                                         pageSize:(NSInteger)pageSize
                                         isReload:(BOOL)isReload{
    
    RACReplaySubject *subejct = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *url = url_purchasingorder_biddings;
    if (bidID) {
        para[@"bidid"] = bidID;
        url = url_purchasingorder_bidding;
    } else {
        para[@"orderid"] = orderID;
        para[@"cheapest"] = @(isCheapest);
    }
    para[@"page"] = @(page);
    para[@"per_page"] = @(pageSize);
    
    [YBLRequstTools HTTPGetDataWithUrl:url
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 [subejct sendNext:result];
                                 [subejct sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subejct sendError:error];
                               }];
    
    return subejct;
}

@end

//
//  YBLPurchaseGoodDetailViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseGoodDetailViewModel.h"
#import "YBLGoodParameterView.h"

@implementation YBLPurchaseGoodDetailViewModel

- (NSMutableArray *)cellArray{
    
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
        [_cellArray addObject:@[@{cell_identity_key:@"YBLOrderMMGoodsDetailInfoCell"},@{cell_identity_key:@"YBLOrderMMGoodsDetailOtherInfoCell"}]];
        //        [_cellArray addObject:@[@{cell_identity_key:@"YBLOrderMMGoodsDetailOutPriceRecordsCell"}]];
        [_cellArray addObject:@[@{cell_identity_key:@"YBLOrderMMGoodsDetailMiningSupplyProcessCell"}]];
        [_cellArray addObject:@[@{cell_identity_key:@"YBLOrderMMGoodsDetailAddressCell"}]];
        //        [_cellArray addObject:@[@{cell_identity_key:@"YBLGoodsHotListCell"}]];
        //        [_cellArray addObject:@[@{cell_identity_key:@"YBLOrderMMGoodsDetailPicsCell"}]];
        
    }
    return _cellArray;
}

- (NSMutableArray *)paraDataArray{
    
    if (!_paraDataArray) {
        _paraDataArray = [NSMutableArray array];
        
        float price_item = self.purchaseDetailModel.price.doubleValue*self.purchaseDetailModel.quantity.integerValue;
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"商品总价 :" value:[NSString stringWithFormat:@"¥ %.2f",price_item]]];
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"采购数量 :" value:[NSString stringWithFormat:@"%d%@",self.purchaseDetailModel.quantity.intValue,self.purchaseDetailModel.unit]]];
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"商品条码 :" value:[NSString stringWithFormat:@"%@",self.purchaseDetailModel.qrcode]]];
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"商品规格 :" value:[NSString stringWithFormat:@"%@",self.purchaseDetailModel.specification]]];
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"销售效期 :" value:[NSString stringWithFormat:@"%@",self.purchaseDetailModel.sellshelflifes_title]]];
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"包装单位 :" value:[NSString stringWithFormat:@"%@",self.purchaseDetailModel.unit]]];
        [_paraDataArray addObject:[GoodParaModel getModelWithTitle:@"采购地区 :" value:[NSString stringWithFormat:@"%@ %@ %@",self.purchaseDetailModel.address_info.province_name,self.purchaseDetailModel.address_info.city_name,self.purchaseDetailModel.address_info.county_name]]];
    }
    return _paraDataArray;
}

- (RACSignal *)signalForSinglePurchaseOrderDetail{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    //单个采购订单
    para[@"id"] = self.purchaseDetailModel._id;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_purchasingorder_purchaseorder
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 self.purchaseDetailModel = [YBLPurchaseOrderModel yy_modelWithJSON:result[@"purchaseorder"]];
                                 [self reSetPurchaseDetailModel:self.purchaseDetailModel];
                                 [self handleModel:self.purchaseDetailModel];
                                 self.isPurchaseDetailRequestDone = YES;
                                 [subject sendCompleted];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    /*
    [[self signalForAllPurchaseOrderRequestWithType:2
                                           paraDict:nil
                                   purchaseOrderID:self.purchaseDetailModel._id
                                        userinfoID:nil
                                        categoryID:nil
                                              page:0
                                          isReload:YES] subscribeNext:^(id  _Nullable x) {
        
        self.purchaseDetailModel = [YBLPurchaseOrderModel yy_modelWithJSON:x[@"purchaseorder"]];
        [self reSetPurchaseDetailModel:self.purchaseDetailModel];
        self.isPurchaseDetailRequestDone = YES;
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    */
    return subject;
}

@end

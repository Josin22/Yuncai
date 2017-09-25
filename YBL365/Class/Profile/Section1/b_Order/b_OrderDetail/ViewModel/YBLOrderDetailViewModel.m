//
//  YBLOrderDetailViewModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailViewModel.h"

@implementation YBLOrderDetailViewModel

- (RACSignal *)OrderDetailSignal{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [YBLRequstTools HTTPGetDataWithUrl:url_orders_detail(self.itemDetailModel.order_id)
                               Parames:nil
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 YBLOrderItemModel *itemModel = [YBLOrderItemModel yy_modelWithJSON:result];

                                 //处理模型
                                 [self handleRequestDataModel:itemModel isDetail:YES];
                                 
                                 self.itemDetailModel = itemModel;
                                 
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}


- (void)setItemDetailModel:(YBLOrderItemModel *)itemDetailModel{
    _itemDetailModel = itemDetailModel;
    
    ///处理数据
    self.oderDetailCellArray = [NSMutableArray array];
    /**
     *  订单号 查看物流
     */
    [self.oderDetailCellArray addObject:@{cell_identity_key:@[@"YBLOrderDetailNoStatusCell",
                                                              @"YBLOrderDetailDeliverCell"]}];
    /**
     *  地址
     */
    [self.oderDetailCellArray addObject:@{cell_identity_key:@[@"YBLOrderDetailAddressCell"],
                                          cell_data_identity_key:self.itemDetailModel.auto_address}];
    /**
     *  商品
     */
    NSMutableArray *cellArray1 = [NSMutableArray array];
    NSMutableArray *cellDataArray = [NSMutableArray array];
    if (itemDetailModel.line_items.count==0) {
        [cellArray1 addObject:@"YBLOrderGoodCell"];
        [cellDataArray addObject:itemDetailModel.purchase_order];
    } else {
        for (lineitems *itemModel in itemDetailModel.line_items) {
            [cellArray1 addObject:@"YBLOrderGoodCell"];
        }
        cellDataArray = [itemDetailModel.line_items mutableCopy];
    }
    [self.oderDetailCellArray addObject:@{header_identity_key:@"YBLOrderDetailStoreHeaderView",
                                          footer_identity_key:@"YBLOrderDetailContactFooterView",
                                          cell_identity_key:cellArray1,
                                          cell_data_identity_key:cellDataArray}];
    /**
     *  其他信息
     */
    NSArray *titleArray = @[@"支付方式",@"配送信息",@"票据信息",@"留言"];
    NSString *piaoString = @"不开票据";
    NSString *masg = _itemDetailModel.message==nil?@"暂无留言":_itemDetailModel.message;
    if (_itemDetailModel.invoice) {
        piaoString = [NSString stringWithFormat:@"%@",_itemDetailModel.invoice.title];
    }
    NSArray *valueArray = @[_itemDetailModel.payment_method.name,_itemDetailModel.shipping_method.name,piaoString,masg];
    [self.oderDetailCellArray addObject:@{cell_identity_key:@[@"YBLOrderDetailTextCell",
                                                              @"YBLOrderDetailTextCell",
                                                              @"YBLOrderDetailTextCell",
                                                              @"YBLOrderDetailTextCell"],
                                     cell_data_identity_key:@[titleArray,valueArray]}];
    /**
     *  商品总额
     */
    [self.oderDetailCellArray addObject:@{cell_identity_key:@[@"YBLOrderDetailTotalMoenyCell"]}];
    /**
     *  应付款
     */
    [self.oderDetailCellArray addObject:@{cell_identity_key:@[@"YBLOrderDetailPayMoneyCell"]}];
    
}

@end

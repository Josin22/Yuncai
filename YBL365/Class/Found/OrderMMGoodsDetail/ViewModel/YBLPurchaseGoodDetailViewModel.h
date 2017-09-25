//
//  YBLPurchaseGoodDetailViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseFoundViewModel.h"

@interface YBLPurchaseGoodDetailViewModel : YBLBaseFoundViewModel

//------------------------------------单个采购
///
@property (nonatomic, strong) YBLPurchaseOrderModel *purchaseDetailModel;
///
@property (nonatomic, assign) PurchaseDetailPushType purchaseDetailPushType;
///
@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) NSMutableArray *paraDataArray;

@property (nonatomic, assign) BOOL isPurchaseDetailRequestDone;

///
- (RACSignal *)signalForSinglePurchaseOrderDetail;

@end

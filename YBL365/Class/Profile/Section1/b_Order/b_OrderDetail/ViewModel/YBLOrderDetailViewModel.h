//
//  YBLOrderDetailViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLOrderItemModel.h"
#import "YBLOrderViewModel.h"

typedef void(^OrderDetailChanegOrderStateBlock)(YBLOrderItemModel *changeOrderModel);

@interface YBLOrderDetailViewModel : YBLOrderViewModel
/**
 *  订单详情改变block
 */
@property (nonatomic, copy  ) OrderDetailChanegOrderStateBlock orderStateBlock;

@property (nonatomic, assign) BOOL isShowAllGood;

@property (nonatomic, strong) RACSignal *OrderDetailSignal;

@property (nonatomic, strong) NSMutableArray *oderDetailCellArray;

@property (nonatomic, strong) YBLOrderItemModel *itemDetailModel;

@end

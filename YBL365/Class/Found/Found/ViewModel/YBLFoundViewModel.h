//
//  YBLFoundViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPurchaseDataCountModel.h"
#import "YBLBaseFoundViewModel.h"

@interface YBLFoundViewModel : YBLBaseFoundViewModel
//------------------------------------所有

@property (nonatomic, strong) YBLPurchaseDataCountModel *dataModel;

@property (nonatomic, copy  ) NSString *area_type;

@property (nonatomic, copy  ) NSString *area_id;

@property (nonatomic, copy  ) NSString *product_name;

///全部采购订单
- (RACSignal *)signalForAllPurchaseOrderWithIndex:(NSInteger)index isReload:(BOOL)isReload;
///
- (RACSignal *)signalForPurchaseDataCount;

@end

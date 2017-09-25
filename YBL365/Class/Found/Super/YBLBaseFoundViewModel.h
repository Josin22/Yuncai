//
//  YBLBaseFoundViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPurchaseOrderModel.h"
#import "YBLPerPageBaseViewModel.h"

@interface YBLBaseFoundViewModel : YBLPerPageBaseViewModel

- (void)handleModel:(YBLPurchaseOrderModel *)toll_model;

- (void)reSetPurchaseDetailModel:(YBLPurchaseOrderModel *)purchaseDetailModel;

- (RACSignal *)signalForAllPurchaseOrderRequestWithType:(NSInteger)type
                                               paraDict:(NSMutableDictionary *)paraDict
                                        purchaseOrderID:(NSString *)purchaseOrderID
                                             userinfoID:(NSString *)userinfoID
                                             categoryID:(NSString *)categoryID
                                                   page:(NSInteger)page
                                               isReload:(BOOL)isReload;

- (RACSignal *)signalForSearchBiddingsWithOrderID:(NSString *)orderID
                                            bidID:(NSString *)bidID
                                       isCheapest:(BOOL)isCheapest
                                             page:(NSInteger)page
                                         pageSize:(NSInteger)pageSize
                                         isReload:(BOOL)isReload;

@end

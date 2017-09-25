//
//  YBLWMarketViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

@interface YBLWMarketViewModel : YBLPerPageBaseViewModel

@property (nonatomic, assign) NSInteger totalCount;

- (RACSignal *)siganlForWMarketGoodWithProductIDs:(NSMutableArray *)product_ids;

- (RACSignal *)siganlForWMarketGoodIsReload:(BOOL)isReload;

- (RACSignal *)signalForDeleteWmarketGoodWithID:(NSString *)Mid index:(NSInteger)index;

+ (RACSignal *)siganlForWmarketGoodID:(NSString *)goodID;

@end

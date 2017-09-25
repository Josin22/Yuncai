//
//  YBLCreditsPayViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLCreditPayModel.h"
#import "YBLCreditOrderModel.h"

@interface YBLCreditsPayViewModel : NSObject

@property (nonatomic, assign) BOOL isPaying;

@property (nonatomic, assign) BOOL isSearchPayResult;

@property (nonatomic, assign) TakeOrderType takeOrderType;

@property (nonatomic, strong) YBLCreditPayModel *payModel;

@property (nonatomic, strong) YBLCreditOrderModel *payOrderModel;

- (RACSignal *)signalForPayCreditsWithPayModel:(NSInteger)index;

- (RACSignal *)signalForCheckPayResult;

@end

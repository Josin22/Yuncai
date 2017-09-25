//
//  YBLMineMillionMessageViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"
#import "YBLMillionMessageTableView.h"

typedef void(^MillionMessageSelectBlock)(NSMutableArray *selectAray);

@interface YBLMineMillionMessageViewModel : YBLPerPageBaseViewModel

@property (nonatomic, strong) NSMutableArray *selectCustomerArray;

@property (nonatomic, copy  ) MillionMessageSelectBlock selectBlock;

@property (nonatomic, assign) MillionType millionType;

@property (nonatomic, copy  ) NSString *genre;

@property (nonatomic, copy  ) NSString *city;

- (RACSignal *)signalForMillionCoustomersIsReload:(BOOL)isReload;

- (RACSignal *)signalForMillionCustomersId:(NSString *)customerId isFoucs:(BOOL)isFoucs;

- (NSInteger)caculateSelectCount;

- (NSMutableArray *)getSelectCustomerArray;

@end

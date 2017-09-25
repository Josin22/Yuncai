//
//  YBLMyWalletsViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"
@class YBLWalletsRecordModel;

@interface YBLMyWalletsViewModel : YBLPerPageBaseViewModel

@property (nonatomic, strong) YBLWalletsRecordModel *walletsModel;

@property (nonatomic, strong) NSNumber       *gold;
@property (nonatomic, strong) NSNumber       *frozen_gold;
@property (nonatomic, strong) NSMutableArray *walletflows;

- (RACSignal *)siganlForWallets;

- (RACSignal *)siganlForWalletsIsReload:(BOOL)isReload;

@end

//
//  YBLRechargeWalletsViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLRechargeWalletsModel.h"
#import "YBLCreditsPayViewModel.h"

@interface YBLRechargeWalletsViewModel : YBLCreditsPayViewModel

@property (nonatomic, strong) NSMutableArray *rechargeDataArray;

@property (nonatomic, strong) RACSignal *rechargeWalletsSignal;

@end

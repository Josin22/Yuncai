//
//  YBLProductShareViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

typedef NS_ENUM(NSInteger,RewardType) {
    RewardTypeManage = 0,
    RewardTypeShare
};

@interface YBLProductShareViewModel : YBLPerPageBaseViewModel

@property (nonatomic, assign) RewardType rewardType;

- (RACSignal *)singalForShareMoenyIsReload:(BOOL)isReload;

@end

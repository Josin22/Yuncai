//
//  YBLRewardViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLProductShareViewModel.h"

@interface YBLRewardViewModel : YBLProductShareViewModel

+ (RACSignal *)singalForAddShareCountWithRewardID:(NSString *)rewardID;

- (RACSignal *)singalForAddShareCountWithRewardID:(NSString *)rewardID;

@end

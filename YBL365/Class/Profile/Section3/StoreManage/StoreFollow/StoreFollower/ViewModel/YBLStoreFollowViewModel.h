//
//  YBLStoreFollowViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

typedef NS_ENUM(NSInteger, FollowType) {
    FollowTypeStore = 0,
    FollowTypeShares
};

@interface YBLStoreFollowViewModel : YBLPerPageBaseViewModel

@property (nonatomic, assign) FollowType followType;

@property (nonatomic, copy  ) NSString *rewardID;

- (RACSignal *)siganlForFollowPayMoneyWith:(NSString *)follow_id;

- (RACSignal *)signalForFollowGoodsIsReload:(BOOL)isReload;

@end

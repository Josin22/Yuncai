//
//  YBLCouponsCenterViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCouponsCenterViewModel : NSObject

- (RACSignal *)singalForCounponsCenterIsReload:(BOOL)isReload;

+ (RACSignal *)siganlForTakeCouponsWithID:(NSString *)couponsID;

- (RACSignal *)siganlForTakeCouponsWithID:(NSString *)couponsID;

@end

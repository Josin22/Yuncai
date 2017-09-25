//
//  YBLCouponsCenterViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsCenterViewModel.h"
#import "NSObject+LoadMoreService.h"
#import "YBLCouponsModel.h"

@implementation YBLCouponsCenterViewModel

- (RACSignal *)singalForCounponsCenterIsReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"state"] = @"running";
    
    [[self js_singalForSingleRequestWithURL:url_couponss
                                      para:para
                                keyOfArray:@"coupons"
                     classNameOfModelArray:@"YBLCouponsModel"
                                  isReload:isReload] subscribeNext:^(id  _Nullable x) {
        
        for (YBLCouponsModel *model in x) {
            NSString *value_string = [NSString stringWithFormat:@"%.1f",model.value.doubleValue];
            model.js_value = value_string;
            CGFloat width_value = [value_string heightWithFont:YBLBFont(25) MaxWidth:100].width;
            model.js_value_width = @(width_value);

            NSString *condition_string = [NSString stringWithFormat:@"满%.0f可用",model.condition.doubleValue];
            model.js_condition = condition_string;
            CGFloat width_condition = [condition_string heightWithFont:YBLFont(12) MaxWidth:100].width;
            model.js_condition_width = @(width_condition);
            if (model.quantity.doubleValue==0) {
                model.quantity = @(1);
            }
            model.js_progress_percent = @((model.total.doubleValue-model.quantity.doubleValue)/model.quantity.doubleValue);
            if (model.binded.boolValue) {
                model.couponsState = CouponsCenterStateUsed;
            } else if (model.js_progress_percent.floatValue==1.0){
                model.couponsState = CouponsCenterStateOut;
            } else {
                model.couponsState = CouponsCenterStateNormal;
            }
        }
        [subject sendNext:x];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    } completed:^{
        [subject sendCompleted];
    }];
    
    return subject;
}


+ (RACSignal *)siganlForTakeCouponsWithID:(NSString *)couponsID{
    
    return [[self alloc] siganlForTakeCouponsWithID:couponsID];
}

- (RACSignal *)siganlForTakeCouponsWithID:(NSString *)couponsID{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"领取中..."];
    
    [[JSRequestTools js_postURL:url_couponss_take(couponsID) para:nil] subscribeNext:^(id  _Nullable x) {
        [SVProgressHUD dismiss];
        [subject sendNext:x];
        [subject sendCompleted];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}


@end

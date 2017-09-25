//
//  YBLCouponsManageViewModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsManageViewModel.h"
#import "YBLCouponsModel.h"

@interface YBLCouponsManageViewModel ()
{
    NSArray *_paraArray;
}

@end

@implementation YBLCouponsManageViewModel

- (instancetype)init
{
    return [self initWithCouponsListType:CouponsListTypeAdminMine];
}

- (instancetype)initWithCouponsListType:(CouponsListType)couponsListType
{
    self = [super init];
    if (self) {
        
        _couponsListType = couponsListType;
        
        NSArray *titles = @[@"发行中",@"已过期"];
        _paraArray = @[@"running",@"ended"];
        if (_couponsListType == CouponsListTypeCustomerMine) {
            titles = @[@"未使用",@"使用记录",@"已过期"];
            _paraArray = @[@"unused",@"used",@"expired"];
        } else if (_couponsListType == CouponsListTypeGoodDetail){
            _paraArray = @[@"running"];
        }
        
        self.titleArray = @[titles];
        
        [self hanldeTitleData];
    }
    return self;
}

- (RACSignal *)siganlForCouponsIsReload:(BOOL)isReload{
    return [self siganlForCouponsWithProductID:nil isReload:isReload];
}

- (RACSignal *)siganlForCouponsWithProductID:(NSString *)productID isReload:(BOOL)isReload{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *paraString = _paraArray[self.currentFoundIndex];
    para[@"state"] = paraString;
    
    NSString *url = url_coupons;
    NSString *key = @"coupons";
    if (_couponsListType == CouponsListTypeCustomerMine) {
        url = url_couponss_mine;
        key = @"userinfo_coupons";
    } else if (_couponsListType == CouponsListTypeGoodDetail){
        url = url_couponss;
    }
    
    if (productID) {
        para[@"product_id"] = productID;
    }
    
    [[self js_siganlForManyListViewRequestLoadMoreWithPara:para
                                                 isReload:isReload
                                                      url:url
                                                  dictKey:key
                                            jsonClassName:@"YBLCouponsModel"] subscribeNext:^(id  _Nullable x) {
        for (YBLCouponsModel *model in x) {
            model.js_full_time = [NSString stringWithFormat:@"%@-%@",model.start_time,model.end_time];
            NSString *value = [NSString stringWithFormat:@"%.0f",model.value.doubleValue];
            NSString *all_string = [NSString stringWithFormat:@"¥ %@",value];
            NSRange range = [all_string rangeOfString:value];
            NSMutableAttributedString *att_string = [[NSMutableAttributedString alloc] initWithString:all_string];
            [att_string addAttributes:@{NSFontAttributeName:YBLBFont(28)} range:NSMakeRange(range.location, range.length)];
            model.js_att_value = att_string;
            model.js_condition = [NSString stringWithFormat:@"满%.0f可用",model.condition.doubleValue];
        }
        [subject sendNext:x];
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    } completed:^{
        [subject sendCompleted];
    }];
    
    return subject;
}

@end

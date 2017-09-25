//
//  YBLCouponsManageViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLPerPageBaseViewModel.h"

typedef NS_ENUM(NSInteger,CouponsListType) {
    CouponsListTypeAdminMine = 0,
    CouponsListTypeCustomerMine,
    CouponsListTypeGoodDetail
};

@interface YBLCouponsManageViewModel : YBLPerPageBaseViewModel

@property (nonatomic, assign) CouponsListType couponsListType;

- (instancetype)initWithCouponsListType:(CouponsListType)couponsListType;

- (RACSignal *)siganlForCouponsIsReload:(BOOL)isReload;

- (RACSignal *)siganlForCouponsWithProductID:(NSString *)productID isReload:(BOOL)isReload;

@end

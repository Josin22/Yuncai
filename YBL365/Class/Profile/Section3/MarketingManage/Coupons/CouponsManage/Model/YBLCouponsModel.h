//
//  YBLCouponsModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"
#import "YBLGoodDetailCouponsModel.h"

typedef NS_ENUM(NSInteger,CouponsCenterState) {
    /**
     *  抢购
     */
    CouponsCenterStateNormal = 0,
    /**
     *  抢光
     */
    CouponsCenterStateOut,
    /**
     *  使用过
     */
    CouponsCenterStateUsed
};

@interface YBLCouponsModel : YBLGoodDetailCouponsModel

@property (nonatomic, copy  ) NSString *js_full_time;

@property (nonatomic, strong) NSNumber *js_value_width;

@property (nonatomic, copy  ) NSString *js_value;

@property (nonatomic, strong) NSMutableAttributedString *js_att_value;

@property (nonatomic, strong) NSNumber *js_condition_width;

@property (nonatomic, copy  ) NSString *js_condition;

@property (nonatomic, strong) NSNumber *js_progress_percent;

@property (nonatomic, strong) YBLGoodModel *product;

@property (nonatomic, assign) CouponsCenterState couponsState;



@end

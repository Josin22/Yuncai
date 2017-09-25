//
//  YBLCouponsTableView.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CouponsStyle) {
    /**
     *  正常优惠券
     */
    CouponsStyleNormal = 0,
    /**
     *  抢购优惠券
     */
    CouponsStyleSnap,
    /**
     *  选择优惠券
     */
    CouponsStyleSelect,
    /**
     *  领取优惠券
     */
    CouponsStyleGot
};

@interface YBLCouponsTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                 couponsStyle:(CouponsStyle)couponsStyle;

@end

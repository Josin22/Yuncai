//
//  YBLBriberyHudToCertificatedView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLBaseFullView.h"

typedef void(^BriberyHudToCertificatedButtonBlock)(NSInteger clickIndex);

@interface YBLBriberyHudToCertificatedView : YBLBaseFullView

+ (void)showBriberyHudToCertificatedViewWithBlock:(BriberyHudToCertificatedButtonBlock)clickBlock;

+ (void)showRechargeYunMoneyHudViewWithBlock:(BriberyHudToCertificatedButtonBlock)clickBlock;

@end

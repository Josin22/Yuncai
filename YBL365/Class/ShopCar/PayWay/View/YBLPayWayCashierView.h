//
//  YBLPayWayView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CashierSelectPayTypeBlock)(PayWayCashierType type);

@interface YBLPayWayCashierView : UIView

+ (void)showPayWayCashierViewWithPayWayCashierType:(PayWayCashierType)cashierType
                                         orderType:(OrderType)orderType
                         CashierSelectPayTypeBlock:(CashierSelectPayTypeBlock)block;

@end

//
//  UITabBar+BageValue.h
//  51XiaoNiu
//
//  Created by 乔同新 on 16/5/25.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (BageValue)

- (void)setBadgeValue:(NSInteger)value AtIndex:(NSInteger)index;

- (void)showBadgeOnItemIndex:(NSInteger)index; //显示小红点

- (void)hideBadgeOnItemIndex:(NSInteger)index; //隐藏小红点

@end

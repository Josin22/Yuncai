//
//  UITabBar+Swizzling.h
//  XYTabBar
//
//  Created by 潘显跃 on 16/4/5.
//  Copyright © 2016年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSUInteger const kTabBarBadgeViewDelta;

@interface UITabBar (Swizzling)

- (void)s_layoutSubviews;

@end

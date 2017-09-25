//
//  UITabBar+BageValue.m
//  51XiaoNiu
//
//  Created by 乔同新 on 16/5/25.
//  Copyright © 2016年 乔同新. All rights reserved.
//

//#define TabbarItemNums 5.0

#define TabbarItemNums 5.0

#import "UITabBar+BageValue.h"
#import "YBLBadgeLabel.h"

@implementation UITabBar (BageValue)


- (void)setBadgeValue:(NSInteger)value AtIndex:(NSInteger)index{
    
    [self removeBadgeOnItemIndex:index];
    
    if (value != 0) {
        //购物车角标
        YBLBadgeLabel *badgeView = [[YBLBadgeLabel alloc]initWithFrame:CGRectZero];
        badgeView.tag = 888+index;
        badgeView.bageValue = value;
        //确定小红点的位置
        CGRect tabFrame = self.frame;
        float percentX = (index +0.6) / TabbarItemNums;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        badgeView.left = x;
        badgeView.top = y;
        [self addSubview:badgeView];
    }
}


- (void)showBadgeOnItemIndex:(NSInteger)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(NSInteger)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(NSInteger)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

@end

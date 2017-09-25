//
//  YBLTabBar.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLTabBar.h"

@implementation YBLTabBar



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //添加阴影
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        self.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowRadius = 4;//阴影半径，默认3
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path moveToPoint:CGPointMake(0, -2)];
        [path addLineToPoint:CGPointMake(YBLWindowWidth, -2)];
        [path addLineToPoint:CGPointMake(YBLWindowWidth, 1)];
        [path addLineToPoint:CGPointMake(0, 1)];
        [path addLineToPoint:CGPointMake(0, -2)];
        
        self.layer.shadowPath = path.CGPath;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger index = 0;
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            v.tag = TABBAR_ITEM_BASETAG+index;
            index++;
        }
    }
}




@end

//
//  YBLUpButton.h
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLUpButton : UIButton

//向上滚动按钮
+ (instancetype)showInView:(UIView *)view center:(CGPoint)center scrollView:(UIScrollView *)scrollView  zeroTop:(CGFloat)top;

//足迹按钮
+ (instancetype)showInView:(UIView *)view center:(CGPoint)center block:(void(^)())block;

@end

//
//  YBLBriberyMoneyView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLBriberyMoneyView : UIView

@property (nonatomic, strong) YBLButton *briberyButton;
/**
 *  倾斜
 */
- (void)lean;
/**
 *  3d旋转
 */
- (void)rotate;
/**
 *  震动
 */
- (void)shake;

- (void)showAnimationOpenBriberyOnView:(UIView *)view;

@end

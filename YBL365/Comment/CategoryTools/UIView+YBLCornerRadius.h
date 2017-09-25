//
//  UIView+YBLCornerRadius.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/31.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YBLCornerRadius)

/**
 设置一个四角圆角
 @param radius 圆角半径
 @param color  圆角背景色
 */
- (void)dd_quadrateCornerWithRadius:(CGFloat)radius
                        cornerColor:(UIColor *)color;

/**
 设置一个普通圆角
 @param radius  圆角半径
 @param color   圆角背景色
 @param corners 圆角位置
 */
- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners;

/**
 设置一个带边框的圆角
 @param radius      圆角半径
 @param color       圆角背景色. 如果为nil,优先选取view,沿superview上的父类容器的背景色
 @param corners     圆角位置
 @param borderColor 边框颜色
 @param borderWidth 边框线宽
 */
- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;

/**
 设置一个带边框的四方圆角
 @param radius      圆角半径
 @param color       圆角背景色. 如果为nil,优先选取view,沿superview上的父类容器的背景色
 @param borderColor 边框颜色
 @param borderWidth 边框线宽
 */
- (void)dd_quadrateCornerWithRadius:(CGFloat)radius
                        cornerColor:(UIColor *)color
                        borderColor:(UIColor *)borderColor
                        borderWidth:(CGFloat)borderWidth;

@end

@interface CALayer (ZKRCornerRadius)

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color;

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners;

- (void)dd_cornerWithRadius:(CGFloat)radius
                cornerColor:(UIColor *)color
                    corners:(UIRectCorner)corners
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;

@end

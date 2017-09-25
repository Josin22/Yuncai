//
//  YBLSuccessAnimationView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimationCompleteBlock)();

@interface YBLSuccessAnimationView : UIView

//+ (instancetype)showSuccessStrokeViewWithFrame:(CGRect)frame
//                                     LineWidth:(CGFloat)lineWidth
//                                   StrokeColor:(UIColor *)strokrColor
//                                durationFinish:(CGFloat)durationFinish;

- (instancetype)initWithFrame:(CGRect)frame
                    lineWidth:(CGFloat)lineWidth
                  strokeColor:(UIColor *)strokrColor
               durationFinish:(CGFloat)durationFinish;

- (void)starAnimationCompleteHandle:(AnimationCompleteBlock)block;

@end

//
//  YBLCouponsProgressView.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLCouponsProgressView : UIView

@property (nonatomic, strong) UIColor *trackColor;

@property (nonatomic, strong) UIColor *progressColor;

@property (nonatomic, assign) CGFloat progressWidth;
/**
 *  0-1
 */
@property (nonatomic, assign) CGFloat progress;

@end

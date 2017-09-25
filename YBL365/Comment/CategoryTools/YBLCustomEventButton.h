//
//  YBLCustomEventButton.h
//  YC168
//
//  Created by 乔同新 on 2017/5/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLButton.h"

@class YBLCustomEventButton;

typedef NS_ENUM(NSInteger,CurrentButtonState){
    ///默认状态
    CurrentButtonStateNormal = 0,
    ///从默认->>第一次点击
    CurrentButtonStateClickFirstOnce,
    ///从第一次点击->>到最后一次点击
    CurrentButtonStateClickLastOnce,
};

typedef void(^YBLClickBlock)(YBLCustomEventButton * button, CurrentButtonState currentButtonState);

@interface YBLCustomEventButton : YBLButton

@property (nonatomic, assign) NSInteger          clickCount;
@property (nonatomic, assign) CurrentButtonState currentButtonState;
@property (nonatomic, copy  ) YBLClickBlock      clickBlock;
@property (nonatomic, assign) NSInteger          allEventCount;

- (void)setTitleColor:(UIColor *)titleColor forCurrentButtonState:(CurrentButtonState)state;
- (void)setImage:(UIImage *)image forCurrentButtonState:(CurrentButtonState)state;

@end

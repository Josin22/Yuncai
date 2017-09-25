//
//  YBLCustomEventButton.m
//  YC168
//
//  Created by 乔同新 on 2017/5/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCustomEventButton.h"

@interface YBLCustomEventButton ()

@property (nonatomic, strong) NSMutableDictionary *imageStateDict;
@property (nonatomic, strong) NSMutableDictionary *titleColorStateDict;

@end

@implementation YBLCustomEventButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clickCount = 0;
        self.allEventCount = 3;
        [self addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (NSMutableDictionary *)titleColorStateDict{
    if (!_titleColorStateDict) {
        _titleColorStateDict = [NSMutableDictionary dictionary];
    }
    return _titleColorStateDict;
}


- (NSMutableDictionary *)imageStateDict{
    if (!_imageStateDict) {
        _imageStateDict = [NSMutableDictionary dictionary];
    }
    return _imageStateDict;
}

- (void)setCurrentButtonState:(CurrentButtonState)currentButtonState{
    
    _currentButtonState = currentButtonState;
    self.clickCount = _currentButtonState;
    [self resetButton];
}

- (void)resetButton{
    
    UIImage *getImage = self.imageStateDict[@(self.currentButtonState)];
    UIColor *getColor = self.titleColorStateDict[@(self.currentButtonState)];
    [self setImage:getImage forState:UIControlStateNormal];
    [self setTitleColor:getColor forState:UIControlStateNormal];
}

- (void)doAction:(YBLCustomEventButton *)btn {
 
    if (self.clickCount>=self.allEventCount-1) {
        if (self.allEventCount==2) {
            return;
        }
        self.clickCount = 0;
    }
    self.clickCount++;
    self.currentButtonState = self.clickCount;
    [self resetButton];
    BLOCK_EXEC(self.clickBlock,btn,self.currentButtonState)
    
}

- (void)setTitleColor:(UIColor *)titleColor forCurrentButtonState:(CurrentButtonState)state{
    if (state == CurrentButtonStateNormal) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    [self.titleColorStateDict setObject:titleColor forKey:@(state)];
}

- (void)setImage:(UIImage *)image forCurrentButtonState:(CurrentButtonState)state {
    if (state == CurrentButtonStateNormal) {
        [self setImage:image forState:UIControlStateNormal];
    }
    [self.imageStateDict setObject:image forKey:@(state)];
}

@end

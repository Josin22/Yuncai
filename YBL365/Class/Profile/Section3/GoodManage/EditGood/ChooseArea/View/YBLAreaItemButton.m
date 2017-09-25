//
//  YBLAreaItemButton.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAreaItemButton.h"

@interface YBLAreaItemButton ()
{
    CGFloat buttonWi;
}

@property (nonatomic, assign) AreaItemButtonType areaItemButtonType;

@end

@implementation YBLAreaItemButton

- (instancetype)initWithFrame:(CGRect)frame areaItemButtonType:(AreaItemButtonType)areaItemButtonType{

    self = [super initWithFrame:frame];
    if (self) {
        
        _areaItemButtonType = areaItemButtonType;
        
        [self createUI];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame areaItemButtonType:AreaItemButtonTypeNormal];
}

- (void)createUI{
    
    buttonWi = 20;
    
    _normalColor = BlackTextColor;
    _selectColor = YBLThemeColor;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-buttonWi, self.height)];
    textLabel.font = YBLFont(14);
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame = CGRectMake(textLabel.right, 0, buttonWi, self.height);
    [arrowButton setImage:[UIImage imageNamed:@"black_arrow"] forState:UIControlStateNormal];
    [arrowButton setImage:[UIImage imageNamed:@"red_arrow"] forState:UIControlStateSelected];
    [self addSubview:arrowButton];
    self.arrowButton = arrowButton;
}

- (void)resetFrame{
    
    self.textLabel.frame = CGRectMake(0, 0, self.width-buttonWi, self.height);
    self.arrowButton.frame = CGRectMake(self.textLabel.right, 0, buttonWi, self.height);
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.arrowButton.hidden = selected;
    
    if (selected) {
        self.textLabel.textColor = _selectColor;
        [UIView animateWithDuration:.3f
                         animations:^{
                             self.textLabel.width = self.width;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    } else {
        self.textLabel.textColor = _normalColor;
        [UIView animateWithDuration:.3f
                         animations:^{
                             self.textLabel.width = self.width-buttonWi;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}


@end

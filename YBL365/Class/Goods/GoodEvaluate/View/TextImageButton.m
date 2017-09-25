//
//  TextImageButton.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "TextImageButton.h"

@interface TextImageButton ()

@property (nonatomic, assign) Type type;

@end

@implementation TextImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = TypeText;
        
        [self creatUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Type:(Type)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    CGFloat hi = 15;
    CGFloat imageHi = self.height*2/5;
    _normalColor = BlackTextColor;
    
    if (_type == TypeText) {
        self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, hi)];
        self.topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topLabel];
        self.topLabel.centerY = self.height/4;
    } else {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageHi, imageHi)];
        self.iconImageView.centerY = self.height/4;
        self.iconImageView.centerX = self.width/2;
        [self addSubview:self.iconImageView];
    }
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, hi)];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.centerY = self.height*3/4;
    [self addSubview:self.bottomLabel];
    
    self.topLabel.bottom = self.height/2-2.5;
    self.bottomLabel.top = self.height/2+2.5;
    
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if (!selected) {
        self.topLabel.textColor = _normalColor;
        self.bottomLabel.textColor = _normalColor;
    } else {
        self.topLabel.textColor = YBLThemeColor;
        self.bottomLabel.textColor = YBLThemeColor;
    }
}

@end


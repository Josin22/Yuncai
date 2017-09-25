//
//  YBLProfileNavigationView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLProfileNavigationView.h"

@interface YBLProfileNavigationView ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation YBLProfileNavigationView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageButton.frame = CGRectMake(self.width - 55, 20, 45, 44);
    [self addSubview:self.messageButton];
    [self.messageButton setImage:[UIImage imageNamed:@"nav_message_icon_22x22_"] forState:UIControlStateNormal];
    
    self.setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setButton.frame = CGRectMake(self.width - 100, 20, 45, 44);
    [self addSubview:self.setButton];
    [self.setButton setImage:[UIImage imageNamed:@"nav_setting_icon_22x22_"] forState:UIControlStateNormal];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
    self.nameLabel.centerX = YBLWindowWidth/2;
    self.nameLabel.text = @"我的";
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = YBLFont(17);
    self.nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    self.nameLabel.alpha = 0;
    
    self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userButton setImage:[UIImage imageWithName:@"login_head_icon_70x70_" size:CGSizeMake(28, 28)] forState:UIControlStateNormal];
    self.userButton.frame = CGRectMake(10, 20+7, 30, 30);
    self.userButton.layer.cornerRadius = 15;
    self.userButton.layer.masksToBounds = YES;
    self.userButton.backgroundColor = YBLColor(200, 200, 200, 0.5);
    [self addSubview:self.userButton];
    self.userButton.alpha = 0;
    
    
}


- (void)setBgViewAlpa:(CGFloat)bgViewAlpa {
    if (_bgViewAlpa == bgViewAlpa) {
        return;
    }
    self.backgroundColor = YBLThemeColorAlp(bgViewAlpa);
    _bgViewAlpa = bgViewAlpa;
    if (bgViewAlpa > 0.85 && self.nameLabel.alpha == 0) {
        self.nameLabel.alpha = 0;
        self.userButton.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.nameLabel.alpha = 1;
            self.userButton.alpha = 1;
        }];
    }else if(bgViewAlpa < 0.85 && self.nameLabel.alpha == 1) {
        self.nameLabel.alpha = 1;
        self.userButton.alpha = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.nameLabel.alpha = 0;
            self.userButton.alpha = 0;
        }];
    }
}

@end

//
//  YBLShopCarHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarHeaderView.h"

@implementation YBLShopCarHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {

    
    self.checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkAllButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.checkAllButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self addSubview:self.checkAllButton];
    [self.checkAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.height.with.equalTo(@30);
        make.width.equalTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
//    self.shopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jshop_dymamic_icon_shop"]];
//    [self addSubview:self.shopImageView];
//    [self.shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.checkAllButton.mas_right);
//        make.width.equalTo(@15);
//        make.height.equalTo(@14);
//        make.centerY.equalTo(self.mas_centerY);
//    }];

    
    self.shopNameLabel = [[UILabel alloc] init];
    self.shopNameLabel.textColor = YBLColor(80, 80, 80, 1.0);
    self.shopNameLabel.font = YBLFont(15);
    [self addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkAllButton.mas_right);
        make.top.bottom.equalTo(@0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
//    self.moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jshop_find_more_arrow"]];
//    [self addSubview:self.moreImageView];
//    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.shopNameLabel.mas_right).with.offset(5);
//        make.width.equalTo(@7);
//        make.height.equalTo(@11);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
    
    
    
    self.expressMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.expressMoneyButton];
    [self.expressMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@-10);
        make.width.equalTo(@100);
    }];
    
    
    UIImageView *infoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderDetailCompanyAccount_i_12x12_"]];
    [self.expressMoneyButton addSubview:infoImageView];
    [infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.centerY.equalTo(self.expressMoneyButton.mas_centerY);
        make.right.equalTo(@0);
    }];
    
    self.expressMoneyLabel = [[UILabel alloc] init];
    self.expressMoneyLabel.textColor = YBLColor(80, 80, 80, 1.0);
    self.expressMoneyLabel.font = YBLFont(14);
    [self addSubview:self.expressMoneyLabel];
    [self.expressMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.expressMoneyButton.mas_centerY);
        make.right.equalTo(infoImageView.mas_left).with.offset(-3);
    }];
    
    
    
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}

- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}

@end

//
//  YBLShopCarStoreHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopCarStoreHeaderView.h"
#import "YBLGoodModel.h"

@interface YBLShopCarStoreHeaderView ()

@end


@implementation YBLShopCarStoreHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = YBLColor(250, 250, 250, 1);
    
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
    
    UIImageView *storeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_store"]];
    storeIcon.frame = CGRectMake(40, space, 20, 20);
    [self.contentView addSubview:storeIcon];
    
    self.shopNameLabel = [[UILabel alloc] init];
    self.shopNameLabel.textColor = YBLColor(80, 80, 80, 1.0);
    self.shopNameLabel.font = YBLFont(15);
    [self addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(storeIcon.mas_right).with.offset(5);;
        make.top.bottom.equalTo(@0);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeButton.frame = CGRectMake(40, 0, YBLWindowWidth-40-space, 30);
    [self addSubview:self.storeButton];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)updataShop:(shop *)model{
    
    self.shopNameLabel.text = model.shopname;
    
    self.checkAllButton.selected = model.shop_select;
}

+ (CGFloat)getHeaderHi{
    
    return 40;
}

@end

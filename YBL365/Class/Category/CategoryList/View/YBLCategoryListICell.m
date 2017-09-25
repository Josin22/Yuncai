//
//  YBLCategoryListICell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryListICell.h"

@implementation YBLCategoryListICell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}
- (void)createSubViews {
    self.goodImageView = [[UIImageView alloc] init];
    [self addSubview:self.goodImageView];
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@2);
        make.bottom.equalTo(@2);
        make.width.equalTo(self.mas_height).with.offset(4);
    }];
    
    
    _goodNameLabel = [[UILabel alloc] init];
    _goodNameLabel.font = YBLFont(14);
    _goodNameLabel.numberOfLines = 2;
    _goodNameLabel.textColor = YBLColor(40, 40, 40, 1.0);
    [self addSubview:_goodNameLabel];
    [_goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImageView.mas_right).with.offset(5);
        make.right.equalTo(@-5);
        make.top.equalTo(@10);
        make.height.equalTo(@40);
    }];
    
    
    
    _localLabel = [[UILabel alloc] init];
    _localLabel.text = [NSString stringWithFormat:@"郑州市"];
    _localLabel.textColor = YBLColor(150, 150, 150, 150);
    _localLabel.font = YBLFont(12);
    [self addSubview:_localLabel];
    [_localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLabel.mas_left);
        make.bottom.equalTo(@-12);
    }];
    
    _saleCountLabel = [[UILabel alloc] init];
    _saleCountLabel.text = [NSString stringWithFormat:@"成交%d笔",50+arc4random()%500];
    _saleCountLabel.textColor = YBLColor(150, 150, 150, 150);
    _saleCountLabel.font = YBLFont(12);
    [self addSubview:_saleCountLabel];
    [_saleCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_localLabel.mas_right).with.offset(15);
        make.bottom.equalTo(_localLabel.mas_bottom);
    }];
    
    
    NSMutableAttributedString *attStr = [NSString stringPrice:@"¥ 00.00" color:[UIColor redColor] font:18 isBoldFont:NO appendingString:nil];
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.attributedText = attStr;
    _priceLabel.textColor = [UIColor redColor];
    
    [self addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodNameLabel.mas_left);
        make.bottom.equalTo(_localLabel.mas_top).with.offset(-5);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.goodNameLabel.mas_left);
    }];
    
    
}
@end

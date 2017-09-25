//
//  YBLShopCarFooterView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopCarFooterView.h"
#import "YBLCartModel.h"

@interface YBLShopCarFooterView ()

@end

@implementation YBLShopCarFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = YBLFont(15);
    priceLabel.textColor = [UIColor redColor];
    priceLabel.attributedText = [NSString stringPrice:@"¥ 00.00" color:[UIColor redColor] font:16 isBoldFont:NO appendingString:nil];
    [self.contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@-20);
    }];
    self.priceLabel = priceLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BASE_COLOR;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
//        make.bottom.equalTo(@-10);
        make.height.equalTo(@25);
        make.right.equalTo(priceLabel.mas_left).with.offset(-8);
        make.width.equalTo(@0.5);
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = YBLFont(14);
    label.text = @"共0种0件";
    label.textColor = YBLColor(70, 70, 70, 1.0);
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(lineView.mas_left).with.offset(-8);
    }];
    self.label = label;
}

- (void)updataSingleSectionGood:(YBLCartModel *)model{
    
    shop *shopModel = model.shop;
    self.label.text = [NSString stringWithFormat:@"共%@种%@件",shopModel.shop_select_goods_zhong_count,shopModel.shop_select_goods_count];
    self.priceLabel.attributedText = shopModel.att_price;
}

+ (CGFloat)getFooterHi{
    
    return 45;
}

@end

//
//  YBLShopCarItemTotalCell.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarItemTotalCell.h"

@implementation YBLShopCarItemTotalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self createSubViews];
        
    }
    return self;
}


- (void)createSubViews {
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = YBLFont(15);
    priceLabel.textColor = [UIColor redColor];
    priceLabel.attributedText = [NSString stringPrice:@"¥ 16.50" color:[UIColor redColor] font:16 isBoldFont:NO appendingString:nil];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(@-20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BASE_COLOR;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.right.equalTo(priceLabel.mas_left).with.offset(-8);
        make.width.equalTo(@0.5);
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.font = YBLFont(14);
    label.text = @"共0种0件";
    label.textColor = YBLColor(70, 70, 70, 1.0);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.right.equalTo(lineView.mas_left).with.offset(-8);
    }];
    
    
}

@end

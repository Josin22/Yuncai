//
//  YBLStoreGoodsCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreGoodsCell.h"

@interface YBLStoreGoodsCell ()
@property (nonatomic, strong) UILabel * goodTitleLabel;
@property (nonatomic, strong) UIImageView * goodImageView;
@property (nonatomic, strong) UILabel * goodPriceLabel;
@property (nonatomic, strong) UILabel * eventLab;
@property (nonatomic, strong) UILabel * promotionLab;
@end

@implementation YBLStoreGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createRecommendGoodUI];
    }
    return self;
}

- (void)createRecommendGoodUI{
    
    _goodImageView = [[UIImageView alloc] init];
    [self addSubview:_goodImageView];
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(self.width));
    }];
    _goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    
    _goodTitleLabel = [[UILabel alloc] init];
    _goodTitleLabel.font = YBLFont(12);
    _goodTitleLabel.textColor = YBLColor(40, 40, 40, 1.0);
    _goodTitleLabel.numberOfLines = 2;
    [self addSubview:_goodTitleLabel];
    [_goodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.right.equalTo(@-8);
        make.width.equalTo(@(self.width-16));
        make.top.equalTo(_goodImageView.mas_bottom).with.offset(2);
    }];
    
    
    NSMutableAttributedString *attStr = [NSString stringPrice:@"¥ 199.00" color:YBLThemeColor font:18 isBoldFont:YES appendingString:nil];
    _goodPriceLabel = [[UILabel alloc] init];
    _goodPriceLabel.attributedText = attStr;
    [self addSubview:_goodPriceLabel];
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodTitleLabel.mas_left);
        make.bottom.equalTo(@0);
        make.height.equalTo(@30);
        
    }];
    
    
    
    _eventLab = [[UILabel alloc]init];
    _eventLab.text = @"热销";
    _eventLab.font = YBLFont(10);
    CGFloat width = [_eventLab.text widthWithStringAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f]}];
//    _eventLab.frame = CGRectMake(self.goodImageView.right+10, 9, width+4, 16);
    _eventLab.textAlignment = NSTextAlignmentCenter;
    _eventLab.layer.cornerRadius = 3;
    _eventLab.layer.masksToBounds = YES;
    _eventLab.layer.borderColor = YBLThemeColor.CGColor;
    _eventLab.layer.borderWidth = 0.5;
//    _eventLab.backgroundColor = YBLThemeColor;
    _eventLab.textColor = YBLThemeColor;
    [self.contentView addSubview:self.eventLab];
    [_eventLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodTitleLabel.mas_left);
        make.top.equalTo(_goodImageView.mas_bottom).with.offset(1);
        make.width.equalTo(@(width+4));
        make.height.equalTo(@16);
    }];
    
    
    self.goodTitleLabel.text = [NSString stringWithFormat:@"%@%@",@"         ",@"飞天茅台 53度 500ml*6/箱 本土原装进口 精品特供本土原装进口 精品特供"];
    
    CGFloat priceWidth = [_goodPriceLabel.text widthWithStringAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:17.f]}];
    
    _promotionLab = [[UILabel alloc]init];
    _promotionLab.text = @"加价购";
    _promotionLab.font = YBLFont(10);
    _promotionLab.textAlignment = NSTextAlignmentCenter;
    _promotionLab.layer.cornerRadius = 3;
    _promotionLab.layer.masksToBounds = YES;
    CGFloat promotionWidth = [_promotionLab.text widthWithStringAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f]}];
//    _promotionLab.frame = CGRectMake(12+priceWidth, self.goodPriceLabel.frame.origin.y+2.5, promotionWidth+4, 16);
//    _promotionLab.backgroundColor = YBLThemeColor;
    _promotionLab.layer.borderColor = YBLThemeColor.CGColor;
    _promotionLab.layer.borderWidth = 0.5;
    _promotionLab.textColor = YBLThemeColor;
    [self.contentView addSubview:self.promotionLab];
    [_promotionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodPriceLabel.mas_left).with.offset(priceWidth+8);
        make.bottom.equalTo(@-6);
        make.width.equalTo(@(promotionWidth+4));
        make.height.equalTo(@16);
    }];
    
}


@end

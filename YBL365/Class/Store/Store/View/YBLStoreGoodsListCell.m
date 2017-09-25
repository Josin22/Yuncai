//
//  YBLStoreGoodsListCell.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreGoodsListCell.h"

@interface YBLStoreGoodsListCell ()
@property (strong, nonatomic) UILabel *commentLab;
@property (strong, nonatomic) UILabel *commentPercentageLab;
@property (nonatomic, strong) UILabel * eventLab;
@property (nonatomic, strong) UILabel * promotionLab;
@property (nonatomic, strong) UILabel * goodTitleLabel;
@property (nonatomic, strong) UIImageView * goodImageView;
@property (nonatomic, strong) UILabel * goodPriceLabel;

@end

@implementation YBLStoreGoodsListCell

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
        make.left.equalTo(@0);
        make.height.equalTo(@102);
        make.width.equalTo(@102);
    }];
    _goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];

    
    _goodTitleLabel = [[UILabel alloc] init];
    _goodTitleLabel.font = YBLFont(14);
    _goodTitleLabel.textColor = YBLColor(40, 40, 40, 1.0);
    _goodTitleLabel.numberOfLines = 2;
    [self addSubview:_goodTitleLabel];
    [_goodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImageView.mas_right).with.offset(10);
        make.right.equalTo(@-8);
        make.height.equalTo(@40);
        make.top.equalTo(@8);
    }];
    
    
    NSMutableAttributedString *attStr = [NSString stringPrice:@"¥ 199.00" color:YBLThemeColor font:18 isBoldFont:YES appendingString:nil];
    _goodPriceLabel = [[UILabel alloc] init];
    _goodPriceLabel.attributedText = attStr;
    [self addSubview:_goodPriceLabel];
    [_goodPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImageView.mas_right).with.offset(10);
        make.right.equalTo(@-8);
        make.top.equalTo(_goodTitleLabel.mas_bottom).with.offset(8);
        make.height.equalTo(@25);
    }];
    
    
    
    _commentLab = [[UILabel alloc] init];
    _commentLab.font = YBLFont(12);
    _commentLab.textColor = YBLColor(140, 140, 140, 1.0);
    _commentLab.numberOfLines = 2;
    [self addSubview:_commentLab];
    [_commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImageView.mas_right).with.offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
        make.top.equalTo(_goodPriceLabel.mas_bottom).with.offset(0);
    }];
    _commentLab.text = @"9927人评价过";
    
    
    _commentPercentageLab = [[UILabel alloc] init];
    _commentPercentageLab.font = YBLFont(12);
    _commentPercentageLab.textColor = YBLColor(140, 140, 140, 1.0);
    _commentPercentageLab.numberOfLines = 2;
    [self addSubview:_commentPercentageLab];
    [_commentPercentageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_commentLab.mas_right).with.offset(10);
        make.right.equalTo(@-8);
        make.height.equalTo(@20);
        make.top.equalTo(_goodPriceLabel.mas_bottom).with.offset(0);
    }];
    _commentPercentageLab.text = @"98%好评率";

    
    _eventLab = [[UILabel alloc]init];
    _eventLab.text = @"热销";
    _eventLab.font = YBLFont(10);
    CGFloat width = [_eventLab.text widthWithStringAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f]}];
    _eventLab.textAlignment = NSTextAlignmentCenter;
    _eventLab.layer.cornerRadius = 3;
    _eventLab.layer.masksToBounds = YES;
    _eventLab.layer.borderColor = YBLThemeColor.CGColor;
    _eventLab.layer.borderWidth = 0.5;
    _eventLab.textColor = YBLThemeColor;
    [self.contentView addSubview:self.eventLab];
    [_eventLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodImageView.mas_right).with.offset(10);
        make.top.equalTo(@10);
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

    _promotionLab.layer.borderColor = YBLThemeColor.CGColor;
    _promotionLab.layer.borderWidth = 0.5;
    _promotionLab.textColor = YBLThemeColor;
    [self.contentView addSubview:self.promotionLab];
    [_promotionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_goodPriceLabel.mas_left).with.offset(priceWidth+8);
        make.top.equalTo(_goodTitleLabel.mas_bottom).with.offset(13);
        make.width.equalTo(@(promotionWidth+4));
        make.height.equalTo(@16);
    }];
    
    UIView * lineView = [[UIImageView alloc] initWithFrame:CGRectMake(112, self.height-0.5, self.width-112, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];

}

@end

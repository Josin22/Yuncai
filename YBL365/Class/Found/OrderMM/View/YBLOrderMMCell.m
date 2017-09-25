//
//  YBLOrderMMCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMCell.h"
#import "YBLTimeDown.h"

@interface YBLOrderMMCell ()

@property (nonatomic, strong) NSString *endTime;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodTitleLabel;

@property (nonatomic, retain) UILabel *goodPriceLabel;

@property (nonatomic, retain) UILabel *boxCountLabel;

@property (nonatomic, retain) UILabel *localLabel;

@property (nonatomic, strong) YBLButton *pepoleLookCountLabel;

@property (nonatomic, strong) YBLTimeDown *timeDownLabel;

@end

@implementation YBLOrderMMCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createOrderMMUI];
    }
    return self;
}

- (void)createOrderMMUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    _goodImageView.backgroundColor = YBLLineColor;
    [self addSubview:_goodImageView];

    
    _goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, CGRectGetMaxY(_goodImageView.frame), _goodImageView.width-8, 35)];
    _goodTitleLabel.font = YBLFont(13);
    _goodTitleLabel.textColor = YBLColor(40, 40, 40, 1.0);
    _goodTitleLabel.numberOfLines = 2;
    [self addSubview:_goodTitleLabel];
    
    _goodPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_goodTitleLabel.frame), CGRectGetMaxY(_goodTitleLabel.frame), _goodTitleLabel.width/2-2, 20)];
    _goodPriceLabel.text = @"¥ 00.00";
    _goodPriceLabel.textColor = [UIColor redColor];
    [self addSubview:_goodPriceLabel];

    _boxCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodPriceLabel.left+_goodPriceLabel.width, _goodPriceLabel.top, _goodPriceLabel.width, 15)];
    _boxCountLabel.text = @"000箱";
    _boxCountLabel.textAlignment = NSTextAlignmentRight;
    _boxCountLabel.textColor = YBLColor(150, 150, 150, 1);
    _boxCountLabel.font = YBLFont(11);
    [self addSubview:_boxCountLabel];

    _pepoleLookCountLabel = [YBLButton buttonWithType:UIButtonTypeCustom];
    _pepoleLookCountLabel.frame = CGRectMake(_goodPriceLabel.left, _goodPriceLabel.bottom, _goodPriceLabel.width, _goodPriceLabel.height);
    [_pepoleLookCountLabel setTitle:@"000人/浏览" forState:UIControlStateNormal];
    [_pepoleLookCountLabel setTitleColor:YBLColor(150, 150, 150, 1) forState:UIControlStateNormal];
    _pepoleLookCountLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    _pepoleLookCountLabel.titleRect = CGRectMake(0, 0, _goodPriceLabel.width, _goodPriceLabel.height);
    _pepoleLookCountLabel.titleLabel.font = YBLFont(11);
    [self addSubview:_pepoleLookCountLabel];
    
    _localLabel = [[UILabel alloc] initWithFrame:CGRectMake(_pepoleLookCountLabel.left+_pepoleLookCountLabel.width, _pepoleLookCountLabel.top, _pepoleLookCountLabel.width, _pepoleLookCountLabel.height)];
    _localLabel.textColor = YBLColor(150, 150, 150, 1);
    _localLabel.textAlignment = NSTextAlignmentRight;
    _localLabel.font = YBLFont(11);
    _localLabel.text = @"郑州";
    [self addSubview:_localLabel];
    
    _timeDownLabel = [[YBLTimeDown alloc] initWithFrame:CGRectMake(2, self.height-20, self.width-4, 16) WithType:TimeDownTypeText];
    _timeDownLabel.textTimerLabel.font = YBLFont(12);
    _timeDownLabel.textTimerLabel.textColor = YBLColor(110, 110, 110, 1);
//    WEAK
//    _timeDownLabel.timeOverBlock = ^{
//        STRONG
//        
//    };
    [self addSubview:_timeDownLabel];
}

- (void)updateModel:(YBLPurchaseOrderModel *)model{
    
    self.endTime = model.enddated_at;
    
    [self.goodImageView js_scale_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:smallImagePlaceholder];
    
    self.goodTitleLabel.text = model.title;
    
    self.goodPriceLabel.attributedText = [NSString price:[NSString stringWithFormat:@"%.2f",model.price.floatValue] color:YBLThemeColor font:16];
    
    self.boxCountLabel.text = [NSString stringWithFormat:@"%@箱",model.quantity];
    
    NSString *looks = [NSString stringWithFormat:@"%@人/浏览",model.visit_times];
    [self.pepoleLookCountLabel setTitle:looks forState:UIControlStateNormal];
    
    self.localLabel.text = [NSString stringWithFormat:@"%@",model.province];
    
//    NSString *testTime = @"2017-03-31 18:22:00";
    //model.enddated_at
    if (model.enddated_at) {
        [self.timeDownLabel setEndTime:model.enddated_at NowTime:model.system_time begainText:@"距结束:"];
    }
}


+ (CGFloat)getOrderMMCellGoodHeight{
    
    return (YBLWindowWidth-15)/2+98;
}

@end

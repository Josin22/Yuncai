//
//  YBLSeckillGoodsPriceCell.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillGoodsPriceCell.h"
#import "YBLTimeDown.h"

@interface YBLSeckillGoodsPriceCell ()

@property (nonatomic, retain) UILabel *seckillPriceLabel;

@property (nonatomic, retain) YBLLabel *oldPriceLabel;

@property (nonatomic, strong) YBLButton *seckillSiginButton;

@property (nonatomic, retain) UILabel *juLabel;

@property (nonatomic, strong) YBLTimeDown *seckillTimeDown;

@end

@implementation YBLSeckillGoodsPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createGoodsPriceUI];
    }
    return self;
}

- (void)createGoodsPriceUI{
    
    self.contentView.backgroundColor = YBLColor(254, 234, 233, 1);
    
    CGFloat bgLayerW = YBLWindowWidth*2/3;
    
    CAGradientLayer *bgLayer = [CAGradientLayer layer];
    bgLayer.frame = CGRectMake(0, 0, bgLayerW, 50);
    bgLayer.colors = @[
                        (__bridge id)YBLColor(238, 53, 142, 1).CGColor,
                        (__bridge id)YBLColor(239, 54, 101, 1).CGColor,
                        (__bridge id)YBLColor(238, 56, 72, 1).CGColor
                        ];
     bgLayer.locations  = @[@(0.25), @(0.5), @(0.75)];
    bgLayer.startPoint = CGPointMake(0, 0);
    bgLayer.endPoint   = CGPointMake(1, 0);
    [self.layer addSublayer:bgLayer];
    
    _seckillPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, bgLayerW, 30)];
    _seckillPriceLabel.attributedText = [NSString stringPrice:@"¥ 39.90" color:[UIColor whiteColor] font:25 isBoldFont:NO appendingString:nil];
    [self addSubview:_seckillPriceLabel];
    
    NSString *text = @"XX秒杀";
    
    CGSize textSize = [text heightWithFont:YBLFont(12) MaxWidth:200];
    
    _seckillSiginButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    _seckillSiginButton.frame = CGRectMake(_seckillPriceLabel.frame.origin.x, CGRectGetMaxY(_seckillPriceLabel.frame), textSize.width+30, 18);
    [_seckillSiginButton setImage:[UIImage imageNamed:@"goods_timelock"] forState:UIControlStateNormal];
    _seckillSiginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _seckillSiginButton.layer.borderWidth = 0.5;
    [_seckillSiginButton setTitle:@"XXX秒杀" forState:UIControlStateNormal];
    [_seckillSiginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _seckillSiginButton.imageRect = CGRectMake(0, 0, _seckillSiginButton.height, _seckillSiginButton.height);
    _seckillSiginButton.titleRect = CGRectMake(0, 0, _seckillSiginButton.width, _seckillSiginButton.height);
    _seckillSiginButton.titleLabel.font = YBLFont(11);
    _seckillSiginButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_seckillSiginButton];
    
    _oldPriceLabel = [[YBLLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_seckillSiginButton.frame)+2, _seckillSiginButton.frame.origin.y, bgLayerW/2, _seckillSiginButton.height)];
    _oldPriceLabel.text = @"¥199.00";
    _oldPriceLabel.textColor = [UIColor whiteColor];
    _oldPriceLabel.font = YBLFont(12);
    _oldPriceLabel.strikeThroughColor = [UIColor whiteColor];
    _oldPriceLabel.strikeThroughEnabled = YES;
    [self addSubview:_oldPriceLabel];
    
    _juLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgLayerW, 0, bgLayerW/2, 20)];
    _juLabel.text = @"距结束还剩:";
    _juLabel.textColor = YBLColor(238, 56, 72, 1);
    _juLabel.font = YBLFont(12);
    _juLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_juLabel];
    
    _seckillTimeDown = [[YBLTimeDown alloc] initWithFrame:CGRectMake(bgLayerW+bgLayerW/4-40, CGRectGetMaxY(_juLabel.frame), 80, 25) WithType:TimeDownTypeNumber];
    NSString *testTime = @"2017-02-09 9:06:30";
    [_seckillTimeDown setEndTime:testTime
                  begainText:@""];
    [_seckillTimeDown setBackgroundColor:YBLColor(238, 56, 72, 1) TextColor:[UIColor whiteColor] radiuo:3];
    [self addSubview:_seckillTimeDown];
    
}


+ (CGFloat)getSeckillGoodsPriceCellHeight{
    
    return 50;
}

@end

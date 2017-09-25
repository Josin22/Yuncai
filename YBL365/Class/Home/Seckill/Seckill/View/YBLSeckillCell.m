//
//  YBLSeckillCell.m
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillCell.h"
#import "YBLProgressView.h"
#import "YBLSeckillButton.h"

@interface YBLSeckillCell ()

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodTitleLabel;

@property (nonatomic, retain) UILabel *seckillPriceLabel;

@property (nonatomic, retain) YBLLabel *oldPriceLabel;

@property (nonatomic, retain) UILabel *saleCountLabel;

@property (nonatomic, retain) UILabel *remandCountLabel;

@property (nonatomic, strong) YBLSeckillButton *typeButton;

@property (nonatomic, strong) YBLProgressView *progressView;

@end

@implementation YBLSeckillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSeckillUI];
    }
    return self;
}


- (void)createSeckillUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat space = 5;
    
    _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, 100, 100)];
    _goodImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self addSubview:_goodImageView];
    
    _goodTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodImageView.frame)+space, _goodImageView.frame.origin.y, YBLWindowWidth-CGRectGetMaxX(_goodImageView.frame)-2*space, 40)];
    _goodTitleLabel.numberOfLines = 2;
    _goodTitleLabel.textColor = BlackTextColor;
    _goodTitleLabel.font = YBLFont(13);
    _goodTitleLabel.text = @"拉菲传奇 法国波尔多AOC干红葡萄酒 原瓶进口红酒750ml 拉菲传奇";
    [self addSubview:_goodTitleLabel];
    
    _seckillPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodTitleLabel.frame.origin.x, 120-35-space, _goodTitleLabel.width/2, 20)];
    _seckillPriceLabel.textAlignment = NSTextAlignmentLeft;
    _seckillPriceLabel.attributedText = [NSString stringPrice:@"¥ 199.00" color:YBLThemeColor font:19 isBoldFont:YES appendingString:nil];
    [self addSubview:_seckillPriceLabel];
    
    _oldPriceLabel = [[YBLLabel alloc] initWithFrame:CGRectMake(_seckillPriceLabel.frame.origin.x, CGRectGetMaxY(_seckillPriceLabel.frame), _seckillPriceLabel.width, 15)];
    _oldPriceLabel.textAlignment = NSTextAlignmentLeft;
    _oldPriceLabel.text = @"¥299.00";
    _oldPriceLabel.font = YBLFont(10);
    _oldPriceLabel.textColor = YBLTextColor;
    _oldPriceLabel.strikeThroughColor = YBLTextColor;
    _oldPriceLabel.strikeThroughEnabled = YES;
    [self addSubview:_oldPriceLabel];
    
    _typeButton = [YBLSeckillButton buttonWithType:UIButtonTypeCustom];
    _typeButton.frame = CGRectMake(YBLWindowWidth-80-space, 120-space-30-12, 80, 30);
    _typeButton.seckillType = SeckillTypeGoBuy;
    [_typeButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_typeButton];
    
    _progressView = [[YBLProgressView alloc] initWithFrame:CGRectMake(_typeButton.frame.origin.x, CGRectGetMaxY(_typeButton.frame)+6, _typeButton.width, 6)];
    _progressView.fillColor = YBLThemeColor;
    [_progressView loading:0.8];
    [self addSubview:_progressView];
    
    _saleCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(YBLWindowWidth/2, CGRectGetMaxY(_typeButton.frame)+3, YBLWindowWidth/2-space-2-_typeButton.width, 12)];
    _saleCountLabel.text = @"已售36%";
    _saleCountLabel.textColor = YBLTextColor;
    _saleCountLabel.textAlignment = NSTextAlignmentRight;
    _saleCountLabel.font = YBLFont(9);
    [self addSubview:_saleCountLabel];
    
    _remandCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(YBLWindowWidth/2, CGRectGetMaxY(_typeButton.frame)+3, YBLWindowWidth/2-space, 12)];
    _remandCountLabel.text = @"118人已设置提醒";
    _remandCountLabel.textColor = YBLTextColor;
    _remandCountLabel.font = YBLFont(11);
    _remandCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_remandCountLabel];
    _remandCountLabel.hidden = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, 119.5, YBLWindowWidth-2*space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)updateSeckillData:(NSInteger)test{
    
    if (test == 1) {
        
        _saleCountLabel.hidden = NO;
        _progressView.hidden = NO;
        _remandCountLabel.hidden = YES;
        _typeButton.seckillType = SeckillTypeGoBuy;
        
    } else {

        _saleCountLabel.hidden = YES;
        _progressView.hidden = YES;
        _remandCountLabel.hidden = NO;
        _typeButton.seckillType = SeckillTypeRecomandNoraml;
        
    }
    
}

- (void)typeButtonClick:(YBLSeckillButton *)btn{
    
    if (btn.seckillType == SeckillTypeGoBuy) {
        
        BLOCK_EXEC(self.seckillCellGoSeckillBlock,);
        
    } else if(btn.seckillType == SeckillTypeNoCount){
        
    } else {
        btn.seckillType = !(btn.selected == YES)?SeckillTypeRecomandSelect:SeckillTypeRecomandNoraml;
        btn.selected = !btn.selected;
    }
    
}

+ (CGFloat)getSeckillCellHeight{
    
    return 120;
}

@end

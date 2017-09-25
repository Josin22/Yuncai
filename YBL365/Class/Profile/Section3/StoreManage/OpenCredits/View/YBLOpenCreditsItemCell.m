//
//  YBLOpenCreditsItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOpenCreditsItemCell.h"

@interface YBLOpenCreditsItemCell ()
//年
@property (nonatomic, retain) UILabel *yearLabel;
//金额
@property (nonatomic, retain) UILabel *moeyLabel;
//描述
@property (nonatomic, retain) UILabel *DespLabel;
//优惠
@property (nonatomic, retain) UILabel *discountLabel;

@end

@implementation YBLOpenCreditsItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
 
    CGFloat hi = [YBLOpenCreditsItemCell getHi];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 40, hi)];
    self.yearLabel.textColor = BlackTextColor;
    self.yearLabel.font = YBLFont(15);
    [self.contentView addSubview:self.yearLabel];
    
    self.moeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.yearLabel.right, 0, 40, hi)];
    self.moeyLabel.textColor = YBLThemeColor;
    self.moeyLabel.font = YBLFont(16);
    [self.contentView addSubview:self.moeyLabel];
    
    
    self.DespLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.moeyLabel.right, 0, 40, hi)];
    self.DespLabel.textColor = YBLTextColor;
    self.DespLabel.font = YBLFont(12);
    [self.contentView addSubview:self.DespLabel];
    
    
    self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 40, 20)];
    self.discountLabel.textColor = [UIColor whiteColor];
    self.discountLabel.backgroundColor = YBLThemeColor;
    self.discountLabel.font = YBLFont(10);
    self.discountLabel.textAlignment = NSTextAlignmentCenter;
    self.discountLabel.layer.cornerRadius = 3;
    self.discountLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:self.discountLabel];
    
    CGFloat buttonWi = 55;
    CGFloat buttonHi = 25;
    
    self.openCreditsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openCreditsButton.frame = CGRectMake(YBLWindowWidth-space-buttonWi, 0, buttonWi, buttonHi);
    self.openCreditsButton.centerY = hi/2;
    self.openCreditsButton.layer.cornerRadius = buttonHi/2;
    self.openCreditsButton.layer.masksToBounds = YES;
    [self.openCreditsButton setTitle:@"开通" forState:UIControlStateNormal];
    [self.openCreditsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.openCreditsButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    self.openCreditsButton.titleLabel.font = YBLFont(15);
    [self.contentView addSubview:self.openCreditsButton];
    
    
    [self.contentView addSubview:[YBLMethodTools addLineView:CGRectMake(space, hi-0.5, YBLWindowWidth, 0.5)]];
}

- (void)updateModel:(YBLCreditPriceStandardsModel *)model{
    
    self.yearLabel.text = model.name;
    NSString *moenyString = [NSString stringWithFormat:@"%ld元",(long)model.price.integerValue];
    self.moeyLabel.text = moenyString;
    self.DespLabel.text = model.summary;
    NSString *discountString = @"超值";
    self.discountLabel.text = discountString;

    if (model.summary.length>0) {
        self.DespLabel.hidden = NO;
        self.discountLabel.hidden = NO;
    } else {
        self.DespLabel.hidden = YES;
        self.discountLabel.hidden = YES;
    }
    
    CGSize yearSize = [model.name heightWithFont:YBLFont(15) MaxWidth:200];
    CGSize moneySize = [moenyString heightWithFont:YBLFont(16) MaxWidth:200];
    CGSize despSize = [model.summary heightWithFont:YBLFont(12) MaxWidth:200];
    CGSize discountSize = [discountString heightWithFont:YBLFont(10) MaxWidth:200];
    
    self.yearLabel.width = yearSize.width;

    self.moeyLabel.left = self.yearLabel.right+3;
    self.moeyLabel.width = moneySize.width;
    
    self.DespLabel.left = self.moeyLabel.right+5;
    self.DespLabel.width = despSize.width;
   
    self.discountLabel.left = self.DespLabel.right+5;
    self.discountLabel.width = discountSize.width+3;
    self.discountLabel.height = discountSize.height+1;
    self.discountLabel.centerY = self.height/2;
    
}

+ (CGFloat)getHi{
    return 60;
}

@end

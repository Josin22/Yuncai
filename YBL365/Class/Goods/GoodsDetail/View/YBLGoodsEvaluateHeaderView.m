//
//  YBLGoodsEvaluateHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsEvaluateHeaderView.h"

@interface YBLGoodsEvaluateHeaderView ()

@end

@implementation YBLGoodsEvaluateHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createHeaderViewUI];
    }
    return self;
}

- (void)createHeaderViewUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.countEvaluateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.countEvaluateLabel.font = YBLFont(13);
    self.countEvaluateLabel.text = @"评价(0)";
    self.countEvaluateLabel.textColor = YBLTextColor;
    [self addSubview:self.countEvaluateLabel];
    
    self.goodEvaluateButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.goodEvaluateButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.goodEvaluateButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    self.goodEvaluateButton.titleLabel.font = YBLFont(13);
    [self.goodEvaluateButton setImage:[UIImage imageNamed:@"goods_list_arrow"] forState:UIControlStateNormal];
    self.goodEvaluateButton.titleRect = CGRectMake(0, 0,  YBLWindowWidth/2-13-6-5, 40);
    self.goodEvaluateButton.imageRect = CGRectMake( YBLWindowWidth/2-10-6, 13,  6, 12);
    [self addSubview:self.goodEvaluateButton];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,39.5, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.countEvaluateLabel.frame = CGRectMake(10, 0, YBLWindowWidth/2-10, self.height);
    self.goodEvaluateButton.frame = CGRectMake(CGRectGetMaxX(self.countEvaluateLabel.frame), 0, self.countEvaluateLabel.width, self.countEvaluateLabel.height);
}

- (void)updateEVcount:(NSInteger)evCount evPercent:(float)evpercent{
    self.countEvaluateLabel.text = [NSString stringWithFormat:@"评价(%ld)",evCount];
    NSString *string1 = [NSString stringWithFormat:@"好评度 %.f﹪",evpercent*100];;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    NSInteger dian = [string1 rangeOfString:@" "].location;
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:BlackTextColor range:NSMakeRange(0, dian)];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:YBLThemeColor range:NSMakeRange(dian, string1.length-dian)];
    [self.goodEvaluateButton setAttributedTitle:attributedString1 forState:UIControlStateNormal];
}

+ (CGFloat)getGoodsEvaluateHeaderViewHeight{
    
    return 40;
}

@end

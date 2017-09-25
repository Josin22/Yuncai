//
//  YBLOrderBannerView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLOrderBannerView.h"

@interface YBLOrderBannerView ()

@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation YBLOrderBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;

}

- (void)createSubViews {

    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(self.width - 150, 0, 150, kBottomBarHeight);
    [self.submitButton setTitle:@"提交订单" forState:UIControlStateDisabled];
    [self.submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.submitButton setBackgroundColor:YBLColor(210, 210, 210, 1) forState:UIControlStateDisabled];
    [self.submitButton setBackgroundColor:YBL_RED forState:UIControlStateNormal];
    [self addSubview:self.submitButton];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - 160, kBottomBarHeight)];

    self.priceLabel.attributedText = [self createPrice:68.40];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.priceLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [self addSubview:lineView];
    
}

- (void)setPrice:(CGFloat)price {
    self.priceLabel.attributedText = [self createPrice:price];
}


- (NSMutableAttributedString *)createPrice:(CGFloat)price {
    NSString *pricestr = [NSString stringWithFormat:@"实付款:¥%.2f",price];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:pricestr];
    
    [str addAttribute:NSFontAttributeName
                value:YBLFont(17)
                range:NSMakeRange(0, pricestr.length - 3)];
    
    [str addAttributes:@{NSFontAttributeName:YBLFont(14),}
                 range:NSMakeRange(pricestr.length - 3,3)];
    [str addAttribute:NSForegroundColorAttributeName value:YBLColor(240, 70, 73, 1.0) range:NSMakeRange(0, pricestr.length)];
    return str;
}


@end

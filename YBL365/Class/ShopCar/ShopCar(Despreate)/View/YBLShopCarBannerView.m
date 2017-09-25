//
//  YBLShopCarBannerView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarBannerView.h"


@interface YBLShopCarBannerView ()

@property (nonatomic, strong) UIView *normalView;
@property (nonatomic, strong) UIView *editView;

@end

@implementation YBLShopCarBannerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setImage:[UIImage imageNamed:@"syncart_round_check2New"] forState:UIControlStateSelected];
    [self.checkButton setImage:[UIImage imageNamed:@"syncart_round_check1New"] forState:UIControlStateNormal];
    [self.checkButton setTitle:@"  全选" forState:UIControlStateNormal];
    [self.checkButton setTitleColor:YBLColor(100, 100, 100, 1.0) forState:UIControlStateNormal];
    self.checkButton.titleLabel.font = YBLFont(12);
    self.checkButton.frame = CGRectMake(0, 0, 70, 49);
    [self addSubview:self.checkButton];
    
    
    
    self.normalView = [[UIView alloc] initWithFrame:CGRectMake(70, 0, self.width-70, self.height)];
    self.normalView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.normalView];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = @"合计: ";
    totalLabel.textColor = YBLColor(40, 40, 40, 1.0);
    totalLabel.font = YBLFont(16);
    [self.normalView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@34);
    }];
    
    self.realPriceLabel = [[UILabel alloc] init];
    self.realPriceLabel.text = @"¥00.00";
    self.realPriceLabel.textColor = YBLColor(40, 40, 40, 1.0);
    self.realPriceLabel.font = YBLFont(16);
    [self.normalView addSubview:self.realPriceLabel];
    [self.realPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(totalLabel.mas_right);
        make.height.equalTo(@34);
    }];
    
    self.subPriceLabel = [[UILabel alloc] init];
    self.subPriceLabel.text = @"¥00.00";
    self.subPriceLabel.textColor = YBLColor(40, 40, 40, 1.0);
    self.subPriceLabel.font = YBLFont(11);
    [self.normalView addSubview:self.subPriceLabel];
    [self.subPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.realPriceLabel.mas_bottom).with.offset(-4);
        make.height.equalTo(@15);
    }];
    
    
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyButton.backgroundColor = YBLColor(239, 51, 56, 1.0);
    [self.buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setGoodNumber:0];
    [self.normalView addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.equalTo(@110);
    }];
    
    
    [self createEditView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = LINE_BASE_COLOR;
    [self addSubview:lineView];
    
}


- (void)setGoodNumber:(NSInteger)goodNumber {
    NSString *numstr = [NSString stringWithFormat:@"去结算(%ld)",goodNumber];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numstr];
    [str addAttributes:@{NSFontAttributeName:YBLFont(16),}
                 range:NSMakeRange(0, 3)];
    [str addAttributes:@{NSFontAttributeName:YBLFont(13),}
                 range:NSMakeRange(3, numstr.length - 3)];
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, numstr.length)];
    [self.buyButton setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)updateWithType:(ShopCarType )carType {
    self.checkButton.selected = NO;
    if (carType == ShopCarTypeNormal) {
        self.normalView.hidden = NO;
        self.editView.hidden = YES;
    }else if (carType == ShopCarTypeEdite){
        self.normalView.hidden = YES;
        self.editView.hidden = NO;
    }
}

- (void)createEditView {
    self.editView = [[UIView alloc] initWithFrame:CGRectMake(70, 0.5, self.normalView.width, self.normalView.height-0.5)];
    self.editView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.editView];
    self.editView.hidden = YES;
    
    
    self.deleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleButton setTitleColor:YBLColor(239, 51, 56, 1.0) forState:UIControlStateNormal];
    self.deleButton.layer.cornerRadius = 3;
    self.deleButton.layer.masksToBounds = YES;
    self.deleButton.layer.borderWidth = 1;
    self.deleButton.layer.borderColor = YBLColor(239, 51, 56, 1.0).CGColor;
    self.deleButton.titleLabel.font = YBLFont(14);
    self.deleButton.frame = CGRectMake(self.editView.width - 77, 9, 70, 31);
    [self.editView addSubview:self.deleButton];
    
    
    self.careButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.careButton setTitle:@"移入关注" forState:UIControlStateNormal];
    [self.careButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    self.careButton.layer.cornerRadius = 3;
    self.careButton.layer.masksToBounds = YES;
    self.careButton.layer.borderWidth = 1;
    self.careButton.layer.borderColor = YBLColor(70, 70, 70, 1.0).CGColor;
    self.careButton.titleLabel.font = YBLFont(14);
    self.careButton.frame = CGRectMake(self.editView.width - 77*2, 9, 70, 31);
    [self.editView addSubview:self.careButton];

    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    self.shareButton.layer.cornerRadius = 3;
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.borderWidth = 1;
    self.shareButton.layer.borderColor = YBLColor(70, 70, 70, 1.0).CGColor;
    self.shareButton.titleLabel.font = YBLFont(14);
    self.shareButton.frame = CGRectMake(self.editView.width - 77*3, 9, 70, 31);
    [self.editView addSubview:self.shareButton];
    
    
}


- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}

@end

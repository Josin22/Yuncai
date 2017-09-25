//
//  YBLOrderMMMyDepositCell.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMMyDepositCell.h"

@interface YBLOrderMMMyDepositCell ()

@property (nonatomic, strong) UIButton *signButton;

@property (nonatomic, strong) UIImageView *goodsImageView;

@property (nonatomic, retain) UILabel *goodsNameLabel;

@property (nonatomic, retain) UILabel *depositAmountLabel;

@property (nonatomic, retain) UILabel *backLabel;

@end

@implementation YBLOrderMMMyDepositCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    
    CGFloat height = [YBLOrderMMMyDepositCell getDepositCellHeight];
    
    self.goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, height-2*space, height-2*space)];
    self.goodsImageView.image = [UIImage imageNamed:smallImagePlaceholder];
    [self addSubview:self.goodsImageView];
    
    self.signButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signButton.frame = CGRectMake(self.goodsImageView.left, self.goodsImageView.top, 55, 20);
    [self.signButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.signButton setBackgroundColor:YBLColor(190, 191, 192, 1) forState:UIControlStateDisabled];
    [self.signButton setTitle:@"正在进行" forState:UIControlStateNormal];
    [self.signButton setTitle:@"已结束" forState:UIControlStateDisabled];
    [self.signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signButton setTitleColor:YBLColor(150, 151, 152, 1) forState:UIControlStateDisabled];
    self.signButton.titleLabel.font = YBLFont(12);
    [self addSubview:self.signButton];
    
    self.goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsImageView.right+space, self.goodsImageView.top, YBLWindowWidth-self.goodsImageView.right+space*2, 40)];
    self.goodsNameLabel.numberOfLines = 2;
    self.goodsNameLabel.text = @"56度五粮液优质胡萝卜塑盖 1985年 52度 500ML";
    self.goodsNameLabel.textColor = BlackTextColor;
    self.goodsNameLabel.font = YBLFont(14);
    [self addSubview:self.goodsNameLabel];
    
    CGFloat buttonWi = 60;
    
    UILabel *myDe = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsNameLabel.left, self.goodsNameLabel.bottom+space, self.goodsNameLabel.width-buttonWi-space, 20)];
    myDe.textColor = YBLTextColor;
    myDe.text = @"保证金: ¥120";
    myDe.font = YBLFont(12);
    [self addSubview:myDe];
    self.depositAmountLabel = myDe;
    
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payButton.frame = CGRectMake(YBLWindowWidth-space-buttonWi, height-space-30, buttonWi, 30);
    [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [self.payButton setTitle:@"已支付" forState:UIControlStateDisabled];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payButton setTitleColor:YBLColor(150, 151, 152, 1) forState:UIControlStateDisabled];
    [self.payButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.payButton setBackgroundColor:YBLColor(150, 151, 152, 1) forState:UIControlStateDisabled];
    self.payButton.titleLabel.font = YBLFont(13);
    [self addSubview:self.payButton];
    
    self.backLabel = [[UILabel alloc] initWithFrame:CGRectMake(myDe.left, myDe.bottom, myDe.width, 20)];
    self.backLabel.text = @"与2016年4月1日 12:10已退还";
    self.backLabel.font = YBLFont(12);
    self.backLabel.textColor = YBLTextColor;
    [self addSubview:self.backLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height-0.5, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)setType:(TypeDeposit)type{
    
    if (type == TypeDepositDoing) {
        self.signButton.enabled = YES;
        self.payButton.enabled = YES;
        self.backLabel.hidden = YES;
    } else if (type == TypeDepositEndNotPay) {
        self.payButton.enabled = NO;
        self.signButton.enabled = NO;
        self.backLabel.hidden = YES;
        [self.payButton setTitle:@"已支付" forState:UIControlStateDisabled];
        [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.payButton setBackgroundColor:YBLColor(21, 147, 23, 1) forState:UIControlStateDisabled];
    } else {
        self.payButton.enabled = NO;
        self.signButton.enabled = NO;
        [self.payButton setTitle:@"已返还" forState:UIControlStateDisabled];
        [self.payButton setTitleColor:YBLColor(150, 151, 152, 1) forState:UIControlStateDisabled];
        [self.payButton setBackgroundColor:YBLColor(190, 191, 192, 1) forState:UIControlStateDisabled];
        self.backLabel.hidden = NO;
    }
}

+ (CGFloat)getDepositCellHeight{
    
    return 100;
}

@end

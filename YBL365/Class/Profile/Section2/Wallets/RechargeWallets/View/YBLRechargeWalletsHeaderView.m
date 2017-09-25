//
//  YBLRechargeWalletsHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/26.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRechargeWalletsHeaderView.h"

static NSInteger const tag_pay_button = 90401;

@interface YBLRechargeWalletsHeaderView ()
{
    
}
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *namelLabel;

@property (nonatomic, strong) UIView *redLineView;

@end

@implementation YBLRechargeWalletsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    CGFloat imaegWi = 50;
    self.currentPayIndex = 0;
    self.backgroundColor = [UIColor whiteColor];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, imaegWi, imaegWi)];
//    self.iconImageView.layer.cornerRadius = space;
//    self.iconImageView.layer.masksToBounds = YES;
    [self addSubview:self.iconImageView];
    NSString *user_image = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
    [self.iconImageView js_alpha_setImageWithURL:[NSURL URLWithString:user_image] placeholderImage:smallImagePlaceholder];
    
    
    self.namelLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.right+space, 0, self.width-self.iconImageView.right-2*space, 20)];
    self.namelLabel.centerY = self.iconImageView.centerY;
    self.namelLabel.textColor = BlackTextColor;
    self.namelLabel.font = YBLFont(14);
    [self addSubview:self.namelLabel];
    self.namelLabel.text = [YBLUserManageCenter shareInstance].userInfoModel.shopname;
    
    
    UIView *lineView1 = [YBLMethodTools addLineView:CGRectMake(self.iconImageView.left, self.iconImageView.bottom+space, self.width-self.iconImageView.left, .5)];
    [self addSubview:lineView1];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.left, lineView1.bottom+space, lineView1.width, 15)];
    payLabel.textColor = YBLTextLightColor;
    payLabel.text = @"支付方式";
    payLabel.font = YBLFont(12);
    [self addSubview:payLabel];
    
    NSArray *payArray = @[@{@"name":@"支付宝",@"image":@"zhifubao"},@{@"name":@"微信",@"image":@"weixin"}];
    NSInteger index = 0;
    CGFloat button_wi = self.width/payArray.count;
    CGFloat button_hi = 60;
    for (NSDictionary *itemDict in payArray) {
        NSString *name = itemDict[@"name"];
        NSString *image = itemDict[@"image"];
        
        YBLButton *payButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(index*button_wi, payLabel.bottom+space, button_wi, button_hi);
        [payButton setTitle:name forState:UIControlStateNormal];
        [payButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        payButton.titleLabel.font = YBLFont(14);
        payButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [payButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        CGFloat imageHI = 30;
        payButton.imageRect = CGRectMake(button_wi/2-imageHI/2, button_hi/2-imageHI, imageHI, imageHI);
        payButton.titleRect = CGRectMake(0, button_hi/2, button_wi, 20);
        payButton.tag = tag_pay_button+index;
        [payButton addTarget:self action:@selector(PayClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:payButton];

        if (index!=payArray.count-1) {
            UIView *buttonLine = [YBLMethodTools addLineView:CGRectMake(0, 0, .5, payButton.height*2/3)];
            buttonLine.centerY = payButton.height/2;
            [payButton addSubview:buttonLine];
        }
        
        index++;
    }
    
    CGFloat pay_height = payLabel.bottom+space+button_hi;
    
    UIView *bottomView = [YBLMethodTools addLineView:CGRectMake(0, pay_height-.5, self.width, .5)];
    [self addSubview:bottomView];
    
    UIView *redLineView = [[UIView alloc] initWithFrame:CGRectMake(0, pay_height-1.5, button_wi/2, 1.5)];
    redLineView.centerX = button_wi/2;
    redLineView.backgroundColor = YBLThemeColor;
    [self addSubview:redLineView];
    self.redLineView = redLineView;
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.left, pay_height+space, payLabel.width, payLabel.height)];
    moneyLabel.textColor = YBLTextLightColor;
    moneyLabel.text = @"充值云币";
    moneyLabel.font = YBLFont(12);
    [self addSubview:moneyLabel];
    
    self.height = moneyLabel.bottom;
    
}

- (void)PayClickMethod:(YBLButton *)btn {
    
    NSInteger index = btn.tag-tag_pay_button;
    
    if (index!=self.currentPayIndex) {
        
        [UIView animateWithDuration:.5
                              delay:0
             usingSpringWithDamping:.6
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.redLineView.centerX = btn.centerX;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        self.currentPayIndex = index;
    }
    
}

@end

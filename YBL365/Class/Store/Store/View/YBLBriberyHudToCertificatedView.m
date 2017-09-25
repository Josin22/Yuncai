//
//  YBLBriberyHudToCertificatedView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBriberyHudToCertificatedView.h"

static YBLBriberyHudToCertificatedView *briberyHudToCertificatedView = nil;

@interface YBLBriberyHudToCertificatedView ()
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, copy ) NSString *infoText;
@property (nonatomic, copy ) NSString *bgImageName;
@property (nonatomic, copy ) BriberyHudToCertificatedButtonBlock clickBlock;

@end

@implementation YBLBriberyHudToCertificatedView

+ (void)showRechargeYunMoneyHudViewWithBlock:(BriberyHudToCertificatedButtonBlock)clickBlock{
    [self showBriberyHudToCertificatedViewWithButtonTitles:@[@"充值云币",@"开通信用通"]
                                                  infoText:@"您的钱包已无云币可使用\n开通信用通可查看38万\n精准客户更超值!\n\n也可以充值云币查看精准客户"
                                               bgImageName:@"recharge_bg"
                                                clickBlock:clickBlock];
}

+ (void)showBriberyHudToCertificatedViewWithBlock:(BriberyHudToCertificatedButtonBlock)clickBlock{
    [self showBriberyHudToCertificatedViewWithButtonTitles:@[@"我要开店",@"我要采购"]
                                                  infoText:@"您还不是认证用户\n请先认证才能领取红包~"
                                               bgImageName:@"store_not_certification"
                                                clickBlock:clickBlock];
}

+ (void)showBriberyHudToCertificatedViewWithButtonTitles:(NSArray *)buttonTitles
                                                infoText:(NSString *)infoText
                                             bgImageName:(NSString *)bgImageName
                                              clickBlock:(BriberyHudToCertificatedButtonBlock)clickBlock{

    if (!briberyHudToCertificatedView) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        briberyHudToCertificatedView  = [[YBLBriberyHudToCertificatedView alloc] initWithFrame:[window bounds]
                                                                                  buttonTitles:buttonTitles
                                                                                      infoText:infoText
                                                                                   bgImageName:bgImageName
                                                                              clickBlock:clickBlock];
        [window addSubview:briberyHudToCertificatedView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                 buttonTitles:(NSArray *)buttonTitles
                     infoText:(NSString *)infoText
                  bgImageName:(NSString *)bgImageName
                        clickBlock:(BriberyHudToCertificatedButtonBlock)clickBlock{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _buttonTitles= buttonTitles;
        _infoText=infoText;
        _bgImageName= bgImageName;
        _clickBlock = clickBlock;
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIImage *briberyBgImage = [UIImage imageNamed:_bgImageName];
    CGFloat contentWi = self.width*4/5;
    CGFloat contentHi = (double)briberyBgImage.size.height/briberyBgImage.size.width*contentWi;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWi, contentHi)];
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:briberyBgImage];
    bgImageView.frame = [self.contentView bounds];
    bgImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:bgImageView];
    
//    UIImageView *moneyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yun_money"]];
//    moneyImageView.frame = CGRectMake(0, 0, bgImageView.width/3, bgImageView.width/3);
//    moneyImageView.center = bgImageView.center;
//    [bgImageView addSubview:moneyImageView];
    
    CGFloat buttonWi = bgImageView.width-40;
    CGFloat buttonSpace = 20;
    CGFloat buttonHi = 40;
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, bgImageView.width-space*2, (bgImageView.height-(buttonHi+buttonSpace)*2))];
    infoLabel.text = _infoText;
    infoLabel.numberOfLines = 0;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = YBLFont(18);
    [bgImageView addSubview:infoLabel];

    
    for (int i = 0; i < 2; i++) {
        NSString *buttonTitle = _buttonTitles[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, buttonWi, buttonHi);
        button.top = bgImageView.height-(2-i)*(buttonHi+buttonSpace);
        button.centerX = bgImageView.width/2;
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = YBLFont(16);
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        button.layer.cornerRadius = buttonHi/2;
        button.layer.masksToBounds = YES;
        button.backgroundColor = YBLColor(237, 195, 55, 1);
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:button];
    }
    
    self.contentView.transform = CGAffineTransformMakeScale(.1, .1);
    [UIView animateWithDuration:.6
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.contentView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

- (void)dismiss{
    [UIView animateWithDuration:.4 animations:^{
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentView.top = YBLWindowHeight;
    } completion:^(BOOL finished) {
        [briberyHudToCertificatedView removeFromSuperview];
        briberyHudToCertificatedView = nil;
    }];
}

- (void)buttonClick:(UIButton *)sender {
    NSInteger index = sender.tag-100;
    BLOCK_EXEC(self.clickBlock,index);
    [self dismiss];
}

@end

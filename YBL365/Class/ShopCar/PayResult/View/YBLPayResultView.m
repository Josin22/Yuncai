//
//  YBLPayResultView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayResultView.h"
#import "YBLSuccessAnimationView.h"
#import "POP.h"

@interface YBLPayResultView ()

@property (strong, nonatomic) YBLSuccessAnimationView *successAnimationView;

@property (strong, nonatomic) UIImageView *successimageView;

@property (strong, nonatomic) UIImageView *maskImageView;

@property (nonatomic, strong) UIView *hudView;

@end

@implementation YBLPayResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    // 遮罩层
    UIImageView *maskImageView    = [[UIImageView alloc] initWithFrame:CGRectMake((YBLWindowWidth)/2-80, space*2, 160, 60)];
    maskImageView.image           = [UIImage imageNamed:@"susses_bg"];
    [self addSubview:maskImageView];
    maskImageView.hidden          = YES;
    self.maskImageView            = maskImageView;
    
    UIImageView *successimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    successimageView.image  = [UIImage imageNamed:@"susses"];
    successimageView.center = self.maskImageView.center;
    [self addSubview:successimageView];
    self.successimageView   = successimageView;
    
    YBLSuccessAnimationView *successAnimationView     = [[YBLSuccessAnimationView alloc] initWithFrame:CGRectMake(self.successimageView.width-30,self.successimageView.height-30 ,25,25)
                                                                                             lineWidth:2.5
                                                                                           strokeColor:[UIColor whiteColor]
                                                                                        durationFinish:1.0];
    [self.successimageView addSubview:successAnimationView];
    self.successAnimationView = successAnimationView;
    
    /*文字*/
    UILabel *payWayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.successimageView.bottom+space, YBLWindowWidth, 20)];
    payWayLabel.text = @"支付方式 : XX支付";
    payWayLabel.font = YBLFont(15);
    payWayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:payWayLabel];
    self.payWayLabel = payWayLabel;
    
    UILabel *payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.payWayLabel.bottom+space, YBLWindowWidth, 20)];
    payMoneyLabel.text = @"支付金额 : ¥0.00";
    payMoneyLabel.font = YBLFont(15);
    payMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:payMoneyLabel];
    self.payMoneyLabel = payMoneyLabel;
    
    CGFloat spacr = 40;
    CGFloat buttonWi = (YBLWindowWidth-spacr*3)/2;
    CGFloat buttonHi = 35;
    
    UIButton *lookOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lookOrderButton.frame = CGRectMake(spacr, self.payMoneyLabel.bottom+space*2, buttonWi, buttonHi);
    lookOrderButton.layer.cornerRadius = 3;
    lookOrderButton.layer.masksToBounds = YES;
    lookOrderButton.layer.borderWidth = 0.5;
    lookOrderButton.layer.borderColor = YBLLineColor.CGColor;
    [lookOrderButton setTitle:@"查看订单" forState:UIControlStateNormal];
    lookOrderButton.titleLabel.font = YBLFont(13);
    [lookOrderButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self addSubview:lookOrderButton];
    self.lookOrderButton = lookOrderButton;
    
    UIButton *backHomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backHomeButton.frame = CGRectMake(lookOrderButton.right+spacr, self.lookOrderButton.top, buttonWi, buttonHi);
    backHomeButton.layer.cornerRadius = 3;
    backHomeButton.layer.masksToBounds = YES;
    backHomeButton.layer.borderWidth = 0.5;
    backHomeButton.layer.borderColor = YBLLineColor.CGColor;
    [backHomeButton setTitle:@"去首页" forState:UIControlStateNormal];
    backHomeButton.titleLabel.font = YBLFont(13);
    [backHomeButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
    [self addSubview:backHomeButton];
    self.backHomeButton = backHomeButton;
    
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backHomeButton.bottom+2*space, YBLWindowWidth, 35)];
    hudView.backgroundColor = YBLColor(214, 214, 214, 1);
    [self addSubview:hudView];
    self.hudView = hudView;
    
    self.height = self.hudView.bottom;
    
    UILabel *hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, hudView.width-2*space, hudView.height)];
    hudLabel.text = @"重要提示 : 云采平台不会以订单异常,系统升级为由要求您点击任何网址链接进行退款操作";
    hudLabel.numberOfLines = 2;
    hudLabel.font = YBLFont(11);
    hudLabel.textColor = YBLTextColor;
    [hudView addSubview:hudLabel];
    
    /*开始动画*/
    [self poke];
}

#pragma mark - 动画

- (void)poke{
    
    [self.successAnimationView starAnimationCompleteHandle:^{
        //3.放大缩小
        [self performSelector:@selector(scaleAnimation) withObject:nil afterDelay:0];
        [self performSelectorOnMainThread:@selector(showMaskImageViewAnimation) withObject:nil waitUntilDone:YES];
    }];
}

- (void)showMaskImageViewAnimation{
    //4.背景遮罩出现
    self.maskImageView.alpha = 0;
    [UIView animateWithDuration:0.8 animations:^{
        self.maskImageView.hidden = NO;
        self.maskImageView.alpha  = 1;
    }];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(6.5f, 6.5f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 25.0f;
    [self.successAnimationView.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}


@end

//
//  YBLBriberyMoneyView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBriberyMoneyView.h"

#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface YBLBriberyMoneyView ()
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *briberyMoneyTopImageView;
@property (nonatomic, strong) UIImageView *briberyMoneyBottomImageView;
@property (nonatomic, strong) UIImageView *briberyMoneyMoneyImageView;

@end

@implementation YBLBriberyMoneyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    UIView *baseView = [[UIView alloc] init];
    baseView.frame = [self bounds];
    [self addSubview:baseView];
    self.baseView = baseView;
    
    self.briberyMoneyBottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BriberyMoney_bottom"]];
    self.height = self.width*(self.briberyMoneyBottomImageView.image.size.height/self.briberyMoneyBottomImageView.image.size.width);
    self.briberyMoneyBottomImageView.frame = [self bounds];
    self.briberyMoneyBottomImageView.userInteractionEnabled = YES;
    [self.baseView addSubview:self.briberyMoneyBottomImageView];
    
    self.briberyMoneyTopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BriberyMoney_top"]];
    self.briberyMoneyTopImageView.frame = [self bounds];
    self.briberyMoneyTopImageView.userInteractionEnabled = YES;
    [self.baseView addSubview:self.briberyMoneyTopImageView];
    
    self.briberyMoneyMoneyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BriberyMoney_money"]];
    self.briberyMoneyMoneyImageView.frame = [self bounds];
    self.briberyMoneyMoneyImageView.userInteractionEnabled = YES;
    [self.baseView addSubview:self.briberyMoneyMoneyImageView];
    
    YBLButton *briberyButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    briberyButton.frame = [self.baseView bounds];
    [self.baseView addSubview:briberyButton];
    self.briberyButton = briberyButton;
}

- (void)lean{
    /*关于M_PI
     #define M_PI     3.14159265358979323846264338327950288
     其实它就是圆周率的值，在这里代表弧度，相当于角度制 0-360 度，M_PI=180度
     旋转方向为：顺时针旋转
     */
//    CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-35));
//    self.transform = transform;

    if ([self.baseView.layer animationForKey:animation_key_shake]) {
        [self.baseView.layer removeAnimationForKey:animation_key_shake];
        CABasicAnimation *a1 = [CABasicAnimation animation];
        a1.keyPath = @"transform.translation.x";
        a1.toValue = @(self.width/3+space);
        a1.duration = .5;
        a1.fillMode = kCAFillModeForwards;
        a1.removedOnCompletion = NO;
        
        CABasicAnimation *leanAnimation;
        leanAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        leanAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(-35)];
        leanAnimation.duration = .5;
        leanAnimation.fillMode = kCAFillModeForwards;
        leanAnimation.removedOnCompletion = NO;
        
        // 组动画
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[ a1, leanAnimation];
        groupAnima.fillMode = kCAFillModeForwards;
        groupAnima.removedOnCompletion = NO;
        groupAnima.duration = 1;
        [self.baseView.layer addAnimation:groupAnima forKey:nil];
    }
    
}

- (void)rotate {
    
    CABasicAnimation *rotationAnimation = [YBLMethodTools get3DRotationAnimation];
    [self.baseView.layer addAnimation:rotationAnimation forKey:animation_key_3droation];
}

- (void)shake{
    
    CABasicAnimation *shakeAnimation = [YBLMethodTools getShakeAnimation];
    //锚点设置为图片中心，绕中心抖动
    self.baseView.layer.anchorPoint = CGPointMake(0.5, 0.8);
    [self.baseView.layer addAnimation:shakeAnimation forKey:animation_key_shake];
}

- (void)showAnimationOpenBriberyOnView:(UIView *)view{
    
    [self.baseView.layer removeAllAnimations];
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint newselfPP =  [self convertPoint:self.center fromView:keyWindow];
    CGPoint newviewPP =  [self convertPoint:view.center fromView:keyWindow];
    [movePath moveToPoint:newselfPP];
    CGFloat ppx = (newselfPP.x-newviewPP.x)/2+newviewPP.x;
    CGFloat ppy = newselfPP.y-(newviewPP.y-newselfPP.y);
    [movePath addQuadCurveToPoint:newviewPP controlPoint:CGPointMake(ppx, ppy)];
    //关键帧动画（位置）
    CAKeyframeAnimation * posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.path = movePath.CGPath;
    posAnim.duration = 2;
    posAnim.removedOnCompletion = NO;
    posAnim.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *scaleAnimation = [YBLMethodTools getScaleAnimationScale:2];
    scaleAnimation.duration = 2;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *rotationAnimation = [YBLMethodTools get3DRotationAnimation];
    rotationAnimation.repeatDuration = 2;
    rotationAnimation.repeatCount = 2;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = @[posAnim, rotationAnimation,];
    animGroup.duration = 4;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    [self.baseView.layer addAnimation:animGroup forKey:nil];
}


@end

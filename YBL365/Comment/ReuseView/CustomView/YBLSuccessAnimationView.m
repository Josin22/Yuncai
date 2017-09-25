//
//  YBLSuccessAnimationView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#define kAnimationDrawSuccess  @"kAnimationDrawSuccess"

#import "YBLSuccessAnimationView.h"

@interface YBLSuccessAnimationView ()<CAAnimationDelegate>

@property (nonatomic, copy  ) AnimationCompleteBlock finishBlock;

@property (nonatomic, strong) CAShapeLayer           *successLayer;
/**
 *  线条宽度
 */
@property (nonatomic,assign ) CGFloat                lineWidth;

/**
 *  线条颜色
 */
@property (nonatomic,copy   ) UIColor                *strokeColor;
/**
 *  动画时间
 */
@property (nonatomic,assign ) CGFloat                durationFinish;

@end

@implementation YBLSuccessAnimationView

+ (instancetype)showSuccessStrokeViewWithFrame:(CGRect)frame
                                     lineWidth:(CGFloat)lineWidth
                                   strokeColor:(UIColor *)strokrColor
                                durationFinish:(CGFloat)durationFinish{
   return [[self alloc] initWithFrame:frame
                            lineWidth:lineWidth
                          strokeColor:strokrColor
                       durationFinish:durationFinish];
}

- (instancetype)initWithFrame:(CGRect)frame
                    lineWidth:(CGFloat)lineWidth
                  strokeColor:(UIColor *)strokrColor
               durationFinish:(CGFloat)durationFinish{
    
    if (self = [super initWithFrame:frame]) {
        _strokeColor    = strokrColor;
        _lineWidth      = lineWidth;
        _durationFinish = durationFinish;

        self.backgroundColor     = YBLColor(0, 207, 13, 1);
        self.layer.cornerRadius  = self.width/2;
        self.layer.masksToBounds = YES;
        
        //设置layer
        [self.layer addSublayer:self.successLayer];
    }
    return self;
}

- (void)begainAnimation{
    
    self.transform = CGAffineTransformMakeScale(1/300.0f, 1/300.0f);
    
    [UIView animateWithDuration:0.75f animations:^{
        
        self.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        
        //开始绘制
        [self drawSuccessAnimation];
        
    }];
}

- (CAShapeLayer *)successLayer{
    
    if (!_successLayer) {
        _successLayer             = [CAShapeLayer layer];
        _successLayer.fillColor   = [UIColor clearColor].CGColor;
        _successLayer.strokeColor = _strokeColor.CGColor;
        _successLayer.lineWidth   = _lineWidth;
        _successLayer.frame       = self.bounds;
        _successLayer.lineJoin    = kCALineJoinRound;
        _successLayer.lineCap     = kCALineCapRound;
    }
    return _successLayer;
}


- (void)drawSuccessAnimation {
    
    UIBezierPath* successPath = [UIBezierPath bezierPath];
    CGFloat size              = self.width;
    [successPath moveToPoint: CGPointMake(size/3.1578, size/2)];
    [successPath addLineToPoint: CGPointMake(size/2.0618, size/1.57894)];
    [successPath addLineToPoint: CGPointMake(size/1.3953, size/2.7272)];
    self.successLayer.path        = successPath.CGPath;
    
    CABasicAnimation *successAnimation   = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [successAnimation setValue:kAnimationDrawSuccess forKey:@"id"];
    successAnimation.duration            = _durationFinish;
    successAnimation.delegate            = self;
    successAnimation.fromValue           = @0;
    successAnimation.toValue             = @1;
    successAnimation.removedOnCompletion = YES;
    successAnimation.fillMode            = kCAFillModeForwards;
    successAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.successLayer addAnimation:successAnimation forKey:kAnimationDrawSuccess];
    
}
#pragma mark - Animation Delegate -
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSString* key = [anim valueForKey:@"id"];
    if ([key isEqualToString:kAnimationDrawSuccess]) {
        BLOCK_EXEC(self.finishBlock,);
    }
    
}

- (void)starAnimationCompleteHandle:(AnimationCompleteBlock)block{

    _finishBlock = block;;
    [self.successLayer removeAllAnimations];
    self.successLayer.path = nil;
    //开始动画
    [self begainAnimation];
}

@end

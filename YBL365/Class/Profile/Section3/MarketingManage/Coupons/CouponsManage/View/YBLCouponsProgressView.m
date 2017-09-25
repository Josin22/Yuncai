//
//  YBLCouponsProgressView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsProgressView.h"

@interface YBLCouponsProgressView ()
{
    CGFloat _space_circle;
    UIBezierPath *_trcakCirclePath;
    UIBezierPath *_progressCirclePath;
    CAShapeLayer *_progressLayer;
    CAShapeLayer *_trackLayer;
}

@property (nonatomic, retain) UILabel *progressLabel;

@end

@implementation YBLCouponsProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    _space_circle = 15;
    _trackColor = YBLColor(244, 212, 211, 1);
    _progressColor = YBLThemeColor;
    _progressWidth = 5.0f;
    _progress = 0;
    
    CAShapeLayer *trackLayer = [self getCircleLayer];
    trackLayer.strokeColor = _trackColor.CGColor;
    trackLayer.fillColor = [[UIColor whiteColor]CGColor];//填充颜
    _trackLayer = trackLayer;
    _trcakCirclePath = [self getCirclePath];
    _trackLayer.path = _trcakCirclePath.CGPath;
    
    CAShapeLayer *progressLayer = [self getCircleLayer];
    progressLayer.strokeColor = _progressColor.CGColor;//画线颜色
    progressLayer.fillColor = [[UIColor clearColor]CGColor];//填充颜
    _progressLayer = progressLayer;
    _progressCirclePath = [self getCirclePath];
    _progressLayer.path = _progressCirclePath.CGPath;

    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-_space_circle*2-_progressWidth*2, self.height/2)];
    self.progressLabel.center = self.center;
    self.progressLabel.textColor = YBLThemeColor;
    self.progressLabel.font = YBLFont(13);
    self.progressLabel.numberOfLines = 0;
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.progressLabel];
    
}

- (CAShapeLayer *)getCircleLayer{
    
    CAShapeLayer * pathLayer = [CAShapeLayer layer];
    pathLayer.frame = [self bounds];
//    pathLayer.lineJoin = kCALineJoinRound;
    pathLayer.lineCap = kCALineCapRound;
    pathLayer.lineWidth = _progressWidth;
    [self.layer addSublayer:pathLayer];
    
    return pathLayer;
}

- (UIBezierPath *)getCirclePath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    //参数依次是：圆心坐标，半径，开始弧度，结束弧度   画线方向：yes为顺时针，no为逆时针
    [path addArcWithCenter:self.center radius:(self.width)/2-_space_circle startAngle:DEGREES_TO_RADIANS(135) endAngle:DEGREES_TO_RADIANS(360+45+90) clockwise:TRUE];
    return path;
}

- (void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
    _trackLayer.strokeColor = _progressColor.CGColor;//填充颜
}

- (void)setTrackColor:(UIColor *)trackColor{
    _trackColor = trackColor;
    _progressLayer.strokeColor = _trackColor.CGColor;//填充颜
}

- (void)setProgressWidth:(CGFloat)progressWidth{
    _progressWidth = progressWidth;
    _progressLayer.lineWidth = _progressWidth;
    _trackLayer.lineWidth = _progressWidth;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    [self showAnimation];
    
    self.progressLabel.text = [NSString stringWithFormat:@"已抢\n%.0f﹪",_progress*100];
}

- (void)showAnimation{
    
    [_progressLayer removeAllAnimations];//每次将之前的动画都清除了
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.5;
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(_progress);
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end

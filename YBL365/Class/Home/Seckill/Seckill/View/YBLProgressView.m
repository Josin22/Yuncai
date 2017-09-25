//
//  YBLProgressView.m
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLProgressView.h"

static NSString *const kAnimationDrawLine = @"kAnimationDrawLine";

static CGFloat const layRadiu = 3;

static CGFloat const bordeWidth = 0.7;

@interface YBLProgressView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation YBLProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpLayer];
    }
    return self;
}

- (void)setUpLayer{
    //
    self.layer.cornerRadius = layRadiu;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = bordeWidth;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    [self addSubview:self.bgImageView];
    //默认颜色
    _fillColor = YBLThemeColor;//253 ,175 176
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = _fillColor.CGColor;
    _progressLayer.lineWidth = self.bounds.size.height-bordeWidth*2;
    _progressLayer.frame = self.bounds;
    _progressLayer.lineJoin = kCALineJoinBevel;
    _progressLayer.lineCap = kCALineCapButt;
    [self.layer addSublayer:_progressLayer];
    
}

- (void)setNewfillColor:(UIColor *)newfillColor{
    _newfillColor = newfillColor;
    _progressLayer.strokeColor = _newfillColor.CGColor;
}

- (void)setFillColor:(UIColor *)fillColor{
    
    _fillColor = fillColor;
    _progressLayer.strokeColor = fillColor.CGColor;
    self.layer.borderColor = fillColor.CGColor;
    
}

- (void)loading:(float)value{
    
    [_progressLayer removeAllAnimations];
    _progressLayer.path = nil;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGFloat sizeW = self.bounds.size.width;
    CGFloat sizeH = self.bounds.size.height;
    [linePath moveToPoint:CGPointMake(0, sizeH/2)];
    [linePath addLineToPoint:CGPointMake(sizeW*value, sizeH/2)];
    _progressLayer.path = linePath.CGPath;
    
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [lineAnimation setValue:kAnimationDrawLine forKey:@"id"];
    lineAnimation.duration = 1.0f;
    lineAnimation.fromValue = @0;
    lineAnimation.toValue = @1;
    lineAnimation.removedOnCompletion = NO;
    lineAnimation.fillMode = kCAFillModeForwards;
    lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_progressLayer addAnimation:lineAnimation forKey:kAnimationDrawLine];

}

@end

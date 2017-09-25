//
//  JSWave.m
//  JSWaveDemo
//
//  Created by 乔同新 on 16/8/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//  Github  Demo  ::  https://github.com/Josin22/JSWave/

#import "JSWave.h"

@interface JSProxy : NSObject
@property (weak, nonatomic) id executor;
@end

@implementation JSProxy

-(void)callback {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [_executor performSelector:@selector(wave)];
    
#pragma clang diagnostic pop
}

@end

@interface JSWave ()

@property (nonatomic, strong) CADisplayLink *timer;

@property (nonatomic, strong) CAShapeLayer *wave1Layer;

@property (nonatomic, strong) CAShapeLayer *wave2Layer;

@property (nonatomic, strong) CAShapeLayer *wave3Layer;

@property (nonatomic, strong) CAGradientLayer *bgGradientLayer;

@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, strong) UIColor *wave1Color;


@end

@implementation JSWave

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self initData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    //初始化
    self.waveSpeed = 0.5;
    self.waveCurvature = 1.5;
    self.waveHeight = 4;
    self.wave1Color = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    //
    self.bgGradientLayer.colors = @[(id)YBLThemeColor.CGColor,
                                    (id)YBLColor(245, 50, 50, 1).CGColor,
                                    (id)YBLColor(245, 55, 55, 1).CGColor,
                                    (id)YBLColor(245, 60, 60, 1).CGColor,
                                    (id)YBLColor(245, 70, 70, 1).CGColor,
                                    (id)YBLColor(245, 80, 80, 1).CGColor,
                                    (id)YBLColor(245, 100, 100, 1).CGColor,
                                    (id)YBLColor(245, 120, 120, 1).CGColor,
                                    (id)YBLColor(245, 140, 140, 1).CGColor,
                                    (id)YBLColor(245, 190, 190, 1).CGColor,
                                    (id)YBLColor(255, 255, 255, 1).CGColor,];
    
   [self.timer setPaused:YES];
}

- (CAGradientLayer *)bgGradientLayer{
    if (!_bgGradientLayer) {
        _bgGradientLayer = [CAGradientLayer layer];
        _bgGradientLayer.frame = self.bounds;
        _bgGradientLayer.startPoint = CGPointMake(.5, 0);
        _bgGradientLayer.endPoint = CGPointMake(.5, 1);
//        _bgGradientLayer.locations = @[@(0.3f) ,@(0.85f),@(.95)];
        [self.layer addSublayer:_bgGradientLayer];
    }
    return _bgGradientLayer;
}

- (CAShapeLayer *)wave1Layer{
    
    if (!_wave1Layer) {
        _wave1Layer = [self getWaveLayer];
        [self.layer addSublayer:_wave1Layer];
    }
    return _wave1Layer;
}

- (CAShapeLayer *)wave2Layer{
    
    if (!_wave2Layer) {
        _wave2Layer = [self getWaveLayer];
        [self.layer addSublayer:_wave2Layer];
    }
    return _wave2Layer;
}

- (CAShapeLayer *)wave3Layer{
    if (!_wave3Layer) {
        _wave3Layer = [self getWaveLayer];
        [self.layer addSublayer:_wave3Layer];
    }
    return _wave3Layer;
}

- (CAShapeLayer *)getWaveLayer{
    
    CAShapeLayer *waveLayer = [CAShapeLayer layer];
    CGRect frame = [self bounds];
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    waveLayer.frame = frame;
    waveLayer.fillColor = self.wave1Color.CGColor;
    return waveLayer;
}

- (CADisplayLink *)timer{
    if (!_timer) {
        JSProxy *proxy = [[JSProxy alloc] init];
        proxy.executor = self;
        _timer = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(callback)];
        [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)setWaveHeight:(CGFloat)waveHeight{
    _waveHeight = waveHeight;
    
    CGRect frame = [self bounds];
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    _wave1Layer.frame = frame;
    
    CGRect frame1 = [self bounds];
    frame1.origin.y = frame1.size.height-self.waveHeight;
    frame1.size.height = self.waveHeight;
    _wave2Layer.frame = frame1;
    
}

- (void)startWaveAnimation{
    
    self.timer.paused = NO;
}

- (void)stopWaveAnimation{

    self.timer.paused = YES;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)wave{
    
    self.offset += self.waveSpeed;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.waveHeight;
    
    //path1
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, height);
    CGFloat path1y = 0.f;
    //path2
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, 0, height);
    CGFloat path2Y = 0.f;
    //path2
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, NULL, 0, height);
    CGFloat path3Y = 0.f;
    
    for (CGFloat x = 0.f; x <= width ; x++) {
        path1y = height * sinf([self getSinfWithPercent:5.0f widthX:x]);
        CGPathAddLineToPoint(path1, NULL, x, path1y);
        
        path2Y = height * sinf([self getSinfWithPercent:3.2f widthX:x]);
        CGPathAddLineToPoint(path2, NULL, x, path2Y);
    
        path3Y = height * sinf([self getSinfWithPercent:2.0f widthX:x]);
        CGPathAddLineToPoint(path3, NULL, x, path3Y);
    }
    
    //变化的中间Y值
    CGFloat centX = self.bounds.size.width/2;
    CGFloat CentY = height * sinf(0.01 * self.waveCurvature *centX  + self.offset * 0.045);
    if (self.waveBlock) {
        self.waveBlock(CentY);
    }
    
    CGPathAddLineToPoint(path1, NULL, width, height);
    CGPathAddLineToPoint(path1, NULL, 0, height);
    CGPathCloseSubpath(path1);
    self.wave1Layer.path = path1;
    self.wave1Layer.fillColor = self.wave1Color.CGColor;
    CGPathRelease(path1);
    
    CGPathAddLineToPoint(path2, NULL, width, height);
    CGPathAddLineToPoint(path2, NULL, 0, height);
    CGPathCloseSubpath(path2);
    self.wave2Layer.path = path2;
    self.wave2Layer.fillColor = self.wave1Color.CGColor;
    CGPathRelease(path2);
    
    CGPathAddLineToPoint(path3, NULL, width, height);
    CGPathAddLineToPoint(path3, NULL, 0, height);
    CGPathCloseSubpath(path3);
    self.wave3Layer.path = path3;
    self.wave3Layer.fillColor = self.wave1Color.CGColor;
    CGPathRelease(path3);
    
}

- (float)getSinfWithPercent:(float)percent widthX:(CGFloat)widthX{
    return (self.waveCurvature * widthX + self.offset * percent)/100;
}

@end

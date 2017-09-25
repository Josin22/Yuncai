//
//  YBLLogLoadingView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLogLoadingView.h"

@interface YBLLogLoadingView ()
{
    CADisplayLink *_disPlayLink;
    /**
     曲线的振幅
     */
    CGFloat _waveAmplitude;
    /**
     曲线角速度
     */
    CGFloat _wavePalstance;
    /**
     曲线初相
     */
    CGFloat _waveX;
    /**
     曲线偏距
     */
    CGFloat _waveY;
    /**
     曲线移动速度
     */
    CGFloat _waveMoveSpeed;
    
    //背景发暗的图片 蓝底白字
    UIImageView *_imageView1;
    
    //前面正常显示的图片 蓝底白字
    UIImageView *_imageView2;
    
    //动画的容器
    UIView *_container;
}
@end

@implementation YBLLogLoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
        [self buildData];
    }
    return self;
}

-(void)createUI
{
    //圆
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50*SCREEN_SCALE, 50*SCREEN_SCALE)];
    _container.center = self.center;
    _container.backgroundColor = [UIColor whiteColor];
    _container.layer.cornerRadius = _container.width/2.0f;
    _container.layer.masksToBounds = true;
    [self addSubview:_container];

    //底部图片白底蓝字
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_container.bounds];
    imageView.image = [UIImage imageNamed:@"hud_cai_red"];
    [_container addSubview:imageView];
    
    //上层图片蓝底白字
    _imageView1 = [[UIImageView alloc] initWithFrame:_container.bounds];
    _imageView1.image = [UIImage imageNamed:@"hud_cai_wihte"];
    _imageView1.backgroundColor = YBLThemeColor;
    [_container addSubview:_imageView1];
    
    UIView *view = [[UIView alloc] initWithFrame:_imageView1.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [_imageView1 addSubview:view];
    
    //下层图片白底蓝字
    _imageView2 = [[UIImageView alloc] initWithFrame:_container.bounds];
    _imageView2.image = [UIImage imageNamed:@"hud_cai_wihte"];
    _imageView2.backgroundColor = YBLThemeColor;
    [_container addSubview:_imageView2];
}

//初始化数据
-(void)buildData
{
    //振幅
    _waveAmplitude = 3;
    //角速度
    _wavePalstance = 0.12;
    //偏距
    _waveY = _container.height;
    //初相
    _waveX = 0;
    //x轴移动速度
    _waveMoveSpeed = 0.15;
    //y轴偏移量
    _waveY = _container.height/2.0f;
    //以屏幕刷新速度为周期刷新曲线的位置
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave)];
    [_disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _disPlayLink.paused = true;
}

-(void)updateWave
{
    _waveX -= _waveMoveSpeed;
    [self updateWave1];
    [self updateWave2];
}

-(void)updateWave1
{
    //波浪宽度
    CGFloat waterWaveWidth = _container.bounds.size.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX + 1) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _container.height);
    CGPathAddLineToPoint(path, nil, 0, _container.height);
    CGPathCloseSubpath(path);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    _imageView1.layer.mask = layer;
    CGPathRelease(path);
}

-(void)updateWave2
{
    //波浪宽度
    CGFloat waterWaveWidth = _container.width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //添加终点路径、填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _container.height);
    CGPathAddLineToPoint(path, nil, 0, _container.height);
    CGPathCloseSubpath(path);
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path;
    _imageView2.layer.mask = layer;
    CGPathRelease(path);
}

#pragma mark -
#pragma mark 显示/隐藏方法

-(void)show{
    _disPlayLink.paused = false;
}

-(void)dismiss{
    _disPlayLink.paused = true;
}

+(void)showInView:(UIView *)view{
    
    YBLLogLoadingView *loading = [[YBLLogLoadingView alloc] initWithFrame:view.bounds];
    [loading show];
    [view addSubview:loading];
}

+(void)dismissInView:(UIView *)view{
    
    for (YBLLogLoadingView *loading in view.subviews) {
        if ([loading isKindOfClass:[YBLLogLoadingView class]]) {
            [UIView animateWithDuration:.3 animations:^{
                    loading.alpha = 0;
            }
                             completion:^(BOOL finished) {
                                 [loading dismiss];
                                 [loading removeFromSuperview];
                             }];
        }
    }
}

+ (void)showInWindow{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self showInView:keyWindow];
}

+ (void)dismissInWindow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self dismissInView:keyWindow];
}

-(void)dealloc
{
    if (_disPlayLink) {
        [_disPlayLink invalidate];
        _disPlayLink = nil;
    }
    
    if (_imageView1) {
        [_imageView1 removeFromSuperview];
        _imageView1 = nil;
    }
    if (_imageView2) {
        [_imageView2 removeFromSuperview];
        _imageView2 = nil;
    }
}

@end

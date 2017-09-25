//
//  YBLScanQRCodeAnimationView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLScanQRCodeAnimationView.h"
#import <AVFoundation/AVFoundation.h>

@interface YBLScanQRCodeAnimationView ()
{
    CGFloat middleHi;
}
@property (nonatomic, strong) CADisplayLink *displayLink; /**< 定时器*/
@property (nonatomic, strong) UIView *scanImageView;
 /**< 扫描区域背景图片*/
@property (nonatomic, strong) UIImageView *scanTopImageView;
@property (nonatomic, strong) UIImageView *scanMiddleImageView;
@property (nonatomic, strong) UIImageView *scanBottomImageView;

@property (nonatomic, strong) UIImageView *scanLineImageView; /**< 扫描线*/

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIButton *lightBtn;

@property (nonatomic, assign) CGFloat scanX; /**< 扫描区域的X值*/
@property (nonatomic, assign) CGFloat scanY; /**< 扫描区域的Y值*/

@property (nonatomic, strong) AVCaptureDevice *device; /**< 设备*/

@end

@implementation YBLScanQRCodeAnimationView

#pragma mark -- 初始化


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDatas];
    }
    return self;
}


- (void)initDatas
{
    self.backgroundColor = [UIColor clearColor];
    self.scanX = (Scan_Width - ScanW) / 2.0;
    self.scanY = self.height/4;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [self addSubview:self.scanImageView];
    [self addSubview:self.maskView];
    [self.scanImageView addSubview:self.scanTopImageView];
    [self.scanImageView addSubview:self.scanMiddleImageView];
    [self.scanImageView addSubview:self.scanBottomImageView];
    [self.scanImageView addSubview:self.textFeild];
    
    [self setupSubivews];
}

#pragma mark -- 画扫描区域和非扫描区域

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();;

    // 颜色
    [[[UIColor blackColor] colorWithAlphaComponent:0.4] setFill];
    // 上侧
    CGContextAddRect(context, CGRectMake(0, 0, Scan_Width, self.scanY+4));
    // 左侧
    CGContextAddRect(context, CGRectMake(0, self.scanY+4, self.scanX+4, ScanW));
    // 下侧
    CGContextAddRect(context, CGRectMake(0, self.scanY+ScanW-4, Scan_Width, Scan_Height - (self.scanY+ScanW-4)));
    //右侧
    CGContextAddRect(context, CGRectMake((self.scanX+ScanW-4), self.scanY, Scan_Width, ScanW));
    CGContextFillPath(context);
    // 扫描区域(可以直接放一张图片，也可以自己画出来)
    
    
#if 1

#else
    CGContextSetLineWidth(context, 2);
    [[UIColor whiteColor] setStroke];
    // 左上角
    CGContextMoveToPoint(context, self.scanX, self.scanY + Scan_Angle_Width);
    CGContextAddLineToPoint(context, self.scanX, self.scanY);
    CGContextAddLineToPoint(context, self.scanX + Scan_Angle_Width, self.scanY);
    // 右上角
    CGContextMoveToPoint(context, self.scanX + ScanW - Scan_Angle_Width, self.scanY);
    CGContextAddLineToPoint(context, self.scanX + ScanW, self.scanY);
    CGContextAddLineToPoint(context, self.scanX + ScanW, self.scanY + Scan_Angle_Width);
    // 右下角
    CGContextMoveToPoint(context, self.scanX + ScanW, self.scanY + ScanW - Scan_Angle_Width);
    CGContextAddLineToPoint(context, self.scanX + ScanW, self.scanY + ScanW);
    CGContextAddLineToPoint(context, self.scanX + ScanW - Scan_Angle_Width, self.scanY + ScanW);
    // 左下角
    CGContextMoveToPoint(context, self.scanX + Scan_Angle_Width, self.scanY + ScanW);
    CGContextAddLineToPoint(context, self.scanX, self.scanY + ScanW);
    CGContextAddLineToPoint(context, self.scanX, self.scanY + ScanW - Scan_Angle_Width);
    
    CGContextStrokePath(context);
    
    CGContextRef context1 = UIGraphicsGetCurrentContext();;
    //内框
    CGContextSetLineWidth(context1, 0.5);
    [YBLLineColor setStroke];
    CGContextMoveToPoint(context1, self.scanX+3, self.scanY+3);
    CGContextAddLineToPoint(context1, self.scanX+ScanW-3, self.scanY+3);
    CGContextAddLineToPoint(context1, self.scanX+ScanW-3, self.scanY+ScanW-3);
    CGContextAddLineToPoint(context1, self.scanX+3, self.scanY+ScanW-3);
    CGContextAddLineToPoint(context1, self.scanX+3, self.scanY+3);
    
//    [[UIColor whiteColor] setFill];
//    CGContextFillPath(context1);
    
    CGContextStrokePath(context1);
    
#endif
    
    
}

/** 创建子视图*/
- (void)setupSubivews
{
    /*
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, space*3, 100, 30)];
    titleLabel.text = @"扫一扫";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.centerX = self.width/2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(19);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(space, titleLabel.top, 40, 40);;
    backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.25];
    backButton.layer.cornerRadius = 20;
    backButton.layer.masksToBounds = YES;
    [backButton setImage:[UIImage imageNamed:@"back_bt_7h"] forState:UIControlStateNormal];
    [self addSubview:backButton];
    self.backButton = backButton;
    
    UIButton *histoyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [histoyButton setImage:[UIImage imageNamed:@"newbarcode_historyempty_icon"] forState:UIControlStateNormal];
    histoyButton.frame = CGRectMake(0, titleLabel.top, 40, 40);
    histoyButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.25];
    histoyButton.right = self.width-space;
    histoyButton.layer.cornerRadius = 20;
    histoyButton.layer.masksToBounds = YES;
    [self addSubview:histoyButton];
    self.histoyButton = histoyButton;
     */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.scanImageView.top-30, Scan_Width - 20*2, 20)];
    label.text = @"对准二维码/条形码到框内即可扫描";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
    
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame = CGRectMake(0, 0 + 30, 40, 40);
    lightBtn.center = CGPointMake(YBLWindowWidth/2, self.scanImageView.bottom+40);
    [lightBtn setImage:[UIImage newImageWithNamed:@"newbarcode_light_off" size:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    [lightBtn setImage:[UIImage newImageWithNamed:@"newbarcode_light_on" size:CGSizeMake(25, 25)] forState:UIControlStateSelected];
    [lightBtn setBackgroundColor:YBLColor(40, 40, 40, 0.6) forState:UIControlStateNormal];
    [lightBtn setBackgroundColor:YBLColor(40, 40, 40, 0.6) forState:UIControlStateSelected];
    lightBtn.layer.cornerRadius = 20;
    lightBtn.layer.masksToBounds = YES;
    [lightBtn addTarget:self action:@selector(touchLightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lightBtn];
    self.lightBtn = lightBtn;
    
    CGFloat wi = 120;
    CGFloat hi = 40;
    
    YBLButton *writeMButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    writeMButton.frame = CGRectMake(0, 0, wi, hi);
    writeMButton.center = CGPointMake(lightBtn.centerX, lightBtn.centerY+hi*2);
    [writeMButton setImage:[UIImage imageNamed:@"newbarcode_shurutiaoma_icon"] forState:UIControlStateNormal];
    [writeMButton setTitle:@"输入条形码" forState:UIControlStateNormal];
    writeMButton.titleLabel.font = YBLFont(12);
    writeMButton.layer.cornerRadius = hi/2;
    writeMButton.layer.masksToBounds = YES;
    [writeMButton setBackgroundColor:YBLColor(40, 40, 40, 0.4)];
    writeMButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [writeMButton setTitleColor:YBLColor(122, 122, 122, 1) forState:UIControlStateNormal];
    [writeMButton setTitleRect:CGRectMake(hi/2+hi/2+5, 0, wi-(hi/2+hi/2+5), hi)];
    [writeMButton setImageRect:CGRectMake(hi/2, 10, hi/2, hi/2)];

    [self addSubview:writeMButton];
    self.writeMButton = writeMButton;
    
    YBLButton *changeMButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    changeMButton.frame = CGRectMake(2*space, self.scanY+40+40, wi, hi);
//    changeMButton.center = CGPointMake(lightBtn.centerX, lightBtn.centerY+hi);
    [changeMButton setImage:[UIImage imageNamed:@"newbarcode_switchscan_icon"] forState:UIControlStateNormal];
    [changeMButton setTitle:@"切换扫码" forState:UIControlStateNormal];
    changeMButton.titleLabel.font = YBLFont(12);
    changeMButton.layer.cornerRadius = hi/2;
    changeMButton.layer.masksToBounds = YES;
    [changeMButton setBackgroundColor:YBLColor(40, 40, 40, 0.4)];
    changeMButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [changeMButton setTitleColor:YBLColor(122, 122, 122, 1) forState:UIControlStateNormal];
    [changeMButton setTitleRect:CGRectMake(hi/2+hi/2+5, 0, wi-(hi/2+hi/2+5), hi)];
    [changeMButton setImageRect:CGRectMake(hi/2, 10, hi/2, hi/2)];
    changeMButton.hidden = YES;

    [self addSubview:changeMButton];
    self.changeMButton = changeMButton;
    
    YBLButton *sureButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(YBLWindowWidth-2*space-wi, changeMButton.top, wi, hi);
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    sureButton.titleLabel.font = YBLFont(15);
    sureButton.layer.cornerRadius = hi/2;
    sureButton.layer.masksToBounds = YES;
    [sureButton setBackgroundColor:YBLColor(40, 40, 40, 0.4) forState:UIControlStateDisabled];
    [sureButton setTitleColor:YBLColor(145, 145, 145, 1) forState:UIControlStateDisabled];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setBackgroundColor:YBLColor(31, 132, 248, 1) forState:UIControlStateNormal];
    sureButton.enabled = NO;
    sureButton.hidden = YES;
    [self addSubview:sureButton];
    self.sureButton = sureButton;
    RAC(self.sureButton,enabled) = [RACSignal combineLatest:@[self.textFeild.rac_textSignal]
                                                     reduce:^(NSString *string){
                                                         return @(string.length>0);
                                                     }];
}

- (void)isShowTextField:(BOOL)isShow{
    if (isShow) {
        [self endScanAnimation];
    } else {
        [self startScanAnimation];
    }
    
    self.textFeild.text = nil;
    self.scanLineImageView.hidden = isShow;
    self.textFeild.hidden = !isShow;
    self.writeMButton.hidden = isShow;
    self.lightBtn.hidden = isShow;
    if (isShow) {
        [self.textFeild becomeFirstResponder];
    } else {
        [self.textFeild resignFirstResponder];
    }
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if (isShow) {
                             self.scanMiddleImageView.height = 16;
                             self.scanBottomImageView.top = self.scanMiddleImageView.bottom;
                         } else {

                             self.scanMiddleImageView.height = middleHi;
                             self.scanBottomImageView.top = self.scanMiddleImageView.bottom;
                         }
                         self.maskView.hidden = !isShow;
                         self.changeMButton.hidden = !isShow;
                         self.sureButton.hidden = !isShow;
                     }
                     completion:^(BOOL finished) {


                         
                     }];

    
}

#pragma mark -- 打开或关闭闪光灯
- (void)touchLightBtn:(UIButton *)btn
{
    if(![self.device hasTorch] || ![self.device hasFlash]) return;
    
    [self.device lockForConfiguration:nil];
    if(btn.selected == NO)
    {
        btn.selected = YES;
        [self.device setTorchMode:AVCaptureTorchModeOn];
        [self.device setFlashMode:AVCaptureFlashModeOn];
    }
    else
    {
        btn.selected = NO;
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device setFlashMode:AVCaptureFlashModeOff];
    }
    [self.device unlockForConfiguration];
}

#pragma mark -- 扫描动画

// 开始动画
- (void)startScanAnimation
{
    [self addSubview:self.scanLineImageView];
    if(self.displayLink == nil)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scanAnimation:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

// 定时器加载动画
- (void)scanAnimation:(CADisplayLink *)link
{
    
    CGRect scanLineFrame = self.scanLineImageView.frame;
    // 超过背景图片范围 则重头来过
    CGFloat hi = self.scanLineImageView.image.size.height;
    if (scanLineFrame.origin.y + hi+3 > CGRectGetMaxY(self.scanImageView.frame))
    {
        scanLineFrame.origin.y = self.scanY-hi/2;
    }
    else //未超过
    {
        scanLineFrame.origin.y += 2;
    }
    self.scanLineImageView.frame = scanLineFrame;
}

// 结束动画
- (void)endScanAnimation
{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark -- getter

- (UIView *)scanImageView
{
    if(!_scanImageView)
    {
        _scanImageView = [[UIView alloc] init];
        _scanImageView.backgroundColor = [UIColor clearColor];
        _scanImageView.frame = CGRectMake(self.scanX, self.scanY, ScanW, ScanW);
    }
    return _scanImageView;
}

- (UIImageView *)scanTopImageView{
    
    if (!_scanTopImageView) {
        UIImage *topImage = [UIImage imageNamed:@"newbarcode_scan_box_top"];
        _scanTopImageView = [[UIImageView alloc] initWithImage:topImage];
        _scanTopImageView.frame = CGRectMake(0, 0, self.scanImageView.width, (double)topImage.size.height/topImage.size.width*self.scanImageView.width);
    }
    return _scanTopImageView;
}
- (UIImageView *)scanMiddleImageView{
    
    if (!_scanMiddleImageView) {
        UIImage *midImage = [UIImage imageNamed:@"newbarcode_scan_box_mid"];
        _scanMiddleImageView = [[UIImageView alloc] initWithImage:midImage];
        middleHi =  self.scanImageView.height-self.scanTopImageView.height-self.scanBottomImageView.height;
        _scanMiddleImageView.frame = CGRectMake(0, self.scanTopImageView.bottom, self.scanImageView.width,middleHi);
    }
    return _scanMiddleImageView;
}
- (UIImageView *)scanBottomImageView{
    
    if (!_scanBottomImageView) {
        UIImage *bottomImage = [UIImage imageNamed:@"newbarcode_scan_box_bottom"];
        _scanBottomImageView = [[UIImageView alloc] initWithImage:bottomImage];
        CGFloat hi = (double)bottomImage.size.height/bottomImage.size.width*self.scanImageView.width;
        _scanBottomImageView.frame = CGRectMake(0, self.scanImageView.height-hi, self.scanImageView.width, hi);
    }
    return _scanBottomImageView;
}

- (UIImageView *)scanLineImageView
{
    if(!_scanLineImageView)
    {
        UIImage *lineImage = [UIImage imageNamed:@"newbarcode_scan_line"];
        _scanLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scanX+3, self.scanY, ScanW-6, lineImage.size.height)];
        _scanLineImageView.image = lineImage;
    }
    return _scanLineImageView;
}

- (UITextField *)textFeild{
    
    if (!_textFeild) {
        CGFloat hi = 4;
        _textFeild = [[SMTextField alloc] initWithFrame:CGRectMake(hi, hi, self.scanImageView.width-hi*2, 40)];
        _textFeild.borderStyle = UITextBorderStyleNone;
        _textFeild.backgroundColor = [UIColor whiteColor];
        _textFeild.font = YBLFont(16);
        _textFeild.textColor = YBLColor(40, 40, 40, 1);
        _textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textFeild.placeholder = @"请输入条形码";
        _textFeild.keyboardType = UIKeyboardTypePhonePad;
        _textFeild.hidden = YES;
    }
    return _textFeild;
}

- (UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(self.scanX+4, self.scanY+self.scanTopImageView.height+16+self.scanBottomImageView.height, ScanW-8, self.scanImageView.height-self.scanTopImageView.height-16-self.scanBottomImageView.height-4.0)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _maskView.hidden = YES;
    }
    return _maskView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

}

@end


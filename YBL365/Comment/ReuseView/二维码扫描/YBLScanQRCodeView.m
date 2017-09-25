//
//  YBLScanQRCodeView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLScanQRCodeView.h"
#import <AVFoundation/AVFoundation.h>


@interface YBLScanQRCodeView ()<AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session; /**< 执行输入设置和输出设备之间的数据传递*/
@property (nonatomic, strong) AVCaptureDevice *device; /**< 设备*/
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput; /**< 输入流*/
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput; /**< 照片输出流,二维码/条形码*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; /**< 预览图层,显示相机拍摄到的画面*/

@property (nonatomic, strong) UIImagePickerController *imagePicker; /**< 相册*/

@end

@implementation YBLScanQRCodeView

#pragma mark -- 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initDatas];
    }
    return self;
}

- (void)initDatas
{
    if(![self authorizationOpenCamera]) return;
    
    // 获取摄像头
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 初始化会话对象
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 创建输入流、输出流
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    
    self.metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理 在主线程中刷新
    [self.metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置扫描区域 注意:每一个取值0～1表示比例，以***横屏左上角(也就是竖屏右上角)***为坐标原点
    // 所以换算到竖屏时x和y的值要互换计算比例, 宽高也一样
    // 若感觉扫码灵敏度不够或距离太远，可将宽高放大一点
    CGFloat scanX = (self.frame.size.width - ScanW) / 2.0;
    CGFloat scanY = scanX;
    self.metadataOutput.rectOfInterest = CGRectMake((scanY + kNavigationbarHeight)/YBLWindowHeight, scanX/YBLWindowWidth, ScanW/YBLWindowHeight, ScanW/YBLWindowWidth);
    
    // 添加会话输入、会话输出
    if ([self.session canAddInput:self.videoInput])
    {
        [self.session addInput:self.videoInput];
    }
    if([self.session canAddOutput:self.metadataOutput])
    {
        [self.session addOutput:self.metadataOutput];
    }
    
    // 设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code];
}

#pragma mark -- 授权打开摄像头

/** 授权打开摄像头*/
- (BOOL)authorizationOpenCamera
{
    __block BOOL successAuth = NO;
    // 设置扫码支持的编码格式metadataObjectTypes 要在iOS7之后才能用
    if ([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
    {
        AVAuthorizationStatus cameraAuth = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (cameraAuth == AVAuthorizationStatusAuthorized)
        {
            successAuth = YES;
        }
        else if (cameraAuth == AVAuthorizationStatusNotDetermined)
        {
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            // 授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                successAuth = granted;
                dispatch_semaphore_signal(sema);
            }];
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在设置-隐私-相机中设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            successAuth = NO;
        }
    }
    return successAuth;
}

#pragma mark -- 读取二维码
// 开始扫码
- (void)startReadQRCode
{
    // 实例化预览图层
    if (self.previewLayer == nil)
    {
        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [self.layer setMasksToBounds:YES];
        
        self.previewLayer.frame = self.bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.layer insertSublayer:self.previewLayer atIndex:0];
    }
    if(self.session)
    {
        [self.session startRunning];
    }
}

// 结束扫码
- (void)endReadQRCode
{
    // 扫码成功后就停止扫码
    [self pauseCode];
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
}

- (void)pauseCode{
    [self.session stopRunning];
}

#pragma mark -- AVCaptureMetadataOutputObjectsDelegate

// 获取二维码或条形码中内容
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if(metadataObjects.count == 0) return;
    
    AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
    NSString *contentString = nil;
    if (obj.stringValue)
    {
        contentString = obj.stringValue;
    }
    else
    {
        contentString = @"无法识别此二维码或条形码";
    }
    // 代理返回二维码或条形码中内容
    if ([self.delegate respondsToSelector:@selector(sendQRCodeContent:)])
    {
        [self.delegate sendQRCodeContent:contentString];
    }
}


#pragma mark -- 从相册中获取二维码
//进入相册
- (void)recognizeQRcodeFromAlbum
{
    if([UIDevice currentDevice].systemVersion.intValue < 8.0) return;
    // 授权进入相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [currentVC presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

// 代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    // iOS8之后,官方提供API识别图片中的二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    // 从相册选取的照片
    UIImage *selectImage = info[UIImagePickerControllerOriginalImage];
    // 获取识别结果
    NSArray *results = [detector featuresInImage:[CIImage imageWithCGImage:selectImage.CGImage]];
    
    if(results.count > 0)
    {
        for(CIQRCodeFeature *feature in results)
        {
            if([self.delegate respondsToSelector:@selector(sendQRCodeContent:)])
            {
                [self.delegate sendQRCodeContent:feature.messageString];
            }
        }
    }
    // 界面跳转
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [currentVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- getter

- (UIImagePickerController *)imagePicker
{
    if(!_imagePicker)
    {
        _imagePicker = [[UIImagePickerController alloc] init];
        // 表示仅仅从相册中选取照片
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}



@end

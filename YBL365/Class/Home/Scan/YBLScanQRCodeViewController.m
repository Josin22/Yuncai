//
//  YBLScanQRCodeViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLScanQRCodeViewController.h"
#import "YBLScanQRCodeView.h"
#import "YBLScanContentViewController.h"
#import "IQKeyboardManager.h"
#import "YBLScanRecordsViewController.h"
#import "YBLCustomNavgationBar.h"
#import "YBLGoodsDetailViewModel.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLScanRecordsModel.h"

@interface YBLScanQRCodeViewController ()<YBLScanQRCodeViewDelegate>

@property (nonatomic, strong) YBLScanQRCodeAnimationView *scanView; /**< 扫描区域*/
@property (nonatomic, strong) YBLScanQRCodeView *scanQRCodeView; /**< 读取二维码内容*/

@property (nonatomic, strong) YBLCustomNavgationBar *customBar;

@end

@implementation YBLScanQRCodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view endEditing:YES];

    [self.navigationController setIsPopGestureRecognizerEnable:NO];

    [self.scanView startScanAnimation];
    
    [self.scanQRCodeView startReadQRCode];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.view addSubview:self.scanQRCodeView];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.customBar];
    
    [self.scanView startScanAnimation];
    [self.scanQRCodeView startReadQRCode];
    
    
}

- (YBLCustomNavgationBar *)customBar{
    
    if (!_customBar) {
        _customBar = [[YBLCustomNavgationBar alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        _customBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.0];
        _customBar.backButton.layer.cornerRadius = _customBar.backButton.height/2;
        _customBar.backButton.layer.masksToBounds = YES;
        _customBar.backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        
        UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [historyButton setImage:[UIImage imageNamed:@"newbarcode_historyempty_icon"] forState:UIControlStateNormal];
        historyButton.frame = CGRectMake(0, 0, _customBar.backButton.width, _customBar.backButton.height);
        historyButton.right = _customBar.width-space;
        historyButton.top =_customBar.backButton.top;
        historyButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        historyButton.layer.cornerRadius = historyButton.height/2;
        historyButton.layer.masksToBounds = YES;
        [_customBar addSubview:historyButton];
        WEAK
        [[historyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self clickScanRecords];
        }];
    
        [[_customBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl * _Nullable x) {
            STRONG
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _customBar.titleLabel.text = @"扫一扫";
    }
    return _customBar;
}

- (void)goback1{
    
    [self.scanView endScanAnimation];
    [self.scanQRCodeView endReadQRCode];
    self.scanView = nil;
    self.scanQRCodeView = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickScanRecords{
    
    YBLScanRecordsViewController *scanRecordsVC = [[YBLScanRecordsViewController alloc] init];
    
    [self.navigationController pushViewController:scanRecordsVC animated:YES];
}

- (YBLScanQRCodeAnimationView *)scanView
{
    if(!_scanView)
    {
        _scanView = [[YBLScanQRCodeAnimationView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        WEAK
        [[_scanView.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self.scanView.textFeild resignFirstResponder];
            [self checkContent:self.scanView.textFeild.text];
        }];
        [[_scanView.changeMButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self.scanQRCodeView startReadQRCode];
            [self.scanView isShowTextField:NO];
        }];
        [[_scanView.writeMButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self.scanQRCodeView pauseCode];
            [self.scanView isShowTextField:YES];
        }];
        [[_scanView.histoyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self clickScanRecords];
        }];
        [[_scanView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self goback1];
        }];
        
      
    }
    return _scanView;
}

- (YBLScanQRCodeView *)scanQRCodeView
{
    if (!_scanQRCodeView)
    {
        _scanQRCodeView = [[YBLScanQRCodeView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight)];
        _scanQRCodeView.delegate = self;
    }
    return _scanQRCodeView;
}

- (void)sendQRCodeContent:(NSString *)content{
    // 停止扫描动画和识别二维码
    [self.scanView endScanAnimation];
    [self.scanQRCodeView pauseCode];
    [self checkContent:content];
}

- (void)checkContent:(NSString *)content{
    
    YBLScanRecordsModel *recordModel = [YBLScanRecordsModel new];
    recordModel.content = content;
    CGSize valueSize = [content heightWithFont:YBLFont(12) MaxWidth:YBLWindowWidth-100-40];
    recordModel.content_height = valueSize.height;
    recordModel.time = [YBLMethodTools getTimeNow];
    if ([content hasPrefix:@"http"]) {
        recordModel.content_title = @"链接";
        recordModel.scanType = ScanTypeURL;
        [recordModel bg_saveOrUpdate];
        
        [YBLMethodTools pushWebVcFrom:self URL:content title:nil];
        
    } else if([YBLMethodTools isPureInt:content]){
        //查找商品id
        [[YBLGoodsDetailViewModel singalForGoodIDWithQrcid:content selfVc:self] subscribeNext:^(id  _Nullable x) {
            recordModel.content_title = @"商品";
            recordModel.scanType = ScanTypeGood;
            [recordModel bg_saveOrUpdate];
        } error:^(NSError * _Nullable error) {
            
        }];
    }else {
        recordModel.content_title = @"文本";
        recordModel.scanType = ScanTypeText;
        [recordModel bg_saveOrUpdate];
        
        YBLScanContentViewController *contentVC = [[YBLScanContentViewController alloc] init];
        contentVC.content = content;
        [self.navigationController pushViewController:contentVC animated:YES];
    }
}

@end

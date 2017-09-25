//
//  YBLStoreCardUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreCardUIService.h"

static NSInteger const BTN_TAG = 301;

@interface YBLStoreCardUIService ()
@property (nonatomic, strong) UIImageView * headerView;
@property (nonatomic, strong) UIImageView * storeLogoImg;
@property (nonatomic, strong) UILabel * companyLab;
@property (nonatomic, strong) UILabel * nameLab;
@property (nonatomic, strong) UIImageView * barcodeImg;

@end

@implementation YBLStoreCardUIService

- (void)setStoreCardVC:(YBLStoreCardViewController *)storeCardVC {
    _storeCardVC = storeCardVC;
    [_storeCardVC.view addSubview:self.headerView];
    
    _barcodeImg = [[UIImageView alloc]initWithFrame:CGRectMake((YBLWindowWidth-260)/2, self.headerView.bottom+10, 260, 350)];
    _barcodeImg.image = [UIImage imageNamed:@"store_bcard"];
    [_storeCardVC.view addSubview:_barcodeImg];
    
//    UILabel * scanLab = [[UILabel alloc]initWithFrame:CGRectMake(0, _barcodeImg.bottom+15, YBLWindowWidth, 20)];
//    scanLab.textColor = [UIColor lightGrayColor];
//    scanLab.font = YBLBFont(13);
//    scanLab.text = @"手机云采扫一扫";
//    scanLab.textAlignment = NSTextAlignmentCenter;
//    [_storeCardVC.view addSubview:scanLab];
    
    
    NSArray * titleArr = @[@"下载二维码",@"分享二维码"];
    
    CGFloat buttonW = YBLWindowWidth/titleArr.count;
    
    CGFloat buttonH = 40;

    for (int i = 0; i<titleArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+buttonW*i, YBLWindowHeight-buttonH, buttonW, buttonH);
        button.tag = BTN_TAG + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [_storeCardVC.view addSubview:button];
        if (i == 0) {
            button.backgroundColor = YBLColor(210, 210, 210, 1);
            [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        }else {
            button.backgroundColor = YBLThemeColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = YBLFont(15);
    }
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, YBLWindowWidth, 100)];
        _headerView.image = [UIImage imageNamed:@"store_company"];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _storeLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.headerView.height-45, 40, 40)];
        _storeLogoImg.image = [UIImage imageNamed:@""];
        [_headerView addSubview:_storeLogoImg];
        
        _companyLab = [[UILabel alloc]initWithFrame:CGRectMake(_storeLogoImg.right+10, _storeLogoImg.frame.origin.y, self.headerView.width-_storeLogoImg.right+20, 20)];
        _companyLab.textColor = [UIColor whiteColor];
        _companyLab.font = YBLBFont(15);
        [_headerView addSubview:_companyLab];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_storeLogoImg.right+10, _companyLab.bottom, self.headerView.width-_storeLogoImg.right+20, 20)];
        _nameLab.textColor = [UIColor whiteColor];
        _nameLab.font = YBLBFont(15);
        [_headerView addSubview:_nameLab];
    }
    return _headerView;
}

- (void)buttonClick:(UIButton *)button {
    
}

@end

//
//  YBLAboutMeViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAboutMeViewController.h"
#import "YBLEditPurchaseCell.h"
#import "YBLWebViewController.h"

@interface YBLAboutMeViewController ()

@end

@implementation YBLAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于";
    
    [self createUI];
}

- (void)createUI{
    
    CGFloat imgaeWi = YBLWindowWidth/7;
    CGFloat imageWi = YBLWindowWidth/4;
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    contentScrollView.backgroundColor = self.view.backgroundColor;
    contentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentScrollView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yuncai_icon"]];
    iconImageView.frame = CGRectMake(0, space, imgaeWi*3, imgaeWi);
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.centerX = YBLWindowWidth/2;
    [contentScrollView addSubview:iconImageView];
    
    UILabel *buildVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.bottom+space/2, YBLWindowWidth, 20)];
    buildVersionLabel.textColor = YBLTextLightColor;
    buildVersionLabel.font = YBLFont(12);
    buildVersionLabel.textAlignment = NSTextAlignmentCenter;
    [contentScrollView addSubview:buildVersionLabel];
    NSString *version = [YBLMethodTools getAppVersion];
    NSString *buildNumber = [YBLMethodTools getAppBuildNumber];
    NSString *finalBuildVersionString = [NSString stringWithFormat:@"For iPhone V%@ build%@",version,buildNumber];
    buildVersionLabel.text = finalBuildVersionString;
    
    UIImage *appQrcdImage = [UIImage qrCodeImageWithContent:AppOfAppstore_URL
                                              codeImageSize:imageWi
                                                       logo:nil
                                                  logoFrame:CGRectZero
                                                        red:170
                                                      green:170
                                                       blue:170];
    UIImageView *appQrcImageView = [[UIImageView alloc] initWithImage:appQrcdImage];
    appQrcImageView.backgroundColor = [UIColor whiteColor];
    appQrcImageView.frame = CGRectMake(0, buildVersionLabel.bottom+space, imageWi, imageWi);
    appQrcImageView.centerX = YBLWindowWidth/2;
    [contentScrollView addSubview:appQrcImageView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, appQrcImageView.bottom+space/2, buildVersionLabel.width, 20)];
    infoLabel.text = @"扫描二维码，您的朋友也可以下载手机云采客户端！";
    infoLabel.textColor = YBLTextColor;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font = YBLBFont(12);
    [contentScrollView addSubview:infoLabel];
    

    NSInteger index = 0;
    NSArray *modelArray = @[[YBLEditItemGoodParaModel getModelWith:@"特别声明"
                                                             value:nil
                                                        isRequired:YES
                                                              type:EditTypeCellOnlyClick
                                                        paraString:H5_URL_HerebyDeclare
                                                      keyboardType:UIKeyboardTypeDefault],
                            [YBLEditItemGoodParaModel getModelWith:@"使用帮助"
                                                             value:nil
                                                        isRequired:YES
                                                              type:EditTypeCellOnlyClick
                                                        paraString:H5_URL_UseHelp
                                                      keyboardType:UIKeyboardTypeDefault],
                            [YBLEditItemGoodParaModel getModelWith:@"给我评分"
                                                             value:nil
                                                        isRequired:YES
                                                              type:EditTypeCellOnlyClick
                                                        paraString:AppOfAppstoreEvaluate_URL
                                                      keyboardType:UIKeyboardTypeDefault]];
    CGFloat itemHi = 50;
    for (YBLEditItemGoodParaModel *model in modelArray) {
        
        YBLEditPurchaseCell *cell = [[YBLEditPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.frame = CGRectMake(0, infoLabel.bottom+space*2+index*itemHi, YBLWindowWidth, itemHi);
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell updateItemCellModel:model];
        [contentScrollView addSubview:cell];
        WEAK
        [[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if (index == modelArray.count-1) {
                [YBLMethodTools OpenURL:[NSURL URLWithString:model.paraString]];
            } else {
                YBLWebViewController *webVC = [YBLWebViewController new];
                webVC.url = model.paraString;
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }];
        
        index++;
    }
    
    UILabel *infoDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
    infoDetailLabel.textColor = YBLTextLightColor;
    infoDetailLabel.bottom = YBLWindowHeight-kNavigationbarHeight-space;
    infoDetailLabel.font = YBLFont(12);
    infoDetailLabel.numberOfLines = 0;
    infoDetailLabel.userInteractionEnabled = YES;
    infoDetailLabel.textAlignment = NSTextAlignmentCenter;
    infoDetailLabel.text = @"Copyright©2016 - 2017 \n 手机云采版权所有";
    [contentScrollView addSubview:infoDetailLabel];
    
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    touch.numberOfTapsRequired = 10;
    [infoDetailLabel addGestureRecognizer:touch];
    
    contentScrollView.contentSize = CGSizeMake(YBLWindowWidth, infoDetailLabel.bottom);
    
}

-(void)handleTap: (UITapGestureRecognizer *) gesture {
    
    NSNumber *isCanLook = [[NSUserDefaults standardUserDefaults] objectForKey:NO_CAN_LOOK_GOOD_STATUES];
    if (!isCanLook) {
        [SVProgressHUD showSuccessWithStatus:@"开启成功~"];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:NO_CAN_LOOK_GOOD_STATUES];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        BOOL newState = !isCanLook.boolValue;
        if (newState) {
            [SVProgressHUD showSuccessWithStatus:@"开启成功~"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"关闭成功~"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@(newState) forKey:NO_CAN_LOOK_GOOD_STATUES];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end

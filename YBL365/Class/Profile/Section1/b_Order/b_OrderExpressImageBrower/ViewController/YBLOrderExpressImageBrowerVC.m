//
//  YBLOrderExpressImageBrowerVC.m
//  YC168
//
//  Created by 乔同新 on 2017/5/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderExpressImageBrowerVC.h"
#import "YBLFullScreenImageView.h"
#import "KSPhotoBrowser.h"

@interface YBLOrderExpressImageBrowerVC ()

@end

@implementation YBLOrderExpressImageBrowerVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    YBLCustomNavgationBar *navBar = [[YBLCustomNavgationBar alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
    WEAK
    [[navBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [self.navigationController popViewControllerAnimated:YES];
    }];
    navBar.titleLabel.text = @"查看物流凭证";
    [self.view addSubview:navBar];
    self.navBar = navBar;
    
    self.currentPicIndex = 0;
    
    [self createUI];
}

- (void)createUI {
    
    YBLSystemSocialModel *model = [YBLSystemSocialModel new];
    model.imagesArray = self.urlImageArray;
    model.imageType = SaveImageTypeAnyPic;
    
    YBLFullScreenImageView *fullImageView = [[YBLFullScreenImageView alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, YBLWindowWidth, YBLWindowHeight-self.navBar.bottom)
                                                                          shareImageModel:model
                                                                             currentIndex:self.currentPicIndex
                                                                                orginRect:CGRectZero
                                                                           fullScreenType:FullScreenImageViewTypeOrderExpressPic
                                                                        currentIndexBlock:nil];
    [self.view addSubview:fullImageView];
}



@end

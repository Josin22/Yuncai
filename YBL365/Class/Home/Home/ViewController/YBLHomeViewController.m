//
//  YBLHomeViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLHomeViewController.h"
#import "YBLHomeUIService.h"
#import "YBLHomeViewModel.h"
#import "YBLAPPViewModel.h"
#import "YBLNetWorkHudBar.h"
#import "YBLUpdateVersionView.h"

@interface YBLHomeViewController ()


@property (nonatomic, strong) YBLHomeUIService *homeUIService;//首页UI 服务
@property (nonatomic, strong) YBLHomeViewModel *viewModel;//首页UI 服务

@end

@implementation YBLHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.homeUIService startTimer];
//    self.netHudBar.top = kNavigationbarHeight;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
    [self.homeUIService stopTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.homeUIService.contentY > NAVBAR_CHANGE_POINT) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
    }else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:false];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:false];
    
    self.viewModel = [[YBLHomeViewModel alloc] init];
    self.homeUIService = [[YBLHomeUIService alloc] initWithVC:self ViewModel:self.viewModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdateVersionView:) name:App_Notification_Version object:nil];
    
    [[YBLAPPViewModel shareApp] showLaunchAnimationView];

}

#pragma mark -

- (void)showUpdateVersionView:(NSNotification *)not{
    
    NSDictionary *userInfo = [not userInfo];
    YBLUpdateReaseNotModel *notModel = userInfo[@"model"];
    [YBLUpdateVersionView showUpdateVersionViewWithModel:notModel
                                               doneBlock:^{
                                                   NSURL *url = [NSURL URLWithString:AppOfAppstore_URL];
                                                   [YBLMethodTools OpenURL:url];
                                               }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

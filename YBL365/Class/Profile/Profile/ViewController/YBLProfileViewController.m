//
//  YBLProfileViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLProfileViewController.h"
#import "YBLLoginViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLProfileViewModel.h"
#import "YBLProfileService.h"
#import "YBLNetWorkHudBar.h"

@interface YBLProfileViewController ()

@property (nonatomic, strong) YBLProfileViewModel *viewModel;
@property (nonatomic, strong) YBLProfileService   *service;

@end

@implementation YBLProfileViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.service requestUserInfoData];
    [self.service.waveHeaderView.waveView startWaveAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:false];
    [self.service.waveHeaderView.waveView stopWaveAnimation];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewModel = [YBLProfileViewModel new];
    self.service = [[YBLProfileService alloc] initWithVC:self ViewModel:self.viewModel];
}


@end

//
//  YBLOpenCreditsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOpenCreditsViewController.h"
#import "YBLOpenCreditsService.h"
#import "YBLOpenCreditsViewModel.h"
#import "YBLCreditsPayRecordsViewController.h"

@interface YBLOpenCreditsViewController ()

@property (nonatomic, strong) YBLOpenCreditsViewModel *viewModel;

@property (nonatomic, strong) YBLOpenCreditsService *service;

@end

@implementation YBLOpenCreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
        self.title = @"信用通";
    } else {
        self.title = @"VIP";
    }
    
    self.viewModel = [[YBLOpenCreditsViewModel alloc] init];
    self.service = [[YBLOpenCreditsService alloc] initWithVC:self ViewModel:self.viewModel];

    UIButton *historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.frame = CGRectMake(0, 0, 30, 30);
    [historyButton setImage:[UIImage imageNamed:@"history_icon"] forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(lookHistory) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *historyItem = [[UIBarButtonItem alloc] initWithCustomView:historyButton];
    self.navigationItem.rightBarButtonItems = @[self.explainButtonItem,historyItem];

}

- (void)lookHistory {
	
    YBLCreditsPayRecordsViewController *creditVC = [YBLCreditsPayRecordsViewController new];
    [self.navigationController pushViewController:creditVC animated:YES];
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
    if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_WhatsXYT_image title:@"信用通"];
    } else {
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_WhatVIP title:@"VIP"];
    }
}

@end

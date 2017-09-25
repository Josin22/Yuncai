//
//  YBLMyWalletsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyWalletsViewController.h"
#import "YBLMyWalletsService.h"
#import "YBLMyWalletsViewModel.h"

@interface YBLMyWalletsViewController ()

@property (nonatomic, strong) YBLMyWalletsService *service;

@property (nonatomic, strong) YBLMyWalletsViewModel *viewModel;

@end

@implementation YBLMyWalletsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的钱包";
    
    self.navigationItem.rightBarButtonItem = self.explainButtonItem;
    
    self.viewModel = [YBLMyWalletsViewModel new];
    
    self.service = [[YBLMyWalletsService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1{
    
    if (self.pushType == PurchaseDetailPushTypeSepacial) {
    
        self.tabBarController.selectedIndex = 4;
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
//    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_YunMoneyHelp];
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_YunMoneyHelp_image title:@"云币说明"];
}

@end

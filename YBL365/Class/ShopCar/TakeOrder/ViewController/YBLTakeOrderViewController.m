//
//  YBLTakeOrderViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLTakeOrderViewController.h"
#import "YBLOrderActionView.h"
#import "YBLTakeOrderUIService.h"
#import "YBLOrderAddressViewController.h"

@interface YBLTakeOrderViewController ()

@property (nonatomic, strong) YBLTakeOrderUIService *takeOrderUIService;

@end

@implementation YBLTakeOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"确认订单";
    
    self.takeOrderUIService = [[YBLTakeOrderUIService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1 {
    __weak typeof (self)weakSelf = self;
    [YBLOrderActionView showTitle:nil cancle:@"我再想想" sure:nil WithSubmitBlock:^{

        [YBLMethodTools popVc:nil withNavigationVc:weakSelf.navigationController];
        
    }cancelBlock:^{
        
    }];
}


@end

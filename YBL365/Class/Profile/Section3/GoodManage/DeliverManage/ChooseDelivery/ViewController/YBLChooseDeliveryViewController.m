//
//  YBLChooseDeliveryViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseDeliveryViewController.h"
#import "YBLChooseDeliveryService.h"

@interface YBLChooseDeliveryViewController ()

@property (nonatomic, strong) YBLChooseDeliveryService *service;

@end

@implementation YBLChooseDeliveryViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.isPopGestureRecognizerEnable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"选择地区";
    
    self.service = [[YBLChooseDeliveryService alloc] initWithVC:self ViewModel:self.viewModel];
    
}

- (YBLChooseDeliveryViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLChooseDeliveryViewModel new];
    }
    return _viewModel;
}

- (void)goback1{
    
    WEAK
    [YBLOrderActionView showTitle:@"您正在选择物流地区,确定要离开吗"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      STRONG
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                      cancelBlock:^{
                          
                      }];
}

@end

//
//  YBLOrderViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderViewController.h"
#import "YBLOrderService.h"

@interface YBLOrderViewController ()

@property (nonatomic, strong) YBLOrderService *service;

@end

@implementation YBLOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[YBLOrderService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (YBLOrderViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLOrderViewModel new];
    }
    return _viewModel;
}

- (void)goback1{
    
    if (self.viewModel.pushInVCType == PushInVCTypeOtherWay) {
        self.tabBarController.selectedIndex = 4;
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

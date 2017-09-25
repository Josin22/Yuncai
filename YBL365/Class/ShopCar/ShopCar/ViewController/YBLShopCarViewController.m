//
//  YBLShopCarViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopCarViewController.h"
#import "YBLShopCarService.h"

@interface YBLShopCarViewController ()

@property (nonatomic, strong) YBLShopCarService *service;

@end

@implementation YBLShopCarViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [self.service requestShopCarData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购物车";
    
    self.service = [[YBLShopCarService alloc] initWithVC:self ViewModel:self.viewModel];
    
}

- (YBLShopCarViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[YBLShopCarViewModel alloc] init];
    }
    return _viewModel;
}

@end

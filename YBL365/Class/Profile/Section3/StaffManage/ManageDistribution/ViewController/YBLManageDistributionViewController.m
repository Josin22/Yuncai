//
//  YBLManageDistributionViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManageDistributionViewController.h"
#import "YBLManageDistributionService.h"

@interface YBLManageDistributionViewController ()

@property (nonatomic, strong) YBLManageDistributionService *service;

@end

@implementation YBLManageDistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"管理分配";
    
    YBLManageDistributionViewModel *viewModel = [YBLManageDistributionViewModel new];
    self.service = [[YBLManageDistributionService alloc] initWithVC:self ViewModel:viewModel];
    
}


@end

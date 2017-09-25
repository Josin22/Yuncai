//
//  YBLStaffManageVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStaffManageVC.h"
#import "YBLStaffManageService.h"

@interface YBLStaffManageVC ()

@property (nonatomic, strong) YBLStaffManageService *service;

@property (nonatomic, strong) YBLStaffManageViewModel *viewModel;

@end

@implementation YBLStaffManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"员工管理";
    
    self.viewModel = [YBLStaffManageViewModel new];
    self.service = [[YBLStaffManageService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.service jsReloadData];
}

@end

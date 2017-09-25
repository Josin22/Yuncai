//
//  YBLOrderMMMyDepositVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMMyDepositVC.h"
#import "YBLOrderMMMyDepositService.h"

@interface YBLOrderMMMyDepositVC ()

@property (nonatomic, strong) YBLOrderMMMyDepositService *service;

@end

@implementation YBLOrderMMMyDepositVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的保证金";
    
    YBLOrderMMMyDepositViewModel *viewModel = [[YBLOrderMMMyDepositViewModel alloc] init];
    
    self.service = [[YBLOrderMMMyDepositService alloc] initWithVC:self ViewModel:viewModel];
}



@end

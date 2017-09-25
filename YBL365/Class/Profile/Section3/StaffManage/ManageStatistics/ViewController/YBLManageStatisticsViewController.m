//
//  YBLManageStatisticsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManageStatisticsViewController.h"
#import "YBLManageStatisticsService.h"

@interface YBLManageStatisticsViewController ()

@property (nonatomic, strong) YBLManageStatisticsService *service;

@end

@implementation YBLManageStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"管理统计";
    
    YBLManageStatisticsViewModel *viewModel = [YBLManageStatisticsViewModel  new];
    self.service = [[YBLManageStatisticsService alloc] initWithVC:self ViewModel:viewModel];
}



@end


//
//  YBLCreditsPayRecordsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCreditsPayRecordsViewController.h"
#import "YBLCreditsPayRecordsViewModel.h"
#import "YBLCreditsPayRecordsService.h"

@interface YBLCreditsPayRecordsViewController ()

@property (nonatomic, strong) YBLCreditsPayRecordsViewModel *viewModel;

@property (nonatomic, strong) YBLCreditsPayRecordsService *service;

@end

@implementation YBLCreditsPayRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"交易记录";
    
    self.viewModel = [YBLCreditsPayRecordsViewModel new];
    
    self.service = [[YBLCreditsPayRecordsService alloc] initWithVC:self ViewModel:self.viewModel];
}



@end

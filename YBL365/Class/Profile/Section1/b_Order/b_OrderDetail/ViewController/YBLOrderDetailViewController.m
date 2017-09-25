//
//  YBLViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailViewController.h"
#import "YBLOrderDetailService.h"

@interface YBLOrderDetailViewController ()

@property (nonatomic, strong) YBLOrderDetailService *service;

@end

@implementation YBLOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = @"订单详情";
    
    self.service = [[YBLOrderDetailService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1{
    
    [self.service goBack];
}

@end

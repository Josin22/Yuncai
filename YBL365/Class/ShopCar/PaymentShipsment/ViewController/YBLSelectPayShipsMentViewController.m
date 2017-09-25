//
//  YBLSelectPayShipsMentViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSelectPayShipsMentViewController.h"
#import "YBLSelectPayShipsMentService.h"

@interface YBLSelectPayShipsMentViewController ()

@property (nonatomic, strong) YBLSelectPayShipsMentService *service;

@end

@implementation YBLSelectPayShipsMentViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择支付配送方式";
    
    self.service = [[YBLSelectPayShipsMentService alloc] initWithVC:self ViewModel:self.viewModel];
  
}



@end

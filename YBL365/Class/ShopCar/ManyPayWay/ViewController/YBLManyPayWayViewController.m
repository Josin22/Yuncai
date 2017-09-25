//
//  YBLManyPayWayViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManyPayWayViewController.h"
#import "YBLManyPayWayService.h"

@interface YBLManyPayWayViewController ()

@property (nonatomic, strong) YBLManyPayWayService *service;

@end

@implementation YBLManyPayWayViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单提交成功";
    
    self.service = [[YBLManyPayWayService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1{
    
    __weak typeof (self)weakSelf = self;
    [YBLOrderActionView showTitle:@"您还有未支付订单,确定要离开吗?" cancle:@"我再想想" sure:@"确定" WithSubmitBlock:^{
        weakSelf.tabBarController.selectedIndex = 0;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
    }cancelBlock:^{
        
    }];
}

@end

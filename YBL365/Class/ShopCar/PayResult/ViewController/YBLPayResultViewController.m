//
//  YBLPayResultViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayResultViewController.h"
#import "YBLPayResultService.h"

@interface YBLPayResultViewController ()

@property (nonatomic, strong) YBLPayResultService *service;

@end

@implementation YBLPayResultViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"订单提交成功";
    
    self.service = [[YBLPayResultService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1{
    
    NSInteger index = 0;
    if (self.viewModel.payResultModel.takeOrderType == TakeOrderTypeCreditPay) {
        index = 4;
    }
    UIViewController *rootvc = self.navigationController.viewControllers[0];
    [rootvc dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.selectedIndex = index;
    [self.navigationController popToRootViewControllerAnimated:NO];

}


@end

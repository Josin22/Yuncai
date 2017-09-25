//
//  YBLPayWayViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayWayViewController.h"
#import "YBLPayWayService.h"


@interface YBLPayWayViewController ()

@property (nonatomic, strong) YBLPayWayService *service;

@end

@implementation YBLPayWayViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"云采收银台";
    
    self.service = [[YBLPayWayService alloc] initWithVC:self ViewModel:self.viewModel];
    
}

- (void)goback1{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


@end

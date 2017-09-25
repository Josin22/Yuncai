//
//  YBLGoodListViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodListViewController.h"
#import "YBLGoodListService.h"

@interface YBLGoodListViewController ()

@property (nonatomic, strong) YBLGoodListService *service;

@end

@implementation YBLGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.service = [[YBLGoodListService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.service showNavBar];
}

@end

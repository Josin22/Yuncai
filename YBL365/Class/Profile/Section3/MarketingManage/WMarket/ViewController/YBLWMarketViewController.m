//
//  YBLWMarketViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWMarketViewController.h"
#import "YBLWMarketService.h"
#import "YBLWMarketViewModel.h"

@interface YBLWMarketViewController ()

@property (nonatomic, strong) YBLWMarketViewModel *viewModel;

@property (nonatomic, strong) YBLWMarketService *service;

@end

@implementation YBLWMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"微营销";
 
    self.viewModel = [YBLWMarketViewModel new];
    
    self.service = [[YBLWMarketService alloc] initWithVC:self ViewModel:self.viewModel];
    
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
}

- (void)addClick:(UIBarButtonItem *)btn{
    
    [self.service pushToChooseGoodVC];
}

@end

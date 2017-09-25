//
//  YBLFooterPrintsViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFooterPrintsViewController.h"
#import "YBLFooterPrintsService.h"

@interface YBLFooterPrintsViewController ()

@property (nonatomic, strong) YBLFooterPrintsService *service;

@property (nonatomic, strong) YBLFooterPrintsViewModel *viewModel;

@end

@implementation YBLFooterPrintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"浏览记录";
    
    self.viewModel = [YBLFooterPrintsViewModel new];
    self.service = [[YBLFooterPrintsService alloc] initWithVC:self ViewModel:self.viewModel];
}



@end

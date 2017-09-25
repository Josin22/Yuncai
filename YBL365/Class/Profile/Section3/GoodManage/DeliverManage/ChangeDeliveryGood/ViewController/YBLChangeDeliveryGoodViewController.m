//
//  YBLChangeDeliveryGoodViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChangeDeliveryGoodViewController.h"
#import "YBLChangeDeliveryGoodService.h"

@interface YBLChangeDeliveryGoodViewController ()

@property (nonatomic, strong) YBLChangeDeliveryGoodService *service;

@end

@implementation YBLChangeDeliveryGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"商品配送修改";
    
    self.service = [[YBLChangeDeliveryGoodService alloc] initWithVC:self ViewModel:self.viewModel];
}

@end

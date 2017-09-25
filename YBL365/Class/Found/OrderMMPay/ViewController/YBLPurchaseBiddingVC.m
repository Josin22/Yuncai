//
//  YBLPurchaseBiddingVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseBiddingVC.h"
#import "YBLPurchaseBiddingService.h"

@interface YBLPurchaseBiddingVC ()

@property (nonatomic, strong) YBLPurchaseBiddingService *service;

@end

@implementation YBLPurchaseBiddingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交保证金参与报价";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.service = [[YBLPurchaseBiddingService alloc] initWithVC:self ViewModel:self.viewModel];
}

@end

//
//  YBLGoodEvaluateViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodEvaluateViewController.h"
#import "YBLGoodEvaluateService.h"

@interface YBLGoodEvaluateViewController ()

@property (nonatomic, strong) YBLGoodEvaluateService *service;

@end

@implementation YBLGoodEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"评价";
    
    self.service = [[YBLGoodEvaluateService alloc] initWithVC:self ViewModel:self.viewModel];
}

@end

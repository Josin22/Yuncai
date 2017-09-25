//
//  YBLMineMillionMessageViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMineMillionMessageViewController.h"
#import "YBLMineMillionMessageService.h"

@interface YBLMineMillionMessageViewController ()

@property (nonatomic, strong) YBLMineMillionMessageService *service;

@end

@implementation YBLMineMillionMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.viewModel.millionType == MillionTypeMine){
        self.navigationItem.title = @"客户管理";
    } else {
        self.navigationItem.title = @"商家名录";
    }
    
//    self.viewModel = [YBLMineMillionMessageViewModel new];
    self.service = [[YBLMineMillionMessageService alloc] initWithVC:self ViewModel:self.viewModel];
}



@end

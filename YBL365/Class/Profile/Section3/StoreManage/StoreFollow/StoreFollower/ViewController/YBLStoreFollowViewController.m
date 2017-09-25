//
//  YBLStoreFollowViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreFollowViewController.h"
#import "YBLStoreFollowService.h"

@interface YBLStoreFollowViewController ()

@property (nonatomic, strong) YBLStoreFollowService   *service;

@end

@implementation YBLStoreFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关注店铺";

    if (!self.viewModel) {
        self.viewModel = [[YBLStoreFollowViewModel alloc] init];
    }
    
    if (self.viewModel.followType == FollowTypeShares) {
        self.navigationItem.title = @"享客";
    }
    
    self.service = [[YBLStoreFollowService alloc] initWithVC:self ViewModel:self.viewModel];
    
}

@end

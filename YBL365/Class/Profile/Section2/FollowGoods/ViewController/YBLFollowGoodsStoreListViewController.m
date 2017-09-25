//
//  YBLFollowGoodsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFollowGoodsStoreListViewController.h"
#import "YBLFollowGoodsStoreService.h"

@interface YBLFollowGoodsStoreListViewController ()

@property (nonatomic, strong) YBLFollowGoodsStoreService   *service;

@end

@implementation YBLFollowGoodsStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[YBLFollowGoodsStoreService alloc] initWithVC:self ViewModel:self.viewModel];
}


@end

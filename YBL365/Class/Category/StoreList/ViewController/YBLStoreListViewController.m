//
//  YBLStoreListViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreListViewController.h"
#import "YBLStoreListService.h"

@interface YBLStoreListViewController ()

@property (nonatomic, strong) YBLStoreListService *service;

@end

@implementation YBLStoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.service = [[YBLStoreListService alloc] initWithVC:self ViewModel:self.viewModel];
    
}



@end

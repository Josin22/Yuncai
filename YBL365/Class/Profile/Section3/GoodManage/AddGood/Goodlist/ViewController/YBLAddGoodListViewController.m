//
//  YBLAddGoodListViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddGoodListViewController.h"
#import "YBLAddGoodListService.h"

@interface YBLAddGoodListViewController ()

@property (nonatomic, strong) YBLAddGoodListService *service;

@end

@implementation YBLAddGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.service = [[YBLAddGoodListService alloc] initWithVC:self ViewModel:self.viewModel];
}


@end

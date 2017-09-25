//
//  YBLGoodsManageVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsManageVC.h"
#import "YBLGoodsManageService.h"
#import "YBLAddGoodViewController.h"

@interface YBLGoodsManageVC ()

@property (nonatomic,strong) YBLGoodsManageService *service;

@end

@implementation YBLGoodsManageVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[YBLGoodsManageService alloc] initWithVC:self ViewModel:self.viewModel];
 
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
}

- (void)addClick:(UIBarButtonItem *)btn{
    
    YBLCategoryViewModel *viewModel = [YBLCategoryViewModel new];
    viewModel.goodCategoryType = GoodCategoryTypeForCommodityPoolCategory;
    YBLAddGoodViewController *addGoodVC = [YBLAddGoodViewController new];
    addGoodVC.viewModel = viewModel;
    [self.navigationController pushViewController:addGoodVC animated:YES];
}

@end

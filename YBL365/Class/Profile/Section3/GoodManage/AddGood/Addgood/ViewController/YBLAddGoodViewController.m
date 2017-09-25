//
//  YBLAddGoodViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddGoodViewController.h"
#import "YBLCategoryUIService.h"
#import "YBLAddGoodListViewController.h"
#import "YBLShareView.h"

@interface YBLAddGoodViewController ()

@property (nonatomic, strong) YBLCategoryUIService *service;

@end

@implementation YBLAddGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.service = [[YBLCategoryUIService alloc] initWithVC:self ViewModel:self.viewModel];
    WEAK
    self.service.rightTableView.itemClickBlock = ^(YBLCategoryTreeModel *model){
        STRONG
        YBLAddGoodListViewModel *viewModel = [YBLAddGoodListViewModel new];
        viewModel.category_id = model.id;
        viewModel.goodCategoryType = self.viewModel.goodCategoryType;
        YBLAddGoodListViewController *addGoodListVC = [YBLAddGoodListViewController new];
        addGoodListVC.viewModel = viewModel;
        [YBLMethodTools pushVC:addGoodListVC FromeUndefineVC:self];
    
    };
}

@end

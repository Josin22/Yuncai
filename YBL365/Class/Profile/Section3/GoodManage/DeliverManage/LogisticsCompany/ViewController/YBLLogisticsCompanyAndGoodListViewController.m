//
//  YBLLogisticsCompanyAndGoodListViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLogisticsCompanyAndGoodListViewController.h"
#import "YBLLogisticsCompanyAndGoodListService.h"

@interface YBLLogisticsCompanyAndGoodListViewController ()

@property (nonatomic, strong) YBLLogisticsCompanyAndGoodListService *service;

@end

@implementation YBLLogisticsCompanyAndGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.viewModel isGoodsType]){
        self.navigationItem.title = @"添加商品";
    } else {
        self.navigationItem.title = @"物流快递公司";
    }
    
    self.service = [[YBLLogisticsCompanyAndGoodListService alloc] initWithVC:self ViewModel:self.viewModel];
}


@end

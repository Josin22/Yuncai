//
//  YBLOrderMMRankingListVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMRankingListVC.h"
#import "YBLOrderMMRankingListService.h"

@interface YBLOrderMMRankingListVC ()

@property (nonatomic, strong) YBLOrderMMRankingListService *service;

@end

@implementation YBLOrderMMRankingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    YBLOrderMMRankingListViewModel *viewModel = [[YBLOrderMMRankingListViewModel alloc] init];
    
    self.service  = [[YBLOrderMMRankingListService alloc] initWithVC:self ViewModel:viewModel];
}



@end

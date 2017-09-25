//
//  YBLDeliverManageViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLDeliverManageViewController.h"
#import "YBLGoodsManageService.h"

@interface YBLDeliverManageViewController ()

@property (nonatomic, strong) YBLGoodsManageService *service;

@end

@implementation YBLDeliverManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"配送管理";
    
    self.service = [[YBLGoodsManageService alloc] initWithVC:self ViewModel:self.viewModel];
    
}



@end

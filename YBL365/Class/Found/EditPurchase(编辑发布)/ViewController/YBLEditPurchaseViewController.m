//
//  YBLEditPurchaseViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditPurchaseViewController.h"
#import "YBLEditPurchaseService.h"
#import "IQKeyboardManager.h"

@interface YBLEditPurchaseViewController ()

@property (nonatomic, strong) YBLEditPurchaseService *service;

@end

@implementation YBLEditPurchaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布编辑";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = self.explainButtonItem;
    
    self.service = [[YBLEditPurchaseService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)goback1{
    
    [YBLOrderActionView showTitle:@"确定要离开编辑吗?"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      [self.navigationController popViewControllerAnimated:YES];
                     }
                      cancelBlock:^{
                          
                      }];
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
//    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_PurchaseReleaseEditDelegate];
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_PurchaseReleaseEditDelegate_image title:@"采购订单发布编辑说明"];
}

@end

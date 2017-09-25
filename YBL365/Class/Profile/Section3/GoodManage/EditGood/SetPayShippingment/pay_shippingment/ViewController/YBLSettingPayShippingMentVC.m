//
//  YBLSettingPayShippingMentVC.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSettingPayShippingMentVC.h"
#import "YBLSettingPayShippingMentService.h"

@interface YBLSettingPayShippingMentVC ()

@property (nonatomic, strong) YBLSettingPayShippingMentService *service;

@end

@implementation YBLSettingPayShippingMentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"选择支付配送方式";

    self.navigationItem.rightBarButtonItem = self.explainButtonItem;
    
    self.service = [[YBLSettingPayShippingMentService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (YBLSettingPayShippingMentViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLSettingPayShippingMentViewModel new];
    }
    return _viewModel;
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_ShippingPaymentDeclare title:@"配送支付方式说明"];
}

@end

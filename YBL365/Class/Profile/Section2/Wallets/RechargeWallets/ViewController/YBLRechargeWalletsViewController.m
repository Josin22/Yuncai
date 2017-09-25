//
//  YBLRechargeWalletsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRechargeWalletsViewController.h"
#import "YBLRechargeWalletsService.h"

@interface YBLRechargeWalletsViewController ()

@property (nonatomic, strong) YBLRechargeWalletsService *service;

@property (nonatomic, strong) YBLRechargeWalletsViewModel *viewModel;

@end

@implementation YBLRechargeWalletsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"充值云币";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage newImageWithNamed:@"login_close" size:CGSizeMake(26, 26)] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    backItem.tintColor = YBLTextColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.viewModel = [YBLRechargeWalletsViewModel  new];
    YBLCreditPayModel *payModel = [YBLCreditPayModel new];
    payModel.serviceName = @"云币充值";
    self.viewModel.takeOrderType = TakeOrderTypeRechargeYunMoeny;
    self.viewModel.payModel = payModel;
    
    self.service = [[YBLRechargeWalletsService alloc] initWithVC:self ViewModel:self.viewModel];
    
}

- (void)goback{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

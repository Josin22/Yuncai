//
//  YBLPayResultService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayResultService.h"
#import "YBLPayResultViewController.h"
#import "YBLPayResultView.h"
#import "YBLOrderViewController.h"
#import "YBLPayResultViewModel.h"
#import "YBLMyWalletsViewController.h"
#import "YBLCreditsPayRecordsViewController.h"
#import "YBLLoginViewModel.h"

static NSString *lookWalletsString  = @"查看钱包";

static NSString *lookCreditString  = @"查看记录";

@interface YBLPayResultService ()

@property (nonatomic, strong) YBLPayResultViewModel *viewModel;

@property (nonatomic, weak) YBLPayResultViewController *VC;

@property (nonatomic, strong) YBLPayResultView *payResultView;

@end

@implementation YBLPayResultService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLPayResultViewController *)VC;
        _viewModel = (YBLPayResultViewModel *)viewModel;
        
        [_VC.view addSubview:self.payResultView];
        
        if (self.viewModel.payResultModel.takeOrderType==TakeOrderTypeCreditPay) {
            [self.payResultView.lookOrderButton setTitle:lookCreditString forState:UIControlStateNormal];
            /**
             *  重新获取userinfo
             */
            [YBLLoginViewModel siganlForGetUserInfos];
            
        } else if (self.viewModel.payResultModel.takeOrderType==TakeOrderTypeRechargeYunMoeny) {
            [self.payResultView.lookOrderButton setTitle:lookWalletsString forState:UIControlStateNormal];
        }
    }
    return self;
}

- (YBLPayResultView *)payResultView{
    
    if (!_payResultView) {
        _payResultView = [[YBLPayResultView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 10)];
        WEAK
        [[_payResultView.lookOrderButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            STRONG
            if ([x.currentTitle isEqualToString:lookWalletsString]) {
                
                YBLMyWalletsViewController *walletsVC = [YBLMyWalletsViewController new];
                walletsVC.pushType = PurchaseDetailPushTypeSepacial;
                [self.VC.navigationController pushViewController:walletsVC animated:YES];
                
            } else if ([x.currentTitle isEqualToString:lookCreditString]) {
                
                YBLCreditsPayRecordsViewController *creditVC = [YBLCreditsPayRecordsViewController new];
                [self.VC.navigationController pushViewController:creditVC animated:YES];
                
            } else {
                YBLOrderViewModel *viewModel = [YBLOrderViewModel new];
                viewModel.pushInVCType = PushInVCTypeOtherWay;
                viewModel.currentFoundIndex = 0;
                viewModel.orderSource = OrderSourceBuyer;
                YBLOrderViewController *orderVC = [YBLOrderViewController new];
                orderVC.viewModel = viewModel;
                [self.VC.navigationController pushViewController:orderVC animated:YES];
            }
        }];
        [[_payResultView.backHomeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            self.VC.tabBarController.selectedIndex = 0;
            [self.VC.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        _payResultView.payWayLabel.text = [NSString stringWithFormat:@"支付方式 : %@",self.viewModel.payResultModel.payWay];
        _payResultView.payMoneyLabel.text = [NSString stringWithFormat:@"支付金额 : ¥%.2f",self.viewModel.payResultModel.payMoney.doubleValue];
        
    }
    return _payResultView;
}

@end

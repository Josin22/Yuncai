//
//  YBLOpenCreditsService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOpenCreditsService.h"
#import "YBLOpenCreditsViewController.h"
#import "YBLOpenCreditsUerInfoHeaderView.h"
#import "YBLOpenCreditsItemCell.h"
#import "YBLCreditsPayViewController.h"
#import "YBLOpenCreditsViewModel.h"
#import "YBLLoginViewModel.h"

@interface YBLOpenCreditsService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *creditsTableView;

@property (nonatomic, weak  ) YBLOpenCreditsViewController *Vc;

@property (nonatomic, strong) YBLOpenCreditsUerInfoHeaderView *headerView;

@property (nonatomic, strong) YBLOpenCreditsViewModel *viewModel;

@end

@implementation YBLOpenCreditsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLOpenCreditsViewController *)VC;
        _viewModel = (YBLOpenCreditsViewModel *)viewModel;
        
        WEAK
        [YBLMethodTools headerRefreshWithTableView:self.creditsTableView completion:^{
            STRONG
            [self request];
        }];

        [self request];
        
        [self.viewModel.creditPriceStandardsSignal subscribeError:^(NSError *error) {
        } completed:^{
            STRONG
            [self.creditsTableView jsReloadData];
        }];
    }
    return self;
}

- (void)request{
    WEAK
    [[YBLLoginViewModel siganlForGetUserInfos] subscribeError:^(NSError * _Nullable error) {
        [self.creditsTableView.mj_header endRefreshing];
    } completed:^{
        STRONG
        [self.creditsTableView.mj_header endRefreshing];
        [self.headerView reloadUserInfoData];
    }];
}

- (YBLOpenCreditsUerInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YBLOpenCreditsUerInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 0)];
    }
    return _headerView;
}

- (UITableView *)creditsTableView{
    if (!_creditsTableView) {
        _creditsTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        [self.Vc.view addSubview:_creditsTableView];
        _creditsTableView.dataSource = self;
        _creditsTableView.delegate = self;
        _creditsTableView.tableHeaderView = self.headerView;
        _creditsTableView.rowHeight = [YBLOpenCreditsItemCell getHi];
        _creditsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_creditsTableView registerClass:NSClassFromString(@"YBLOpenCreditsItemCell") forCellReuseIdentifier:@"YBLOpenCreditsItemCell"];
    }
    return _creditsTableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.credit_price_standards_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLOpenCreditsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOpenCreditsItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLOpenCreditsItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLCreditPriceStandardsModel *model = self.viewModel.credit_price_standards_array[row];
    [cell updateModel:model];
    WEAK
    [[[cell.openCreditsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        [self pushVcWithModel:model];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    YBLCreditPriceStandardsModel *model = self.viewModel.credit_price_standards_array[row];
    [self pushVcWithModel:model];
}

- (void)pushVcWithModel:(YBLCreditPriceStandardsModel *)model{
    
    YBLCreditPayModel *payModel = [YBLCreditPayModel new];
    payModel.id = model.id;
    payModel.price = [NSString stringWithFormat:@"%@元",model.price];
    if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeCredit) {
        payModel.serviceName = [NSString stringWithFormat:@"开通%@信用通",model.name];
    } else if ([YBLUserManageCenter shareInstance].openCreditType == OpenCreditTypeMember) {
        payModel.serviceName = [NSString stringWithFormat:@"开通%@VIP服务",model.name];
    }    
    YBLCreditsPayViewModel *viewModel = [YBLCreditsPayViewModel new];
    viewModel.payModel = payModel;
    viewModel.takeOrderType = TakeOrderTypeCreditPay;
    YBLCreditsPayViewController *creditsVC = [YBLCreditsPayViewController new];
    creditsVC.viewModel = viewModel;
    [self.Vc.navigationController pushViewController:creditsVC animated:YES];
}

@end

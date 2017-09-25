//
//  YBLStoreManageVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreOpenManageVC.h"
#import "YBLOpenCreditsViewController.h"
#import "YBLEditPurchaseCell.h"

@interface YBLStoreOpenManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *openTableView;

@end

@implementation YBLStoreOpenManageVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.viewModel) {
        self.viewModel = [YBLStoreManageViewModel new];
    }
    
    if (self.viewModel.storeManageTypeList == StoreManageTypeListManage) {
        self.navigationItem.title = @"店铺管理";
    } else if (self.viewModel.storeManageTypeList == StoreManageTypeListBaseInfo) {
        self.navigationItem.title = @"基本信息管理";
        [[self.viewModel siganlForShopInfo] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            [self.openTableView jsReloadData];
        }];
    } else if (self.viewModel.storeManageTypeList == StoreManageTypeListZZXX) {
        self.navigationItem.title = @"云采商城网店经营者营业执照信息";
    }
    
    self.navigationItem.rightBarButtonItem = self.explainButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.openTableView];
}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_StoreHelp_image title:@"店铺操作说明"];
}

- (UITableView *)openTableView{
    
    if (!_openTableView) {
        _openTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _openTableView.dataSource = self;
        _openTableView.delegate = self;
        _openTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _openTableView.rowHeight = [YBLEditPurchaseCell getItemCellHeightWithModel:nil];
        _openTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        [_openTableView registerClass:NSClassFromString(@"YBLEditPurchaseCell") forCellReuseIdentifier:@"YBLEditPurchaseCell"];
    }
    return _openTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLEditPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLEditPurchaseCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(YBLEditPurchaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBLEditItemGoodParaModel *paraModel = self.viewModel.dataArray[indexPath.row];
    [cell updateItemCellModel:paraModel];
    WEAK
    [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [self.viewModel pushVcWithParaModel:paraModel fromeVc:self];
    }];

}

@end

//
//  YBLMarketingManageVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMarketingManageVC.h"
#import "YBLEditPurchaseCell.h"

@interface YBLMarketingManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellDataArray;

@property (nonatomic, strong) UITableView *marketTableView;

@end

@implementation YBLMarketingManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"营销管理";
    
    [self.view addSubview:self.marketTableView];
}

- (UITableView *)marketTableView{
    
    if (!_marketTableView) {
        _marketTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStylePlain];
        _marketTableView.dataSource = self;
        _marketTableView.delegate = self;
        _marketTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _marketTableView.rowHeight = [YBLEditPurchaseCell getItemCellHeightWithModel:nil];
        _marketTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        [_marketTableView registerClass:NSClassFromString(@"YBLEditPurchaseCell") forCellReuseIdentifier:@"YBLEditPurchaseCell"];
    }
    return _marketTableView;
}

- (NSMutableArray *)cellDataArray{
    
    if (!_cellDataArray) {
        _cellDataArray = [NSMutableArray array];
        [_cellDataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"微营销" value:nil paraValueString:@"YBLWMarketViewController"]];
        [_cellDataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"优惠券" value:nil paraValueString:@"YBLCouponsManageViewController"]];
        [_cellDataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"云币抢购" value:nil paraValueString:nil]];
        [_cellDataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"猜价格" value:nil paraValueString:nil]];
        [_cellDataArray addObject:[YBLEditItemGoodParaModel getModelWith:@"云采团购" value:nil paraValueString:nil]];
    }
    return _cellDataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLEditPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLEditPurchaseCell" forIndexPath:indexPath];
    YBLEditItemGoodParaModel *paraModel = self.cellDataArray[indexPath.row];
    [cell updateItemCellModel:paraModel];
    WEAK
    [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIControl* _Nullable x) {
        STRONG
        [self pushVcWithParaModel:paraModel];
    }];
    
    return cell;
}

- (void)pushVcWithParaModel:(YBLEditItemGoodParaModel *)paraModel{
    
    NSString *className = paraModel.paraValueString;
    if (!className) {
        [SVProgressHUD showInfoWithStatus:@"此功能即将上线 \n 敬请期待!"];
        return;
    }
    Class class = NSClassFromString(className);
    id classVC = [[class alloc] init];
    [self.navigationController pushViewController:classVC animated:YES];
}

@end

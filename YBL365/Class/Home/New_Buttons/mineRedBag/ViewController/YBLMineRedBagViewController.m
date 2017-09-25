//
//  YBLMineRedBagViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMineRedBagViewController.h"
#import "YBLBriberyItemCell.h"
#import "YBLStoreRedbagViewModel.h"
#import "YBLStoreViewController.h"

@interface YBLMineRedBagViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *briberyTableView;
@property (nonatomic, strong) YBLStoreRedbagViewModel *viewModel;
@end

@implementation YBLMineRedBagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我的红包";
    
    self.viewModel = [YBLStoreRedbagViewModel new];
    
    [self requestStoreRedBagIsReload:YES];
}

- (void)requestStoreRedBagIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForBaseStoreRedbagIsReload:isReload]subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.briberyTableView jsInsertRowIndexps:x];
        [self.briberyTableView.mj_header endRefreshing];
        
    } error:^(NSError * _Nullable error) {
        
    }];
}


- (UITableView *)briberyTableView{
    if (!_briberyTableView) {
        _briberyTableView = [[UITableView alloc] initWithFrame:[self.view bounds]
                                                         style:UITableViewStyleGrouped];
        _briberyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _briberyTableView.dataSource = self;
        _briberyTableView.delegate = self;
        _briberyTableView.backgroundColor = [UIColor whiteColor];
        _briberyTableView.emptyDataSetSource = self;
        _briberyTableView.emptyDataSetDelegate = self;
        _briberyTableView.rowHeight = [YBLBriberyItemCell getItemCellHeightWithModel:nil];
        [self.view addSubview:_briberyTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_briberyTableView completion:^{
            STRONG
            [self requestStoreRedBagIsReload:YES];
        }];
        [_briberyTableView registerClass:[YBLBriberyItemCell class] forCellReuseIdentifier:@"YBLBriberyItemCell"];
    }
    return _briberyTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.singleDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 50)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.textAlignment = NSTextAlignmentCenter;
//    headerView.font = YBLFont(12);
//    headerView.textColor = YBLTextColor;
//    headerView.text = @"20131 54 12";
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLBriberyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLBriberyItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.viewModel.singleDataArray.count currentRow:indexPath.section]) {
        [self requestStoreRedBagIsReload:NO];
    }
    
    return cell;
}

- (void)configureCell:(YBLBriberyItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLUserInfoModel *itemModel = self.viewModel.singleDataArray[indexPath.section];
    [cell updateItemCellModel:itemModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLUserInfoModel *itemModel = self.viewModel.singleDataArray[indexPath.section];
    YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
    viewModel.shopid = itemModel.shopid;
    YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
    storeVC.viewModel = viewModel;
    [self.navigationController pushViewController:storeVC animated:YES];
}

@end

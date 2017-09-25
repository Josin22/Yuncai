//
//  YBLStoreRedbagViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreRedbagViewController.h"
#import "YBLStoreRedbagViewModel.h"
#import "YBLStoreTableView.h"
#import "YBLStoreViewController.h"

@interface YBLStoreRedbagViewController ()<YBLTableViewDelegate>

@property (nonatomic, strong) YBLStoreTableView *storeRedbagTableView;
@property (nonatomic, strong) YBLStoreRedbagViewModel *viewModel;

@end

@implementation YBLStoreRedbagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"优选店铺";
    
    self.viewModel = [YBLStoreRedbagViewModel new];
    
    [self requestStoreRedBagIsReload:YES];
    
}

- (void)requestStoreRedBagIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForBaseStoreRedbagIsReload:isReload]subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.storeRedbagTableView jsInsertRowIndexps:x];
        [self.storeRedbagTableView.mj_header endRefreshing];
        
    } error:^(NSError * _Nullable error) {
        
    }];
    
//    [[self.viewModel siganlForBaseStoreRedbag]subscribeNext:^(id  _Nullable x) {
//        [self.storeRedbagTableView jsReloadData];
//        [self.storeRedbagTableView.mj_header endRefreshing];
//    } error:^(NSError * _Nullable error) {
//        
//    }];;
}


- (YBLStoreTableView *)storeRedbagTableView{
    if (!_storeRedbagTableView) {
        _storeRedbagTableView = [[YBLStoreTableView alloc] initWithFrame:[self.view bounds]
                                                                   style:UITableViewStylePlain
                                                                listType:StoreListTypeRedBag];
        _storeRedbagTableView.ybl_delegate = self;
        _storeRedbagTableView.dataArray = self.viewModel.singleDataArray;
        [self.view addSubview:_storeRedbagTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_storeRedbagTableView  completion:^{
            STRONG
            [self requestStoreRedBagIsReload:YES];
        }];
        
        _storeRedbagTableView.prestrainBlock = ^{
          STRONG
            [self requestStoreRedBagIsReload:NO];
        };
    }
    return _storeRedbagTableView;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLUserInfoModel *model = (YBLUserInfoModel *)selectValue;
    YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
    viewModel.shopid = model.shopid;
    YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
    storeVC.viewModel = viewModel;
    [self.navigationController pushViewController:storeVC animated:YES];
    
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    //关注
    YBLUserInfoModel *model = (YBLUserInfoModel *)selectValue;
    YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
    viewModel.shopid = model.shopid;
    YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
    storeVC.viewModel = viewModel;
    [self.navigationController pushViewController:storeVC animated:YES];
}

@end

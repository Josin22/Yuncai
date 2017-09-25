//
//  YBLDistributionManageVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLDistributionManageVC.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"
#import "YBLProductShareModel.h"
#import "YBLWKGoodListTableView.h"
#import "YBLProductShareViewModel.h"
#import "YBLRewardSetViewController.h"
#import "YBLStoreFollowViewController.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLDistributionManageVC ()<YBLTableViewDelegate>

@property (nonatomic, strong) YBLProductShareViewModel *viewModel;

@property (nonatomic, strong) YBLWKGoodListTableView *wTableView;

@end

@implementation YBLDistributionManageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"赏金管理";
    
    self.viewModel = [YBLProductShareViewModel new];
    
    self.navigationItem.rightBarButtonItem = self.addButtonItem;
    
    [self requestDataIsReload:YES];
}

- (void)requestDataIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel singalForShareMoenyIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        self.wTableView.dataArray = self.viewModel.singleDataArray;
        [self.wTableView jsInsertRowIndexps:self.viewModel.fin_indexps];
        [self.wTableView.mj_header endRefreshing];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (YBLWKGoodListTableView *)wTableView{
    
    if (!_wTableView) {
        _wTableView = [[YBLWKGoodListTableView alloc] initWithFrame:[self.view bounds]
                                                              style:UITableViewStylePlain
                                                               type:WKTypeReward];
        _wTableView.ybl_delegate = self;
        [self.view addSubview:_wTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_wTableView completion:^{
            STRONG
            [self requestDataIsReload:YES];
        }];
        _wTableView.prestrainBlock = ^{
            STRONG
            [self requestDataIsReload:NO];
        };
    }
    return _wTableView;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    WEAK
    YBLProductShareModel *model = (YBLProductShareModel *)selectValue;
    [YBLActionSheetView showActionSheetWithTitles:@[@"赏金设置",
                                                    @"查看享客",
                                                    @"查看商品"]
                                      handleClick:^(NSInteger index) {
                                          STRONG
                                          switch (index) {
                                              case 0:
                                              {
                                                  YBLProductShareModel *model = (YBLProductShareModel *)selectValue;
                                                  YBLRewardSetViewController *rewardSetVc = [YBLRewardSetViewController new];
                                                  rewardSetVc.selectGoodsArray = @[model.product].mutableCopy;
                                                  [self.navigationController pushViewController:rewardSetVc animated:YES];
                                              }
                                                  break;
                                              case 1:
                                              {
                                                  YBLStoreFollowViewModel *viewModel = [YBLStoreFollowViewModel new];
                                                  viewModel.followType = FollowTypeShares;
                                                  viewModel.rewardID = model.product.id;
                                                  YBLStoreFollowViewController *sharersVc = [YBLStoreFollowViewController new];
                                                  sharersVc.viewModel = viewModel;
                                                                                                    [self.navigationController pushViewController:sharersVc animated:YES];
                                              }
                                                  break;
                                              case 2:
                                              {
                                                  YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
                                                  viewModel.goodID = model.product.id;
                                                  YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
                                                  goodDetailVC.viewModel = viewModel;
                                                  [self.navigationController pushViewController:goodDetailVC animated:YES];
                                                  
                                              }
                                                  break;
                                                  
                                              default:
                                                  break;
                                          }
                                      }];

}

- (void)addClick:(UIBarButtonItem *)btn{
 
    YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
    viewModel.listVCType = ListVCTypeRewardToSetMoeny;
//    viewModel.openedExpressCompanyGoodListDataArray = self.viewModel.singleDataArray;
    YBLLogisticsCompanyAndGoodListViewController *Vc = [YBLLogisticsCompanyAndGoodListViewController new];
    Vc.viewModel = viewModel;
    [self.navigationController pushViewController:Vc animated:YES];
}

@end

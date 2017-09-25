//
//  YBLWMarketService.m
//  YC168
//
//  Created by 乔同新 on 2017/6/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWMarketService.h"
#import "YBLWMarketViewController.h"
#import "YBLWMarketViewModel.h"
#import "YBLWMarketGoodCell.h"
#import "YBLWMarketGoodModel.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"
#import "YBLGoodModel.h"
#import "YBLMarketGoodSettingViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLSaveManyImageTools.h"
#import "YBLWKGoodListTableView.h"

@interface YBLWMarketService ()<YBLTableViewDelegate>

@property (nonatomic, weak) YBLWMarketViewController *selfVc;

@property (nonatomic, weak) YBLWMarketViewModel *viewModel;

@property (nonatomic, strong) YBLWKGoodListTableView *wTableView;

@end

@implementation YBLWMarketService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _selfVc = (YBLWMarketViewController *)VC;
        _viewModel = (YBLWMarketViewModel *)viewModel;
     
        [self requestDataReload:YES];
    }
    return self;
}

- (void)requestDataReload:(BOOL)isReload {
    
    WEAK
    [[self.viewModel siganlForWMarketGoodIsReload:isReload] subscribeNext:^(NSMutableArray*  _Nullable x) {
        STRONG
        self.wTableView.dataArray = self.viewModel.singleDataArray;
        [self.wTableView.mj_header endRefreshing];
        [self.wTableView jsInsertRowIndexps:self.viewModel.fin_indexps];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (YBLWKGoodListTableView *)wTableView{
    
    if (!_wTableView) {
        _wTableView = [[YBLWKGoodListTableView alloc] initWithFrame:[self.selfVc.view bounds] style:UITableViewStylePlain];
        _wTableView.ybl_delegate = self;
        [_selfVc.view addSubview:_wTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_wTableView completion:^{
            STRONG
            [self requestDataReload:YES];
        }];
        _wTableView.prestrainBlock = ^{
            STRONG
            [self requestDataReload:NO];
        };
    }
    return _wTableView;
}

- (void)pushSystemShareWithImageArray:(NSMutableArray *)images shareURL:(NSString *)shareURL{
    YBLSystemSocialModel *model = [YBLSystemSocialModel new];
    model.text = MoreButton_ReportSellTitle;
    model.share_url = shareURL;
    //    model.spec = self.viewModel.goodDetailModel.specification;
    //    model.price = self.viewModel.goodDetailModel.price;
    model.imagesArray = images;
    model.imageType = SaveImageTypeNormalGoods;
    [YBLSaveManyImageTools pushSystemShareWithModel:model
                                                 VC:self.selfVc
                                       Completetion:^(BOOL isSuccess) {}];
}

- (void)pushToChooseGoodVC{
    
    YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
    viewModel.listVCType = ListVCTypeStoreGood;
    viewModel.openedExpressCompanyGoodListDataArray = self.viewModel.singleDataArray;
    WEAK
    viewModel.logisticsCompanyAndGoodListBlock = ^(NSMutableArray *selectArray) {
        STRONG
        if (selectArray.count==0) {
            return ;
        }
        NSMutableArray *valueArray = @[].mutableCopy;
        for (YBLGoodModel *itemModel in selectArray) {
            [valueArray addObject:itemModel.id];
        }
        [[self.viewModel siganlForWMarketGoodWithProductIDs:valueArray] subscribeNext:^(NSMutableArray*  _Nullable indexPaths) {
            STRONG
            [self.wTableView jsInsertRowIndexps:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        } error:^(NSError * _Nullable error) {
            
        }];
    };
    YBLLogisticsCompanyAndGoodListViewController *Vc = [YBLLogisticsCompanyAndGoodListViewController new];
    Vc.viewModel = viewModel;
    [self.selfVc.navigationController pushViewController:Vc animated:YES];
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    WEAK
    YBLWMarketGoodModel *itemModel = (YBLWMarketGoodModel *)selectValue;
    YBLMarketGoodSettingViewModel *viewModel = [YBLMarketGoodSettingViewModel new];
    viewModel.marketGoodVcType = MarketGoodVCTypeChoose;
    viewModel.marketGoodModel = itemModel;
    viewModel.changeBlock = ^(YBLWMarketGoodModel *changeModel) {
        STRONG
        [self pushSystemShareWithImageArray:changeModel.selectImageArray shareURL:itemModel.share_url];
    };
    YBLMarketGoodSettingViewController *markVC = [YBLMarketGoodSettingViewController new];
    markVC.viewModel = viewModel;
    YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:markVC];
    [self.selfVc presentViewController:nav animated:YES completion:nil];

}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLWMarketGoodModel *itemModel = (YBLWMarketGoodModel *)selectValue;
    YBLMarketGoodSettingViewModel *viewModel = [YBLMarketGoodSettingViewModel new];
    viewModel.marketGoodModel = itemModel;
    WEAK
    viewModel.changeBlock = ^(YBLWMarketGoodModel *changeModel) {
        STRONG
        [self.viewModel.singleDataArray replaceObjectAtIndex:indexPath.row withObject:changeModel];
        [self.wTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    YBLMarketGoodSettingViewController *Vc = [YBLMarketGoodSettingViewController new];
    Vc.viewModel = viewModel;
    [self.selfVc.navigationController pushViewController:Vc animated:YES];
}

- (void)ybl_tableViewCellSlideToClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLWMarketGoodModel *itemModel = (YBLWMarketGoodModel *)selectValue;
    [YBLOrderActionView showTitle:@"确定要删除此微营销商品吗?"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      [[self.viewModel signalForDeleteWmarketGoodWithID:itemModel.id index:indexPath.row] subscribeNext:^(NSMutableArray*  _Nullable x) {
                          [self.wTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                          if (self.viewModel.singleDataArray.count==0) {
                              [self.wTableView jsReloadData];
                          }
                          [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                      } error:^(NSError * _Nullable error) {
                          
                      }];
                  }
                      cancelBlock:^{
                          [self.wTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                      }];

}

@end

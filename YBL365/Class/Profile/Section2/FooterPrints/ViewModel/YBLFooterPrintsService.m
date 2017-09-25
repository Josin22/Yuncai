//
//  YBLFooterPrintsService.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFooterPrintsService.h"
#import "YBLFooterPrintsViewController.h"
#import "YBLNormalGoodTableView.h"
#import "YBLGoodModel.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLFooterPrintsService()<YBLTableViewDelegate>

@property (nonatomic, weak  ) YBLFooterPrintsViewModel *viewModel;

@property (nonatomic, weak  ) YBLFooterPrintsViewController *selfVc;

@property (nonatomic, strong) YBLNormalGoodTableView *footerPrintsTableView;

@end

@implementation YBLFooterPrintsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLFooterPrintsViewModel *)viewModel;
        _selfVc = (YBLFooterPrintsViewController *)VC;
        
        UIButton *cleanAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cleanAllButton.frame = CGRectMake(0, 0, 40, 40);
        [cleanAllButton setTitle:@"清空" forState:UIControlStateNormal];
        cleanAllButton.titleLabel.font = YBLFont(14);
        [cleanAllButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        WEAK
        [[cleanAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if (self.viewModel.footerPrintData.count==0) {
                [SVProgressHUD showWithStatus:@"您当前没有浏览记录哟~"];
                return ;
            }
            [YBLOrderActionView showTitle:@"确定要清空全部浏览记录?"
                                   cancle:@"我再想想"
                                     sure:@"确定"
                          WithSubmitBlock:^{
                              STRONG
                              [self.viewModel cleanAllFooterPrintsData];
                              [self.footerPrintsTableView reloadData];
                          }
                              cancelBlock:^{
                                  
                              }];
        }];
        self.selfVc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cleanAllButton];
        
        /**
         *  更新
         */
        [self reloadData];
    }
    return self;
}

- (void)reloadData{
    
    [self.viewModel reGetFooterPrintsData];
    self.footerPrintsTableView.dataArray =  self.viewModel.footerPrintData;
    [self.footerPrintsTableView jsReloadData];
}


- (YBLNormalGoodTableView *)footerPrintsTableView{
    if (!_footerPrintsTableView) {
        _footerPrintsTableView = [[YBLNormalGoodTableView alloc] initWithFrame:[self.selfVc.view bounds]
                                                                         style:UITableViewStylePlain
                                                                 tableViewType:NormalTableViewTypeFooterRecordsGood];
        _footerPrintsTableView.ybl_delegate = self;
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_footerPrintsTableView completion:^{
            STRONG
            [self reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.footerPrintsTableView.mj_header endRefreshing];
            });
        }];
        [self.selfVc.view addSubview:_footerPrintsTableView];
    }
    return _footerPrintsTableView;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview {
    
    YBLGoodModel *model = (YBLGoodModel *)selectValue;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = model.id;
    viewModel.goodDetailModel = model;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.selfVc.navigationController pushViewController:goodDetailVC animated:YES];

}

- (void)ybl_tableViewCellSlideToClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLGoodModel *model = (YBLGoodModel *)selectValue;
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    [self.viewModel deleteFooterPrintsGoodWithID:model.id index:indexPath.row];
    [self.footerPrintsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.viewModel.footerPrintData.count==0) {
        [self.footerPrintsTableView reloadData];
    }
}

- (void)ybl_tableViewCellResetCell:(UITableViewCell *)cell tableview:(UITableView *)tableview{
    
}

@end

//
//  YBLOrderCommentsSuccessViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderCommentsSuccessViewController.h"
#import "YBLCommentsHeaderView.h"
#import "YBLNormalGoodTableView.h"
#import "YBLOrderCommentsViewModel.h"
#import "YBLOrderMakeCommentsViewController.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLOrderCommentsSuccessViewController ()<YBLTableViewDelegate>

@property (nonatomic, strong) YBLCommentsHeaderView *headerView;

@property (nonatomic, strong) YBLNormalGoodTableView *commentsTableView;

@property (nonatomic, strong) YBLOrderCommentsViewModel *viewModel;

@end

@implementation YBLOrderCommentsSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"评价成功";
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 30, 30);
    [closeButton setImage:[UIImage imageNamed:@"close_nav"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.viewModel = [YBLOrderCommentsViewModel new];
    
    [self requestDataIsReload:YES];
}

- (void)goback{
    
    for (UIViewController *Vc in self.navigationController.viewControllers) {
        if ([Vc isKindOfClass:NSClassFromString(@"YBLOrderCommentsViewController")]) {
            [self.navigationController popToViewController:Vc animated:YES];
        }
    }
    
}

- (void)requestDataIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForOrderCommentsListIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.commentsTableView.mj_header endRefreshing];
        NSMutableArray *dataArray = [self.viewModel getCurrentDataArrayWithIndex:0];
        self.commentsTableView.dataArray = dataArray;
        if (isReload) {
            if (self.commentsTableView.dataArray.count==0) {
                self.headerView.isHasComments = NO;
            } else {
                self.headerView.isHasComments = YES;
            }
            [self.commentsTableView jsReloadData];
        } else {
            [self.commentsTableView jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
        }
//        [self.commentsTableView jsReloadData];
    } error:^(NSError * _Nullable error) {
        
    }];
}

- (YBLNormalGoodTableView *)commentsTableView{
    if (!_commentsTableView) {
        _commentsTableView = [[YBLNormalGoodTableView alloc] initWithFrame:[self.view bounds]
                                                                     style:UITableViewStylePlain
                                                             tableViewType:NormalTableViewTypeNotCommentsGood];
        _commentsTableView.tableHeaderView = self.headerView;
        _commentsTableView.ybl_delegate = self;
        WEAK
        _commentsTableView.prestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyLoadMoreRequest]) {
                [self requestDataIsReload:NO];
            }
        };
        [YBLMethodTools headerRefreshWithTableView:_commentsTableView completion:^{
            STRONG
            [self requestDataIsReload:YES];
        }];
        [self.view addSubview:_commentsTableView];
    }
    return _commentsTableView;
}

- (YBLCommentsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YBLCommentsHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    }
    return _headerView;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLOrderCommentsItemModel *commentModel = (YBLOrderCommentsItemModel *)selectValue;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = commentModel.product_id;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.navigationController pushViewController:goodDetailVC animated:YES];
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLOrderCommentsItemModel *commentModel = (YBLOrderCommentsItemModel *)selectValue;
    YBLOrderMakeCommentsViewModel *viewModel = [YBLOrderMakeCommentsViewModel new];
    viewModel.commentsModel = commentModel;
    YBLOrderMakeCommentsViewController *commentsVc = [YBLOrderMakeCommentsViewController new];
    commentsVc.viewModel = viewModel;
    [self.navigationController pushViewController:commentsVc animated:YES];
}

@end

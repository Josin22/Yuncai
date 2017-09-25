//
//  YBLFollowGoodsService.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFollowGoodsStoreService.h"
#import "YBLFollowGoodsStoreViewModel.h"
#import "YBLFollowGoodsStoreListViewController.h"
#import "YBLNormalGoodTableView.h"
#import "YBLStoreTableView.h"
#import "YBLAddGoodListCell.h"
#import "YBLTextSegmentControl.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLGoodsDetailViewModel.h"
#import "YBLStoreViewController.h"
#import "YBLStoreViewModel.h"
#import "YBLGoodsDetailViewModel.h"
#import "YBLShopCarViewModel.h"

@interface YBLFollowGoodsStoreService ()<YBLTableViewDelegate,YBLTextSegmentControlDelegate,UIScrollViewDelegate>

@property (nonatomic, weak  ) YBLFollowGoodsStoreViewModel *viewModel;

@property (nonatomic, weak  ) YBLFollowGoodsStoreListViewController *selfVc;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) YBLNormalGoodTableView *normalGoodListView;

@property (nonatomic, strong) YBLStoreTableView *storeTableView;

@property (nonatomic, strong) YBLTextSegmentControl *segmentControl;

@end


@implementation YBLFollowGoodsStoreService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
     
        _viewModel = (YBLFollowGoodsStoreViewModel *)viewModel;
        _selfVc = (YBLFollowGoodsStoreListViewController *)VC;
        
        self.selfVc.navigationItem.titleView = self.segmentControl;
        [self.selfVc.view addSubview:self.contentScrollView];
        
        if (self.viewModel.currentFoundIndex == 0) {
            [self requestFollowData:YES];
        } else {
            self.segmentControl.currentIndex = self.viewModel.currentFoundIndex;
        }
     
        WEAK
        [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
            STRONG
            self.segmentControl.enableSegment = !x.boolValue;
        }];
    }
    return self;
}

- (void)requestFollowData:(BOOL)isReload{
    WEAK
    [[self.viewModel signalForFollowGoodsIsReload:isReload] subscribeNext:^(NSMutableArray *  _Nullable x) {
        STRONG
        NSMutableArray *dataArray = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        if (self.viewModel.currentFoundIndex==0) {
            [self.normalGoodListView.mj_header endRefreshing];
            self.normalGoodListView.dataArray = dataArray;
            [self.normalGoodListView jsReloadData];
        } else {
            [self.storeTableView.mj_header endRefreshing];
            self.storeTableView.dataArray = dataArray;
            [self.storeTableView jsReloadData];
        }
    } error:^(NSError * _Nullable error) {
        [self.storeTableView.mj_header endRefreshing];
        [self.normalGoodListView.mj_header endRefreshing];
    }];
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:[self.selfVc.view bounds]];
        _contentScrollView.backgroundColor = self.selfVc.view.backgroundColor;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.scrollEnabled = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.contentSize = CGSizeMake(YBLWindowWidth*2, YBLWindowHeight);
    }
    return _contentScrollView;
}

- (YBLNormalGoodTableView *)normalGoodListView{
    if (!_normalGoodListView) {
        _normalGoodListView = [[YBLNormalGoodTableView alloc] initWithFrame:[self.contentScrollView bounds]
                                                                      style:UITableViewStylePlain
                                                              tableViewType:NormalTableViewTypeFollowGood];
        _normalGoodListView.left = 0;
        _normalGoodListView.ybl_delegate = self;
        _normalGoodListView.showsVerticalScrollIndicator = NO;
        _normalGoodListView.showsHorizontalScrollIndicator = NO;
        [self.contentScrollView addSubview:_normalGoodListView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_normalGoodListView completion:^{
            STRONG
            [self requestFollowData:YES];
        }];
        _normalGoodListView.prestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyRequestWithIndex:self.viewModel.currentFoundIndex]) {
                [self requestFollowData:NO];
            }
        };
    }
    return _normalGoodListView;
}

- (YBLStoreTableView *)storeTableView{
    if (!_storeTableView) {
        _storeTableView = [[YBLStoreTableView alloc] initWithFrame:[self.contentScrollView bounds]
                                                             style:UITableViewStyleGrouped
                                                          listType:StoreListTypeBaseInfo];
        _storeTableView.ybl_delegate = self;
        _storeTableView.left = self.contentScrollView.width;
        [self.contentScrollView addSubview:_storeTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_storeTableView completion:^{
            STRONG
            [self requestFollowData:YES];
        }];
        _storeTableView.prestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyRequestWithIndex:self.viewModel.currentFoundIndex]) {
                [self requestFollowData:NO];
            }
        };
    }
    return _storeTableView;
}

- (YBLTextSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, 100, 44)
                                                       TextSegmentType:TextSegmentTypeGoodsDetail];
        _segmentControl.delegate = self;
        [_segmentControl updateTitleData:[self.viewModel.titleArray[0] mutableCopy]];
    }
    return _segmentControl;
}

#pragma mark - delegate

- (void)textSegmentControlIndex:(NSInteger)index{
    self.viewModel.currentFoundIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    //店铺关注
    NSMutableArray *dataArray = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
    if (dataArray.count==0) {
        [self requestFollowData:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    self.segmentControl.currentIndex = index;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    //进详情  or 进店铺
    if ([tableview isKindOfClass:[YBLNormalGoodTableView class]]) {
        YBLGoodModel *model = (YBLGoodModel *)selectValue;
        YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
        viewModel.goodID = model.id;
        viewModel.goodDetailModel = model;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [self.selfVc.navigationController pushViewController:goodDetailVC animated:YES];
    } else if ([tableview isKindOfClass:[YBLStoreTableView class]]) {
        YBLUserInfoModel *model = (YBLUserInfoModel *)selectValue;
        YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
        viewModel.shopid = model.id;
        YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
        storeVC.viewModel = viewModel;
        [self.selfVc.navigationController pushViewController:storeVC animated:YES];
    }
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    //购物车
    if ([tableview isKindOfClass:[YBLNormalGoodTableView class]]) {
        YBLGoodModel *model = (YBLGoodModel *)selectValue;
        Prices_prices price_price = [YBLMethodTools getPrice_priceWithModel:model.prices];
        if (model.no_permit_check_result.no_permit.boolValue) {
            [SVProgressHUD showErrorWithStatus:@"库存不足~"];
            return;
        }
        [[YBLGoodsDetailViewModel addCartWithQuantity:price_price.minWholesaleCount goodID:model.id] subscribeNext:^(NSNumber *x) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功~"];
            [YBLShopCarViewModel getCurrentCartsNumber];
        }];
    }
}
//取消
- (void)ybl_tableViewCellSlideToClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
   WEAK
    if ([tableview isKindOfClass:[YBLNormalGoodTableView class]]) {
        YBLGoodModel *model = (YBLGoodModel *)selectValue;
        [[YBLGoodsDetailViewModel signalForGood:model.id isFollow:NO] subscribeNext:^(id  _Nullable x) {
            STRONG
            NSMutableArray *dataArray = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
            [dataArray removeObjectAtIndex:indexPath.row];
            self.normalGoodListView.dataArray = dataArray;
            [self.normalGoodListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        } error:^(NSError * _Nullable error) {
            
        }];
            
    } else if ([tableview isKindOfClass:[YBLStoreTableView class]]) {
        YBLUserInfoModel *model = (YBLUserInfoModel *)selectValue;
        [[YBLStoreViewModel signalForStore:model.id isFollow:NO] subscribeNext:^(id  _Nullable x) {
            STRONG
            NSMutableArray *dataArray = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
            [dataArray removeObjectAtIndex:indexPath.row];
            self.storeTableView.dataArray = dataArray;
            [self.storeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        } error:^(NSError * _Nullable error) {
            
        }];
    }
}

@end

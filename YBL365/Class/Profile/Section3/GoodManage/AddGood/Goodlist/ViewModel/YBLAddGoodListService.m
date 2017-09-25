//
//  YBLAddGoodListService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddGoodListService.h"
#import "YBLAddGoodListViewController.h"
#import "YBLBrandView.h"
#import "YBLEditPurchaseViewController.h"
#import "YBLSearchNavView.h"
#import "YBLGoodSearchView.h"
#import "YBLAddGoodListCell.h"
#import "YBLGoodPicViewController.h"
#import "YBLNormalGoodTableView.h"

@interface YBLAddGoodListService ()<YBLTableViewDelegate>

@property (nonatomic, strong) YBLNormalGoodTableView *marTableView;

@property (nonatomic, weak  ) YBLAddGoodListViewController *VC;

@property (nonatomic, weak  ) YBLAddGoodListViewModel *viewModel;

@property (nonatomic, strong) YBLSearchNavView *searchGoodView;

@property (nonatomic, strong) UIButton *topButton;

@end

@implementation YBLAddGoodListService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super init]) {
        
        _VC = (YBLAddGoodListViewController *)VC;
        _viewModel = (YBLAddGoodListViewModel *)viewModel;
   
        if (self.viewModel.goodCategoryType == GoodCategoryTypeForCommodityPoolCategory) {
            
            self.searchGoodView.titleLabel.text = @"搜索经营商品";
            
        } else if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
            
            self.searchGoodView.titleLabel.text = @"搜索采购商品";
        }
        if (self.viewModel.keyword) {
            self.searchGoodView.titleLabel.text = self.viewModel.keyword;
        }
        
        self.VC.navigationItem.titleView = self.searchGoodView;
        
        [self checkRequestMethodIsReload:YES];
        
    }
    return self;
}

- (UIButton *)topButton{
    
    if (!_topButton) {
        _topButton = [YBLMethodTools getButtonWithImage:@"home_tuijian_top_icon"];
        _topButton.right = YBLWindowWidth-space*1.5;
        _topButton.bottom = YBLWindowHeight-kNavigationbarHeight-space*1.5;
        [self.VC.view addSubview:_topButton];
        WEAK
        [[_topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self.marTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.topButton.hidden = YES;
        }];
    }
    return _topButton;
}

- (YBLSearchNavView *)searchGoodView{
    
    if (!_searchGoodView) {
        WEAK
        _searchGoodView = [[YBLSearchNavView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
        _searchGoodView.searchBlock = ^{
            STRONG
            [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeNoView
                                                          SearchHandle:^(NSString *searchText,SearchType searchType){
                                                              STRONG
                                                              //
                                                              self.searchGoodView.titleLabel.text = searchText;
                                                              
                                                              self.viewModel.keyword = searchText;
                                                              
                                                              [self searchProductIsReload:YES];
                                                          }
                                                          cancleHandle:^{
                                                          }
                                                    animationEndHandle:^{
                                                    }
                                                           currentText:nil];
            
        };
        
    }
    return _searchGoodView;
}

/**
 *  采购 总库 搜索
 *
 *  @param isReload 是否刷新
 */
- (void)searchProductIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForProductSearchIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self reloadTableIsReload:isReload indexps:x];
    } error:^(NSError * _Nullable error) {
        [self.marTableView.mj_header endRefreshing];
    }];
    
}

/**
 *  商城商品
 *
 *  @param isReload 是否刷新
 */
- (void)reloadMoreDataReload:(BOOL)isReload{
    WEAK
    [[self.viewModel singalForMoreCategoryDataListRealod:isReload] subscribeNext:^(NSMutableArray *x) {
        STRONG
        [self reloadTableIsReload:isReload indexps:x];
    } error:^(NSError *error) {
        [self.marTableView.mj_header endRefreshing];
    }];
}

- (void)reloadTableIsReload:(BOOL)isReload indexps:(NSMutableArray *)indexps{
    self.marTableView.dataArray = self.viewModel.goodListArray;
    [self.marTableView.mj_header endRefreshing];
//    [self.marTableView jsReloadData];    
    if (isReload) {
        [self.marTableView jsReloadData];
    } else {
        [self.marTableView jsInsertRowIndexps:indexps];
    }
}

- (YBLNormalGoodTableView *)marTableView{
    
    if (!_marTableView) {
        _marTableView = [[YBLNormalGoodTableView alloc] initWithFrame:[self.VC.view bounds] style:UITableViewStylePlain];
        _marTableView.ybl_delegate = self;
        [_VC.view addSubview:_marTableView];
        WEAK
        _marTableView.prestrainBlock = ^{
            STRONG
            if(!self.viewModel.isNoMoreData&&!self.viewModel.isRequesting) {
                [self checkRequestMethodIsReload:NO];
            }
        };
        [YBLMethodTools headerRefreshWithTableView:_marTableView completion:^{
            STRONG
            [self checkRequestMethodIsReload:YES];
        }];
    }
    return _marTableView;
}

- (void)checkRequestMethodIsReload:(BOOL)isReload{
    //  在这个地方调用加载更多数据的方法。
    if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar||self.viewModel.goodCategoryType == GoodCategoryTypeForCommodityPoolCategory) {
        if (!self.viewModel.keyword) {
            //加载商品
            [self reloadMoreDataReload:isReload];
        } else {
            //加载搜索商品
            [self searchProductIsReload:isReload];
        }
    } else {
        [self reloadMoreDataReload:isReload];
    }
}

- (void)ybl_tableViewCellResetCell:(YBLAddGoodListCell *)cell tableview:(UITableView *)tableview{
    
    if (self.viewModel.goodCategoryType==GoodCategoryTypeForCommodityPoolCategory) {
        [cell.addToStoreButton setTitle:@"添加到店铺" forState:UIControlStateNormal];
    } else if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
        [cell.addToStoreButton setTitle:@"编辑采购" forState:UIControlStateNormal];
    }
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLGoodModel *model = (YBLGoodModel *)selectValue;
    
    if (self.viewModel.goodCategoryType==GoodCategoryTypeForCommodityPoolCategory) {
        //商品总库
        [[self.viewModel singalForSaveToStoreWithId:model.id] subscribeError:^(NSError *error) {
            
        } completed:^{
            
        }];
    } else if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
        //采购订单
        [self pushEditPurchaseVCWithModel:model];
    }
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    
    YBLGoodModel *model = (YBLGoodModel *)selectValue;
    YBLGoodPicViewController *picVC = [YBLGoodPicViewController new];
    picVC.pModel = model;
    picVC.goodCategoryType = self.viewModel.goodCategoryType;
    [self.VC.navigationController pushViewController:picVC animated:YES];
}

- (void)pushEditPurchaseVCWithModel:(YBLGoodModel *)model{
    
    YBLEdictPurchaseViewModel *viewModel = [YBLEdictPurchaseViewModel new];
    viewModel.goodModel = model;
    YBLEditPurchaseViewController *editPurchaseVC = [YBLEditPurchaseViewController new];
    editPurchaseVC.viewModel = viewModel;
    [self.VC.navigationController pushViewController:editPurchaseVC animated:YES];
}

/*
 #pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.goodListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLAddGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLAddGoodListCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLAddGoodListCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YBLGoodModel *model = self.viewModel.goodListArray[indexPath.row];

    [cell updateItemCellModel:model];
    
    if (self.viewModel.goodCategoryType==GoodCategoryTypeForCommodityPoolCategory) {
        [cell.addToStoreButton setTitle:@"添加到店铺" forState:UIControlStateNormal];
    } else if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
        [cell.addToStoreButton setTitle:@"编辑采购" forState:UIControlStateNormal];
    }
    WEAK
    [[[cell.addToStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        if (self.viewModel.goodCategoryType==GoodCategoryTypeForCommodityPoolCategory) {
            //商品总库
            YBLGoodModel *model = self.viewModel.goodListArray[indexPath.row];
            [[self.viewModel singalForSaveToStoreWithId:model.id] subscribeError:^(NSError *error) {
                
            } completed:^{
                
            }];
        } else if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
            //采购订单
            [self pushEditPurchaseVCWithModel:model];
        }
    }];
    
    if(indexPath.row==self.viewModel.goodListArray.count-PrestrainLessCount&&indexPath.row>=PrestrainLessCount&&!self.viewModel.isNoMoreData&&!self.viewModel.isRequesting) {
        //  在这个地方调用加载更多数据的方法。
        [self checkRequestMethodIsReload:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLGoodModel *model = self.viewModel.goodListArray[indexPath.row];
    YBLGoodPicViewController *picVC = [YBLGoodPicViewController new];
    picVC.pModel = model;
    picVC.goodCategoryType = self.viewModel.goodCategoryType;
    [self.VC.navigationController pushViewController:picVC animated:YES];
    
    
    if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
        采购订单
        [self pushEditPurchaseVCWithModel:model];
    }
     /
}

- (void)pushEditPurchaseVCWithModel:(YBLGoodModel *)model{

    YBLEdictPurchaseViewModel *viewModel = [YBLEdictPurchaseViewModel new];
    viewModel.goodModel = model;
    YBLEditPurchaseViewController *editPurchaseVC = [YBLEditPurchaseViewController new];
    editPurchaseVC.viewModel = viewModel;
    [self.VC.navigationController pushViewController:editPurchaseVC animated:YES];
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_good";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有此商品数据哦~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
*/
@end

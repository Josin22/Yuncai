//
//  YBLStoreListService.m
//  YC168
//
//  Created by 乔同新 on 2017/5/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreListService.h"
#import "YBLStoreListViewModel.h"
#import "YBLStoreListViewController.h"
#import "YBLSearchNavView.h"
#import "YBLGoodSearchView.h"
#import "YBLStoreListCell.h"
#import "shop.h"
#import "YBLStoreViewController.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreTableView.h"

@interface YBLStoreListService ()<YBLTableViewDelegate>

@property (nonatomic, weak) YBLStoreListViewModel *viewModel;

@property (nonatomic, weak) YBLStoreListViewController *Vc;

@property (nonatomic, strong) YBLSearchNavView *searchView;

@property (nonatomic, strong) YBLStoreTableView *storeTableView;

@end

@implementation YBLStoreListService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLStoreListViewModel *)viewModel;
        _Vc = (YBLStoreListViewController *)VC;
        
        self.Vc.navigationItem.titleView = self.searchView;
        
        [self requestData];
    }
    return self;
}

- (void)requestData{
    
    WEAK
    [[self.viewModel siganlForStoreData] subscribeError:^(NSError * _Nullable error) {
    } completed:^{
        STRONG
        self.storeTableView.dataArray = self.viewModel.storeDataArray;
        [self.storeTableView jsReloadData];
    }];
}

- (YBLSearchNavView *)searchView{
    
    if (!_searchView) {
        
        WEAK
        _searchView = [[YBLSearchNavView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
        _searchView.titleLabel.text = self.viewModel.storeName;
        _searchView.searchBlock = ^{
            STRONG
            [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeNoView
                                                          SearchHandle:^(NSString *searchText,SearchType searchType){
                                                              STRONG
                                                              self.searchView.titleLabel.text = searchText;
                                                              self.viewModel.storeName = searchText;
                                                              //重新搜索店铺
                                                              [self requestData];
                                                          }
                                                          cancleHandle:^{
                                                              
                                                          }
                                                    animationEndHandle:^{
                                                        
                                                    }
                                                           currentText:self.searchView.titleLabel.text];
            
        };

    }
    return _searchView;
}

- (YBLStoreTableView *)storeTableView{
    
    if (!_storeTableView) {
        _storeTableView = [[YBLStoreTableView alloc] initWithFrame:[self.Vc.view bounds]
                                                             style:UITableViewStyleGrouped
                                                          listType:StoreListTypeSearch];
        _storeTableView.ybl_delegate = self;
        [self.Vc.view addSubview:_storeTableView];
        
    }
    return _storeTableView;
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLGoodModel *goodModel = (YBLGoodModel *)selectValue;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = goodModel.id;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.Vc.navigationController pushViewController:goodDetailVC animated:YES];
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    shop *shopModel = (shop *)selectValue;
    YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
    viewModel.shopid = shopModel.shopid;
    YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
    storeVC.viewModel = viewModel;
    [self.Vc.navigationController pushViewController:storeVC animated:YES];
}

/*
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.storeDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return space;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLStoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreListCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLStoreListCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    shop *shopModel = self.viewModel.storeDataArray[indexPath.section];
    [cell updateItemCellModel:shopModel];
    WEAK
    //点击商品
    cell.storeListGoodClickBlock = ^(YBLGoodModel *selectGoodModel){
        STRONG
        YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
        viewModel.goodID = selectGoodModel.id;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [self.Vc.navigationController pushViewController:goodDetailVC animated:YES];
    };
    //点击店铺
    [[[cell.inStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
        viewModel.shopid = shopModel.shopid;
        YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
        storeVC.viewModel = viewModel;
        [self.Vc.navigationController pushViewController:storeVC animated:YES];
    }];
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_store";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉,没有搜到店铺~";
    
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
*/
@end

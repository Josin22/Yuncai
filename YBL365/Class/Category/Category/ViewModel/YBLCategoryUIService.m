//
//  YBLCategoryUIService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryUIService.h"
#import "YBLCategoryViewController.h"
#import "YBLCategoryRightView.h"
#import "YBLCategoryViewModel.h"
#import "YBLHomeNavigationView.h"
#import "YBLScanQRCodeViewController.h"
#import "YBLGoodSearchView.h"
#import "YBLGoodListViewController.h"
#import "YBLStoreListViewController.h"
#import "YBLSearchNavView.h"
#import "YBLAddGoodListViewController.h"


static CGFloat const Left_Space = 80;
static CGFloat const Left_Space_Intert = 8;

@interface YBLCategoryUIService (){
    
    CGFloat Top_Height;
    CGFloat header_search_top;
}

@property (nonatomic, weak  ) YBLCategoryViewController *categoryVC;
@property (nonatomic, weak  ) YBLCategoryViewModel *viewModel;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSString *selectedId;

@property (nonatomic, strong) YBLHomeNavigationView *homeCategorySearchView;
@property (nonatomic, strong) YBLSearchNavView *categorySearchView;;

@end

@implementation YBLCategoryUIService


- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        _categoryVC = (YBLCategoryViewController *)VC;
        _viewModel = (YBLCategoryViewModel *)viewModel;
        
        self.selectedIndex = 0;
        self.selectedId = @"0";
        header_search_top = 0;
        
        switch (self.viewModel.goodCategoryType) {
            case GoodCategoryTypeForHomeCategory:
            {
                Top_Height = kNavigationbarHeight+kBottomBarHeight;
                header_search_top = self.homeCategorySearchView.height;
                [self.categoryVC.view addSubview:self.homeCategorySearchView];
            }
                break;
            case GoodCategoryTypeForCommodityPoolCategory:
            {
//                self.categoryVC.navigationItem.title = @"添加商品";
                Top_Height = kNavigationbarHeight;
                self.categoryVC.navigationItem.titleView = self.categorySearchView;
                self.categorySearchView.titleLabel.text = @"搜索商品";

            }
                break;
            case GoodCategoryTypeForPurchaseWithTabbar:
            {
                self.categoryVC.navigationItem.title = @"选择采购商品";
                Top_Height = kNavigationbarHeight+kBottomBarHeight;
            }
                break;
            case GoodCategoryTypeForPurchaseWithOutTabbar:
            {
//                self.categoryVC.navigationItem.title = @"选择采购商品";
                self.categoryVC.navigationItem.titleView = self.categorySearchView;
                self.categorySearchView.titleLabel.text = @"搜索采购商品";
                Top_Height = kNavigationbarHeight;
            }
                break;
                
            default:
                break;
        }
        
        [self createSubviews];
    
        [self requestCategory];
    }
    return self;
}

- (void)requestCategory{
    WEAK
    [[self.viewModel singalForCategoryTreeWithId:self.selectedId Index:self.selectedIndex] subscribeError:^(NSError *error) {
        [self.rightTableView.mj_header endRefreshing];
    } completed:^{
        STRONG
        if ([self.selectedId isEqualToString:@"0"]) {
            self.leftTableView.leftDataArray = self.viewModel.topCategoryArray;
        }
        self.rightTableView.rightDataArray = self.viewModel.allSubTreeCategoryDict[@(self.selectedIndex)];
        [self.rightTableView.mj_header endRefreshing];
    }];
}

- (YBLSearchNavView *)categorySearchView{
    
    if (!_categorySearchView) {
        WEAK
        _categorySearchView = [[YBLSearchNavView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
        _categorySearchView.searchBlock = ^{
            
            [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeNoView
                                                          SearchHandle:^(NSString *searchText,SearchType searchType){
                                                              STRONG
                                                              //
                                                              YBLAddGoodListViewModel *viewModel = [YBLAddGoodListViewModel new];
                                                              viewModel.keyword = searchText;
                                                              viewModel.goodCategoryType = self.viewModel.goodCategoryType;
                                                              YBLAddGoodListViewController *addGoodListVC = [YBLAddGoodListViewController new];
                                                              addGoodListVC.viewModel = viewModel;
                                                              [YBLMethodTools pushVC:addGoodListVC FromeUndefineVC:self.categoryVC];
                                                          }
                                                          cancleHandle:^{
                                                          }
                                                    animationEndHandle:^{
                                                    }
                                                           currentText:nil];
            
        };
        
    }
    return _categorySearchView;
}


- (YBLHomeNavigationView *)homeCategorySearchView{
    
    if (!_homeCategorySearchView) {
        _homeCategorySearchView = [[YBLHomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight) navigationType:NavigationTypeCatgory];
        WEAK
        //扫一扫
        [[_homeCategorySearchView.scanButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            YBLScanQRCodeViewController *scanVC = [[YBLScanQRCodeViewController alloc] init];
            [self.categoryVC.navigationController pushViewController:scanVC animated:YES];
        }];
        //消息
        [[_homeCategorySearchView.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
        }];
        //搜索
        [[_homeCategorySearchView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            self.self.homeCategorySearchView.searchButton.hidden = YES;
            [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeCatgeoryNews
                                                          SearchHandle:^(NSString *searchText,SearchType searchType){
                                                              if (searchType == SearchTypeGood) {
                                                                  //商品
                                                                  YBLGoodListViewModel *viewModel = [YBLGoodListViewModel new];
                                                                  viewModel.keyWord = searchText;
                                                                  YBLGoodListViewController *listVC = [YBLGoodListViewController new];
                                                                  listVC.viewModel = viewModel;
                                                                  [self.categoryVC.navigationController pushViewController:listVC animated:YES];
                                                              } else {
                                                                  //店铺
                                                                  YBLStoreListViewModel *store_view_model = [YBLStoreListViewModel new];
                                                                  store_view_model.storeName = searchText;
                                                                  YBLStoreListViewController *store_vc = [YBLStoreListViewController new];
                                                                  store_vc.viewModel = store_view_model;
                                                                  [self.categoryVC.navigationController pushViewController:store_vc animated:YES];
                                                              }

                                                              
                                                          }
                                                          cancleHandle:^{
                                                              [self.self.self.homeCategorySearchView transFormMassageButtonOrgin];
                                                          }
                                                    animationEndHandle:^{
                                                        self.self.self.homeCategorySearchView.searchButton.hidden = NO;
                                                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
                                                    }
                                                           currentText:nil];
            
        }];
        
    }
    return _homeCategorySearchView;
}


- (void)createSubviews {
    
    self.leftTableView = [[YBLCategoryLeftView alloc] initWithFrame:CGRectMake(0, header_search_top, Left_Space,YBLWindowHeight) style:UITableViewStylePlain];
    self.leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.leftTableView.width, Top_Height)];
    [self.categoryVC.view addSubview:self.leftTableView];
    self.leftTableView.backgroundColor = YBLViewBGColor;
    WEAK
    self.leftTableView.cellClickBlock = ^(NSInteger index,NSString *_id){
        STRONG
        self.selectedIndex = index;
        self.selectedId = _id;
        NSMutableArray *depth2Array = self.viewModel.allSubTreeCategoryDict[@(self.selectedIndex)];
        if (!depth2Array) {
            [self requestCategory];
        } else {
            self.rightTableView.rightDataArray = depth2Array;
        }
    };
    
    CGFloat rightWi = YBLWindowWidth - self.leftTableView.right-Left_Space_Intert*2;
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.minimumLineSpacing = 0;
    fl.minimumInteritemSpacing = 0;
    fl.itemSize = CGSizeMake(rightWi/3.0, (rightWi-6)/3.0);
    fl.headerReferenceSize = CGSizeMake(rightWi, 44);
    self.rightTableView = [[YBLCategoryRightView alloc] initWithFrame:CGRectMake(self.leftTableView.right+Left_Space_Intert, self.leftTableView.top, rightWi, self.leftTableView.height)
                                                 collectionViewLayout:fl
                                                           typeHeader:TypeHeaderNone];
    self.rightTableView.contentInset = UIEdgeInsetsMake(0, 0, Top_Height, 0);
    [self.categoryVC.view addSubview:self.rightTableView];
    self.rightTableView.itemClickBlock = ^(YBLCategoryTreeModel *item){
        STRONG
        
        if (self.viewModel.goodCategoryType == GoodCategoryTypeForHomeCategory) {
            YBLGoodListViewModel *viewModel = [YBLGoodListViewModel new];
            viewModel.category_id = item.id;
            //        viewModel.keyWord = item.title;
            YBLGoodListViewController *listVC = [[YBLGoodListViewController alloc] init];
            listVC.viewModel = viewModel;
            [self.categoryVC.navigationController pushViewController:listVC animated:YES];
            
        } else {
            YBLAddGoodListViewModel *viewModel = [YBLAddGoodListViewModel new];
            viewModel.category_id = item.id;
            viewModel.goodCategoryType = self.viewModel.goodCategoryType;
            YBLAddGoodListViewController *addGoodListVC = [YBLAddGoodListViewController new];
            addGoodListVC.viewModel = viewModel;
            [YBLMethodTools pushVC:addGoodListVC FromeUndefineVC:self.categoryVC];
        }
        /*
        YBLAddGoodListViewModel *viewModel = [YBLAddGoodListViewModel new];
        viewModel.category_id = model.id;
        viewModel.goodCategoryType = self.viewModel.goodCategoryType;
        YBLAddGoodListViewController *addGoodListVC = [YBLAddGoodListViewController new];
        addGoodListVC.viewModel = viewModel;
        [YBLMethodTools pushVC:addGoodListVC FromeUndefineVC:self];
         */
    };


    /**/
    [YBLMethodTools headerRefreshWithTableView:self.rightTableView
                                    completion:^{
                                        STRONG
                                        [self requestCategory];
                                    }];
}

@end

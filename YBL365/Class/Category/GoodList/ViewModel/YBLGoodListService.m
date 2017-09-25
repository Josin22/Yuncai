//
//  YBLGoodListService.m
//  YC168
//
//  Created by 乔同新 on 2017/5/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodListService.h"
#import "YBLGoodListViewModel.h"
#import "YBLGoodListViewController.h"
#import "YBLGoodSearchView.h"
#import "YBLSearchNavView.h"
#import "YBLGoodsListCollectionView.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreListViewController.h"
#import "YBLGoodListFilterItemHeadView.h"
#import "YBLPageLabel.h"

@interface YBLGoodListService ()

@property (nonatomic, weak  ) YBLGoodListViewModel *viewModel;

@property (nonatomic, weak  ) YBLGoodListViewController *Vc;

@property (nonatomic, strong) YBLSearchNavView *searchView;

@property (nonatomic, strong) YBLGoodsListCollectionView *goodListCollectionView;

@property (nonatomic, strong) YBLGoodListFilterItemHeadView *headerView;

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, retain) YBLPageLabel *pageLabel;

@end

@implementation YBLGoodListService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLGoodListViewModel *)viewModel;
        _Vc = (YBLGoodListViewController *)VC;
        
        [self createNavigationBar];
        
        [self requestSearchDataAgain:YES];
    
    }
    return self;
}

- (void)requestSearchDataAgain:(BOOL)isNewSearch{
    WEAK
    [[self.viewModel siganlForSearchGoodsAgain:isNewSearch] subscribeNext:^(NSMutableArray*  _Nullable x) {
        STRONG
        self.goodListCollectionView.dataArray = self.viewModel.searchDataArray;
        NSInteger currentPageCount = 1;
        if (self.viewModel.isNoMoreData) {
            currentPageCount = self.viewModel.page_list-1;
        } else {
            currentPageCount = self.viewModel.page_list;
        }
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)currentPageCount,(long)self.viewModel.page_count+1];
        if (isNewSearch) {
            [self.goodListCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        if (isNewSearch||self.goodListCollectionView.dataArray.count!=0) {
            [self.goodListCollectionView jsReloadData];
        } else {
            [self.goodListCollectionView insertItemsAtIndexPaths:x];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (YBLPageLabel *)pageLabel{
    if (!_pageLabel) {
        _pageLabel = [[YBLPageLabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
        _pageLabel.centerX = self.Vc.view.width/2;
        _pageLabel.bottom = self.topButton.bottom;
        _pageLabel.hidden = YES;
        [self.Vc.view addSubview:_pageLabel];
    }
    return _pageLabel;
}

- (UIButton *)topButton{
    
    if (!_topButton) {
        _topButton = [YBLMethodTools getButtonWithImage:@"home_tuijian_top_icon"];
        _topButton.right = YBLWindowWidth-space*1.5;
        _topButton.bottom = YBLWindowHeight-kNavigationbarHeight-space*1.5-40;
        [self.Vc.view addSubview:_topButton];
        _topButton.hidden = YES;
        WEAK
        [[_topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self.goodListCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }];
    }
    return _topButton;
}

- (void)createNavigationBar {
    WEAK
    YBLSearchNavView *searchView = [[YBLSearchNavView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
    self.Vc.navigationItem.titleView = searchView;
    if (self.viewModel.keyWord) {
        searchView.titleLabel.text = self.viewModel.keyWord;   
    }
    searchView.searchBlock = ^{
        STRONG
        NSString *searDefaultText = nil;
        if (![self.searchView.titleLabel.text hasPrefix:@"搜索云采"]) {
            searDefaultText = self.searchView.titleLabel.text;
        }
        [YBLGoodSearchView showGoodSearchViewWithRightItemViewType:rightItemViewTypeNone
                                                      SearchHandle:^(NSString *searchText,SearchType searchType){
                                                          STRONG
                                                          
                                                          if (searchType == SearchTypeStore) {
                                                              //店铺
                                                              YBLStoreListViewModel *store_view_model = [YBLStoreListViewModel new];
                                                              store_view_model.storeName = searchText;
                                                              YBLStoreListViewController *store_vc = [YBLStoreListViewController new];
                                                              store_vc.viewModel = store_view_model;
                                                              [self.Vc.navigationController pushViewController:store_vc animated:YES];
                                                          } else {
                                                              self.searchView.titleLabel.text = searchText;
                                                              self.viewModel.keyWord = searchText;
                                                              self.viewModel.category_id = nil;
                                                              [self requestSearchDataAgain:YES];
                                                          }
                                                      }
                                                      cancleHandle:^{
                                                          
                                                      }
                                                animationEndHandle:^{
                                                    
                                                }
                                                       currentText:searDefaultText];
        
    };
    self.searchView = searchView;
    
    UIButton *changeWayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeWayButton setImage:[UIImage imageNamed:@"product_list_top_list"] forState:UIControlStateNormal];
    [changeWayButton setImage:[UIImage imageNamed:@"product_list_top_grid"] forState:UIControlStateSelected];
    changeWayButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    self.Vc.navigationItem.rightBarButtonItems = @[negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:changeWayButton]];
    [[changeWayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIControl* x) {
        x.selected = !x.selected;
        self.goodListCollectionView.isListType = x.selected;
    }];
    
}

- (YBLGoodListFilterItemHeadView *)headerView{
    if (!_headerView) {
        _headerView = [[YBLGoodListFilterItemHeadView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)];
        [self.Vc.view addSubview:_headerView];
        kWeakSelf(self)
        _headerView.categoryListHeadViewItemClickBlock = ^(NSString *buttonTitle, CurrentButtonState currentButtonState) {
            kStrongSelf(self)
            if ([buttonTitle isEqualToString:key_composite]) {
                self.viewModel.orderSequenceText = OrderSequenceTextComposite;
            } else if ([buttonTitle isEqualToString:key_sale_count]) {
                self.viewModel.orderSequenceText = OrderSequenceTextSaleCount;
            } else if ([buttonTitle isEqualToString:key_price]) {
                self.viewModel.orderSequenceText = OrderSequenceTextPrice;
            }
            switch (currentButtonState) {
                    
                case CurrentButtonStateClickFirstOnce:
                {
                    self.viewModel.orderSequence = OrderSequenceAscending;
                }
                    break;
                case CurrentButtonStateClickLastOnce:
                {
                    self.viewModel.orderSequence = OrderSequenceDescending;
                }
                    break;
                    
                default:
                    break;
            }
            [self requestSearchDataAgain:YES];
        };
    }
    return _headerView;
}

- (YBLGoodsListCollectionView *)goodListCollectionView{
    
    if (!_goodListCollectionView) {
        _goodListCollectionView = [[YBLGoodsListCollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.Vc.view.width, YBLWindowHeight-kNavigationbarHeight)
                                                                     collectionType:CollectionTypeNormalGood];
        WEAK
        [self.Vc.view addSubview:_goodListCollectionView];
        _goodListCollectionView.goodsListCollectionViewCellDidSelectBlock = ^(NSIndexPath *selectIndexPath, id model) {
            STRONG
            YBLGoodModel *goodModel  = (YBLGoodModel *)model;
            YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
            viewModel.goodID = goodModel.id;
            YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
            goodDetailVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:goodDetailVC animated:YES];
        };
        _goodListCollectionView.viewPrestrainBlock = ^{
            STRONG
            if (!self.viewModel.isNoMoreData&&!self.viewModel.isReqesuting) {
                [self requestSearchDataAgain:NO];
            }
        };
        CGFloat navbar_space = 100;
        _goodListCollectionView.goodsListCollectionViewScrollBlock = ^(UIScrollView *scrollView) {
            STRONG
            int currentPostion = scrollView.contentOffset.y;
            if (currentPostion - self.viewModel.lastPosition > navbar_space) {
                self.viewModel.lastPosition = currentPostion;
                [self hiddenNavbar];
                self.topButton.hidden = YES;
            }
            else if (self.viewModel.lastPosition - currentPostion > navbar_space)
            {
                self.viewModel.lastPosition = currentPostion;
                [self showNavBar];
                self.topButton.hidden = NO;
            } else if (currentPostion <= navbar_space){
                self.topButton.hidden = YES;
            }
            self.pageLabel.hidden = NO;
        };
        _goodListCollectionView.goodsListCollectionViewScrollDidEndBlock = ^(UIScrollView *scrollView) {
            STRONG
            self.pageLabel.hidden = YES;
        };
        
    }
    return _goodListCollectionView;
}

- (void)hiddenNavbar{
    if (self.headerView.bottom == 0) {
        return;
    }
    //hidden navbar
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.Vc.navigationController setNavigationBarHidden:YES];
                         self.headerView.bottom = 0;
                         self.goodListCollectionView.top = 20;
                         self.goodListCollectionView.height = self.Vc.view.height-20;
                         self.pageLabel.bottom = self.Vc.view.height-2*space;
                         self.topButton.bottom = self.pageLabel.bottom;
                     }
                     completion:^(BOOL finished) {}];
    
}

- (void)showNavBar{
    
    if (self.headerView.top == 0) {
        return;
    }
    [UIView animateWithDuration:.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self.Vc.navigationController setNavigationBarHidden:NO];
                         self.headerView.top = 0;
                         self.goodListCollectionView.top = self.headerView.bottom;
                         self.goodListCollectionView.height = YBLWindowHeight-kNavigationbarHeight;
                         self.pageLabel.bottom = self.goodListCollectionView.height-2*space;
                         self.topButton.bottom = self.pageLabel.bottom;
                     }
                     completion:^(BOOL finished) {
                         
                     }];


}


@end

//
//  YBLHomeUIService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLHomeUIService.h"
#import "YBLHomeViewController.h"
#import "YBLHomeModuleCell.h"
#import "YBLHomeSeckillCell.h"
#import "YBLHomeButtonsCell.h"
#import "YBLHomeBannerCell.h"
#import "YBLHomeViewModel.h"
#import "YBLModuleTitleView.h"
#import "YBLHomeFooterView.h"
#import "YBLShopCarModel.h"
#import "YBLSeckillViewController.h"
#import "YBLShopCarViewController.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLCategoryItemCell.h"
#import "YBLTwotageMuduleViewController.h"
#import "YBLStoreBankeViewController.h"
#import "YBLIWantMoneyViewController.h"
#import "YBLIWantDistributionViewController.h"
#import "YBLIntentionAgentViewController.h"
#import "YBLFurtureMoneyViewController.h"
#import "YBLHomeNavigationView.h"
#import "YBLAPPViewModel.h"
#import "YBLScanQRCodeViewController.h"
#import "YBLFoucsStoreView.h"
#import "YBLGoodSearchView.h"
#import "YBLGoodListViewController.h"
#import "YBLExpressNewsCell.h"
#import "YBLFoundTabBarViewController.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLFoundViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLStoreListViewController.h"
#import "YBLMineMillionMessageViewController.h"

@interface YBLHomeUIService ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    BOOL isOver;
}
@property (nonatomic, weak) YBLHomeViewController *homeVC;

@property (nonatomic, weak) YBLHomeViewModel *viewModel;

@property (nonatomic, strong) YBLHomeNavigationView *navigationView;//自定义导航条

@property (nonatomic, strong) YBLButton *topCommandButton;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YBLHomeUIService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _homeVC = (YBLHomeViewController *)VC;
        _viewModel = (YBLHomeViewModel *)viewModel;
        
        [_homeVC.view addSubview:self.homeCollectionView];
        
        //添加定时任务
        [self startTimer];
        
        RACSignal *deallocSiganl_viewWillDisappear = [self.homeVC rac_signalForSelector:@selector(viewWillDisappear:)];
        RACSignal *deallocSiganl_viewWillappear = [self.homeVC rac_signalForSelector:@selector(viewWillAppear:)];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:deallocSiganl_viewWillDisappear] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"UIApplicationDidEnterBackgroundNotification");
            [self stopTimer];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:deallocSiganl_viewWillappear] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"UIApplicationDidEnterBackgroundNotification");
            [self startTimer];
        }];

        
        //创建首页NAVAR
        [self createNavigationBar];
        /**
         *  请求
         */
        [self requestHomeData];
        
    }
    return self;
}

- (void)getNewOrderBulletsData{
    /*订单弹幕*/
    WEAK
    [self.viewModel.ordersBullet subscribeError:^(NSError * _Nullable error) {
        [self.homeCollectionView.mj_header endRefreshing];
    } completed:^{
        STRONG
        [self.homeCollectionView.mj_header endRefreshing];
//        [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self.homeCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    }];
}

- (void)startTimer{
    
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(getNewOrderBulletsData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    self.viewModel.isRunBullets = NO;
    [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (void)stopTimer{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.viewModel.isRunBullets = YES;
    [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


- (void)requestHomeData{
    
    /*楼层数据*/
    WEAK
    [self.viewModel.floorsSignal subscribeNext:^(NSNumber*  _Nullable x) {
        [self.homeCollectionView.mj_header endRefreshing];
        if (x.integerValue==0) {
            [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        } else {
            [self.homeCollectionView jsReloadData];   
        }
    } error:^(NSError * _Nullable error) {
        [self.homeCollectionView.mj_header endRefreshing];
    }];
    /*采购推送*/
    [self.viewModel.purchasePushSiganl subscribeNext:^(NSArray*  _Nullable x) {
        STRONG
        [self.homeCollectionView.mj_header endRefreshing];
        [self.homeCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } error:^(NSError * _Nullable error) {
        [self.homeCollectionView.mj_header endRefreshing];
    }];
    
    [self getNewOrderBulletsData];
}

/**
 *  创建导航栏
 */
- (void)createNavigationBar {
    
    self.navigationView = [[YBLHomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight) navigationType:NavigationTypeHome];
    [self.homeVC.view addSubview:self.navigationView];
    WEAK
    //扫一扫
    [[self.navigationView.scanButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        YBLScanQRCodeViewController *scanVC = [[YBLScanQRCodeViewController alloc] init];
        [self.homeVC.navigationController pushViewController:scanVC animated:YES];
    }];
    //消息
    [[self.navigationView.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    //搜索
    [[self.navigationView.searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        self.navigationView.searchButton.hidden = YES;
        [YBLGoodSearchView showGoodSearchViewWithVC:self.homeVC
                                  RightItemViewType:rightItemViewTypeHomeNews
                                                      SearchHandle:^(NSString *searchText,SearchType searchType){
                                                      }
                                                      cancleHandle:^{
                                                          [self.navigationView transFormMassageButtonOrgin];
                                                      }
                                                 animationEndHandle:^{
                                                     self.navigationView.searchButton.hidden = NO;
                                                     if (isOver) {
                                                         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
                                                     } else {
                                                         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
                                                     }
                                                 }
                                                       currentText:nil];

    }];
    
}

- (YBLButton *)topCommandButton{
    if (!_topCommandButton) {
        _topCommandButton = [YBLMethodTools getTopAndCommandButton];
        _topCommandButton.right = YBLWindowWidth-space;
        _topCommandButton.bottom = YBLWindowHeight-kBottomBarHeight-space;
        [self.homeVC.view addSubview:_topCommandButton];
        WEAK
        [[_topCommandButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if (x.selected) {
                //滚推荐
                CGFloat finalContentY = 0;
                if (self.viewModel.firstCommandPoint==0) {
                    self.viewModel.firstCommandPoint = self.homeCollectionView.contentSize.height - self.homeCollectionView.frame.size.height;
                }
                finalContentY = self.viewModel.firstCommandPoint;
                NSInteger lastIndex = self.viewModel.cell_data_dict.count-1;
                YBLListBaseModel *lastModel = self.viewModel.cell_data_dict[@(lastIndex)];
                if (lastModel.identifyOfSectionCellItemArray.count>4) {
                    finalContentY += YBLWindowHeight-kBottomBarHeight-kNavigationbarHeight-kBottomBarHeight;
                }
                [self.homeCollectionView setContentOffset:CGPointMake(0, finalContentY) animated:YES];
            } else {
                //滚首页
                [self.homeCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            x.selected = !x.selected;
        }];
    }
    return _topCommandButton;
}

#pragma mark - lazy load view

- (UICollectionView *)homeCollectionView{
    
    if (!_homeCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:[self.homeVC.view bounds] collectionViewLayout:layout];
        _homeCollectionView.dataSource = self;
        _homeCollectionView.delegate   = self;
        _homeCollectionView.backgroundColor = YBLViewBGColor;
        _homeCollectionView.showsVerticalScrollIndicator = NO;
        _homeCollectionView.pagingEnabled = NO;
        NSArray *cellIDArray = @[
                                 @"YBLHomeBannerCell",
                                 @"YBLHomeButtonsCell",
                                 @"YBLHomeSeckillCell",
                                 @"YBLHomeModuleCell",
                                 @"YBLCategoryItemCell",
                                 @"YBLExpressNewsCell"
                                 ];
        for (NSString *cellID in cellIDArray) {
            [_homeCollectionView registerClass:NSClassFromString(cellID) forCellWithReuseIdentifier:cellID];
        }
        [_homeCollectionView registerClass:NSClassFromString(@"YBLModuleTitleView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YBLModuleTitleView"];
        [_homeCollectionView registerClass:NSClassFromString(@"YBLHomeFooterView") forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"YBLHomeFooterView"];
        WEAK
        [YBLMethodTools footerRefreshWithTableView:_homeCollectionView completion:^{
            STRONG
            [self loadCommandMore];
        }];
        [YBLMethodTools headerRefreshWithTableView:_homeCollectionView completion:^{
            STRONG
            [self requestHomeData];
        }];
    }
    return _homeCollectionView;
}

- (void)loadCommandMore{
    //推荐
    WEAK
    [[self.viewModel siganlForProductRecommend] subscribeNext:^(NSMutableArray*  _Nullable x) {
        STRONG
        [self.homeCollectionView insertItemsAtIndexPaths:x];
        if (x.count==0) {
            [self.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.homeCollectionView.mj_footer endRefreshing];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
}


#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

//    [YBLFoucsStoreView dismissFoucsView];
    
    CGFloat cellOffy = scrollView.contentOffset.y;
    self.contentY = cellOffy;
    if(cellOffy < 0) {
        self.navigationView.hidden = true;
        return ;
    }else{
        self.navigationView.hidden = false;
    }
    
    if (cellOffy > NAVBAR_CHANGE_POINT) {
        if(isOver) return ;
        isOver = true;
        [self.navigationView changeColorWithState:YES];
        self.navigationView.backgroundColor = YBLColor(255, 255, 255, 0.8);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:true];
    }else {
        CGFloat alpa = cellOffy/NAVBAR_CHANGE_POINT;
        if (alpa > 0.8) {
            self.navigationView.backgroundColor = YBLColor(255, 255, 255, 0.8);
            return ;
        }
        [self.navigationView changeColorWithState:NO];
        isOver = false;
        self.navigationView.backgroundColor = YBLColor(255, 255, 255, alpa);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:true];
    }

}

#pragma mark -
#pragma mark  colleoction datasource/delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return [self.viewModel.cell_data_dict count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    return [sectionModel.identifyOfSectionCellItemArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[row];
    NSString *cellName = cellModel.identifyOfRowItemCell;
    
    if (section>2&&section<=self.viewModel.cell_data_dict.count-2) {
        self.topCommandButton.selected = YES;
        self.topCommandButton.hidden = NO;
    } else if (section >= self.viewModel.cell_data_dict.count-1){
        self.topCommandButton.selected = NO;
        self.topCommandButton.hidden = NO;
    } else {
        self.topCommandButton.hidden = YES;
    }
    
    WEAK
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];;
    
    if ([cellName isEqualToString:@"YBLHomeBannerCell"]) {
        YBLHomeBannerCell *bannerCell = (YBLHomeBannerCell *)cell;
        bannerCell.barrageView.dataArray = self.viewModel.oderBulletArray;
        bannerCell.barrageView.isStopRunning = self.viewModel.isRunBullets;
        bannerCell.homeVC = self.homeVC;
        
    }else if([cellName isEqualToString:@"YBLHomeButtonsCell"]){
        YBLHomeButtonsCell *buttonsCell = (YBLHomeButtonsCell *)cell;
        buttonsCell.buttonsClickBlock = ^(NSInteger index) {
            STRONG
            NSString *className = self.viewModel.buttonClassNameArray[index];
            id classVc;
            if ([className isEqualToString:@"YBLMineMillionMessageViewController"]) {
                if (![YBLMethodTools checkLoginWithVc:self.homeVC]) {
                    return;
                }
                YBLMineMillionMessageViewModel *viewModel = [YBLMineMillionMessageViewModel new];
                viewModel.millionType = MillionTypePublic;
                YBLMineMillionMessageViewController *millionVc = [YBLMineMillionMessageViewController new];
                millionVc.viewModel = viewModel;
                classVc = millionVc;
            } else {
                if ([className isEqualToString:@"YBLCouponsCenterViewController"]) {
                    if (![YBLMethodTools checkLoginWithVc:self.homeVC]) {
                        return;
                    }
                }
                classVc = [NSClassFromString(className) new];
            }
            [self.homeVC.navigationController pushViewController:classVc animated:YES];
        };
        
    }else if([cellName isEqualToString:@"YBLExpressNewsCell"]){
        
        YBLExpressNewsCell *expressCell = (YBLExpressNewsCell *)cell;
        
        [[[expressCell.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            YBLFoundTabBarViewController *foundTabBarVC = [YBLFoundTabBarViewController new];
            [self.homeVC.navigationController pushViewController:foundTabBarVC animated:YES];
        }];
        
        expressCell.expressNewsCellScrollClickBlock = ^(YBLPushPurchaseInfoModel *infoModel) {
            STRONG
            if (![YBLMethodTools checkLoginWithVc:self.homeVC]) {
                return ;
            }
            YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
            YBLPurchaseOrderModel *purchseModel = [YBLPurchaseOrderModel new];
            purchseModel._id = infoModel.id;
            viewModel.purchaseDetailModel = purchseModel;
            YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
            detailVC.viewModel = viewModel;
            [self.homeVC.navigationController pushViewController:detailVC animated:YES];
        };

        
    }else if([cellName isEqualToString:@"YBLHomeSeckillCell"]){
        
//        YBLHomeSeckillCell *seckillCell = (YBLHomeSeckillCell *)cell;
        
    } else if([cellName isEqualToString:@"YBLHomeModuleCell"]){
        
        YBLHomeModuleCell *moduleCell = (YBLHomeModuleCell *)cell;
        moduleCell.moduleClickblock = ^(NSInteger index){
            STRONG
            [self reciveIndex:index section:section];
        };
        
    } else  if([cellName isEqualToString:@"YBLCategoryItemCell"]){
        
        YBLCategoryItemCell *recommendGoodCell = (YBLCategoryItemCell *)cell;
        recommendGoodCell.isListType = NO;
    }
    
    
    [cell updateItemCellModel:cellModel];
    
    return cell;
    
}

/*
- (void)getBannerCell:(YBLHomeBannerCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    [cell updateBannerArray:self.viewModel.bannerAdsArray bannerURLArray:self.viewModel.bannerAdsURLArray];
    
}

#pragma mark 按钮

- (void)getButtonsCell:(YBLHomeButtonsCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    cell.buttonsClickBlock = ^(NSInteger index){
        switch (index) {
            case 0:
            {
                YBLStoreBankeViewController *storeBankeVC = [YBLStoreBankeViewController new];
                [self.homeVC.navigationController pushViewController:storeBankeVC animated:YES];
            }
                break;
            case 1:
            {
                YBLFurtureMoneyViewController *furtureVC = [YBLFurtureMoneyViewController new];
                [self.homeVC.navigationController pushViewController:furtureVC animated:YES];
            }
                break;
            case 2:
            {
                YBLIWantDistributionViewController *storeBankeVC = [YBLIWantDistributionViewController new];
                [self.homeVC.navigationController pushViewController:storeBankeVC animated:YES];
            }
                break;
            case 3:
            {
                YBLIWantMoneyViewController *storeBankeVC = [YBLIWantMoneyViewController new];
                [self.homeVC.navigationController pushViewController:storeBankeVC animated:YES];
            }
                break;
            case 4:
            {
                YBLIntentionAgentViewController *storeBankeVC = [YBLIntentionAgentViewController new];
                [self.homeVC.navigationController pushViewController:storeBankeVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    
}

- (void)getExpressNewsCell:(YBLExpressNewsCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    cell.dataArray = self.viewModel.purchasePushDataArray;
    
    WEAK
    [[[cell.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        YBLFoundTabBarViewController *foundTabBarVC = [YBLFoundTabBarViewController new];
        [self.homeVC.navigationController pushViewController:foundTabBarVC animated:YES];
    }];
    
    cell.expressNewsCellScrollClickBlock = ^(YBLPushPurchaseInfoModel *infoModel) {
        STRONG
        if (![YBLMethodTools checkLoginWithVc:self.homeVC]) {
            return ;
        }
        YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
        YBLPurchaseOrderModel *purchseModel = [YBLPurchaseOrderModel new];
        purchseModel._id = infoModel.id;
        viewModel.purchaseDetailModel = purchseModel;
        YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
        detailVC.viewModel = viewModel;
        [self.homeVC.navigationController pushViewController:detailVC animated:YES];
    };
    
}

#pragma mark 秒杀

- (void)getSeckillCell:(YBLHomeSeckillCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    WEAK
    cell.homeSeckillClickBlock = ^(NSInteger index){
      ///秒杀
        STRONG
        YBLSeckillViewController *seckillVC = [[YBLSeckillViewController alloc] init];
        [self.homeVC.navigationController pushViewController:seckillVC animated:YES];
    };
    
}

#pragma mark 模块活动

- (void)getModuleCell:(YBLHomeModuleCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSArray *itemArray = self.viewModel.cell_identity_dict[@(section)][0][cell_content_data_key];
    [cell updateFloorsModuleArray:[itemArray mutableCopy]];
    WEAK
    cell.moduleClickblock = ^(NSInteger index){
        STRONG
        [self reciveIndex:index section:section];
    };
    
}
#pragma mark 为你推荐

- (void)getRecommendGoodCell:(YBLCategoryItemCell *)cell indexPath:(NSIndexPath *)indexPath{
//    [cell updateWithGood:self.viewModel.tempRecommendArray[indexPath.row]];
    
}
    
*/

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section  = indexPath.section;
//    NSInteger row  = indexPath.row;
    UICollectionReusableView *reusableview = nil;

    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if ([sectionModel.identifyOfSectionItemHeaderView isEqualToString:@"YBLModuleTitleView"]) {
            YBLModuleTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                withReuseIdentifier:sectionModel.identifyOfSectionItemHeaderView
                                                                                       forIndexPath:indexPath];
            [headerView updateModuleTitleImageValue:sectionModel.valueOfSectionItemHeaderViewData];
            WEAK
            [[[headerView.moduleTitleButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                STRONG
                [self reciveIndex:0 section:section];
            }];
            reusableview = headerView;
        }
        
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if ([sectionModel.identifyOfSectionItemFooterView isEqualToString:@"YBLHomeFooterView"]) {
            YBLHomeFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                           withReuseIdentifier:sectionModel.identifyOfSectionItemFooterView
                                                                                  forIndexPath:indexPath];
            
            reusableview = footer;
        }
    }
    return reusableview;
}

- (void)reciveIndex:(NSInteger)index section:(NSInteger)section{
    
    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLFloorsModel *floorModel = sectionModel.valueOfSectionItemHeaderViewData;
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[0];
    NSArray *moduleArray =cellModel.valueOfRowItemCellData;
    YBLTwotageMuduleViewModel *viewModel = [[YBLTwotageMuduleViewModel alloc] init];
    viewModel.moduleArray = moduleArray.mutableCopy;
    viewModel.index = index;
    viewModel.titleText = floorModel.title;
    viewModel.titleImageUrl = floorModel.avatar;
    YBLTwotageMuduleViewController *twoMudleVC = [[YBLTwotageMuduleViewController alloc] init];
    twoMudleVC.viewModel = viewModel;
    [self.homeVC.navigationController pushViewController:twoMudleVC animated:YES];
}


#pragma mark - flowlayout
/**
 *  代理方法计算每一个item的大小
 */
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[row];
    NSString *cellName = cellModel.identifyOfRowItemCell;
    
    if ([cellName isEqualToString:@"YBLHomeBannerCell"]) {
        
        return CGSizeMake(YBLWindowWidth, [YBLHomeBannerCell getItemCellHeightWithModel:cellModel]);
        
    }else if([cellName isEqualToString:@"YBLHomeButtonsCell"]){
        
        return CGSizeMake(YBLWindowWidth, [YBLHomeButtonsCell getItemCellHeightWithModel:cellModel]);
        
    }else if([cellName isEqualToString:@"YBLExpressNewsCell"]){
        
        return CGSizeMake(YBLWindowWidth, [YBLExpressNewsCell getItemCellHeightWithModel:cellModel]);
        
    }  else if([cellName isEqualToString:@"YBLHomeSeckillCell"]){
        
        return CGSizeMake(YBLWindowWidth, [YBLHomeSeckillCell getItemCellHeightWithModel:cellModel]);
        
    } else if([cellName isEqualToString:@"YBLHomeModuleCell"]){
        return CGSizeMake(YBLWindowWidth, [YBLHomeModuleCell getItemCellHeightWithModel:cellModel]);
        
    } else if([cellName isEqualToString:@"YBLCategoryItemCell"]){
        
        CGFloat width = (YBLWindowWidth-15)/2;
        CGFloat hi = [YBLCategoryItemCell getItemCellHeightWithModel:cellModel];
        return CGSizeMake(width, hi);
        
    } else {
        return CGSizeZero;
    }
    
}
//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{

    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[0];
    NSString *cellName = cellModel.identifyOfRowItemCell;
    if ([cellName isEqualToString:@"YBLCategoryItemCell"]){
        return UIEdgeInsetsMake(5, 5, 0, 5);
    }
    return UIEdgeInsetsZero;
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{

    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    if ([sectionModel.identifyOfSectionItemHeaderView isEqualToString:@"YBLModuleTitleView"]){
       return  CGSizeMake(YBLWindowWidth, [YBLModuleTitleView getModuleHeight]);
    }
    return CGSizeZero;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section{

    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    if ([sectionModel.identifyOfSectionItemFooterView isEqualToString:@"YBLHomeFooterView"]){
      return  CGSizeMake(YBLWindowWidth, [YBLHomeFooterView getHomeFooterHeight]);
    }
    return CGSizeZero;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[0];
    NSString *cellName = cellModel.identifyOfRowItemCell;
    if ([cellName isEqualToString:@"YBLCategoryItemCell"]){
        return 5;
    }
    return 0;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[0];
    NSString *cellName = cellModel.identifyOfRowItemCell;
    if ([cellName isEqualToString:@"YBLCategoryItemCell"]){
        return 5;
    }
    return 0;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    YBLListBaseModel *sectionModel = self.viewModel.cell_data_dict[@(section)];
    YBLListCellItemModel *cellModel = sectionModel.identifyOfSectionCellItemArray[row];
    NSString *cellName = cellModel.identifyOfRowItemCell;
    if ([cellName isEqualToString:@"YBLCategoryItemCell"]){
        ///为你推荐商品点击
        YBLGoodModel *goodModel = cellModel.valueOfRowItemCellData;
        YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
        viewModel.goodID = goodModel.id;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [self.homeVC.navigationController pushViewController:goodDetailVC animated:YES];
        
    }
//    else if ([cellName isEqualToString:@"YBLHomeModuleCell"]){
//    
//        
//    }
    
}

@end

//
//  YBLFoundUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLFoundUIService.h"
#import "YBLTextSegmentControl.h"
#import "YBLPurchaseOrderCollectionView.h"
#import "YBLFoundSegmentSPECView.h"
#import "YBLFoundViewController.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLChooseCityView.h"
#import "YBLReverseOrderBanner.h"
#import "YBLFoundViewModel.h"
#import "YBLSeckillCategoryView.h"
#import "YBLFoundViewModel.h"
#import "YBLFourLevelAreaView.h"
#import "YBLGoodGridFlowLayout.h"
#import "YBLPurchaseOrderMMCell.h"

static NSInteger collectionView_tag = 487468873;


@interface YBLFoundUIService ()<YBLTextSegmentControlDelegate,UIScrollViewDelegate>
{
    CGFloat bannerHi;
}

@property (nonatomic, strong) YBLTextSegmentControl  *textSegmentControl;

@property (nonatomic, strong) UIScrollView           *seckillScrollView;

@property (nonatomic, weak  ) YBLFoundViewController *VC;

@property (nonatomic, strong) UIScrollView           *bannerScrollView;

@property (nonatomic, strong) YBLReverseOrderBanner  *reverseOrderBanner;

@property (nonatomic, weak  ) YBLFoundViewModel      *viewModel;

@property (nonatomic, strong) NSTimer                *timer;

@end

@implementation YBLFoundUIService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLFoundViewController *)VC;
        _viewModel = (YBLFoundViewModel *)viewModel;
        
        [VC.view addSubview:self.textSegmentControl];
        [VC.view insertSubview:self.seckillScrollView belowSubview:self.textSegmentControl];
        [VC.view insertSubview:self.bannerScrollView belowSubview:self.textSegmentControl];
        
        self.viewModel.currentFoundIndex = 0;
 
        //
        [self newPurchaseDataCount];
        
        //添加定时任务
        self.timer = [NSTimer timerWithTimeInterval:7.0*5 target:self selector:@selector(newPurchaseDataCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        [self checkPurchaseCollectionViewIsExsitWithIndex:0 isReload:YES];
        
        RACSignal *deallocSiganl_viewWillDisappear = [self.VC rac_signalForSelector:@selector(viewWillDisappear:)];
        RACSignal *deallocSiganl_viewWillappear = [self.VC rac_signalForSelector:@selector(viewWillAppear:)];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:deallocSiganl_viewWillDisappear] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"UIApplicationDidEnterBackgroundNotification");
            [self destroyTimer];
        }];
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] takeUntil:deallocSiganl_viewWillappear] subscribeNext:^(NSNotification * _Nullable x) {
            NSLog(@"UIApplicationDidEnterBackgroundNotification");
            [self addTimer];
        }];
        
        WEAK
        [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
            STRONG
            self.textSegmentControl.enableSegment = !x.boolValue;
        }];
    }
    return self;
}


- (void)addTimer{
    
    if (!self.timer) {
        self.timer = [NSTimer timerWithTimeInterval:7.0*5 target:self selector:@selector(newPurchaseDataCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    [self.reverseOrderBanner addTimer];
}

- (void)destroyTimer{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.reverseOrderBanner removeTimer];
}

- (void)newPurchaseDataCount{
    WEAK
    [[self.viewModel signalForPurchaseDataCount] subscribeError:^(NSError *error) {
        
    } completed:^{
        STRONG
        self.reverseOrderBanner.purchaseDataCountModel = self.viewModel.dataModel;
    }];
}

- (YBLTextSegmentControl *)textSegmentControl{
    
    if (!_textSegmentControl) {
        _textSegmentControl = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40)
                                                           TextSegmentType:TextSegmentTypeLocationArrow];
        _textSegmentControl.delegate = self;
        WEAK
        _textSegmentControl.textSegmentControlShowAllBlock = ^(BOOL isShow){
            STRONG
            [YBLChooseCityView chooseCityWithViewController:self.VC.navigationController
                                                  cityCount:2
                                               cityViewType:ChooseCityViewTypeWithDoneButton
                                               successBlock:^(YBLAddressAreaModel *model, NSMutableArray *selectArray) {
                                                    STRONG
                                                   self.textSegmentControl.selectLocation = model.text;
                                                   self.viewModel.area_id = [NSString stringWithFormat:@"%@",model.id];
                                                   if (selectArray.count==1) {
                                                       self.viewModel.area_type = @"province";
                                                   } else if (selectArray.count==2){
                                                       self.viewModel.area_type = @"city";
                                                   } else {
                                                       self.viewModel.area_type = nil;
                                                   }
                                                   [self requestDataWithIndex:self.viewModel.currentFoundIndex isReload:YES];
                                               }];
            /*
            if (isShow && self.viewModel.all_title_data_array.count>1) {
                
                [YBLSeckillCategoryView showCategoryViewOnView:self.VC.view
                                                     DataArray:self.viewModel.all_title_data_array
                                                   SelectIndex:self.viewModel.currentFoundIndex
                                                   SelectBlock:^(NSString *selectTitlte, NSInteger selectIndex) {
                                                       STRONG
                                                       self.viewModel.currentFoundIndex = selectIndex;
                                                       [self.textSegmentControl defaultView];
                                                       self.viewModel.selectTitle = selectTitlte;
                                                       self.textSegmentControl.currentIndex = self.viewModel.currentFoundIndex;
                                                   }
                                                  DismissBlock:^{
                                                      STRONG
                                                      [self.textSegmentControl defaultView];
                                                  }];
                
            } else {
                
                [YBLSeckillCategoryView dismissView];
            }
             */
            
        };
    }
    return _textSegmentControl;
}

- (UIScrollView *)seckillScrollView{
    
    if (!_seckillScrollView) {
        _seckillScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegmentControl.bottom, self.bannerScrollView.width, YBLWindowHeight-self.textSegmentControl.height-kBottomBarHeight)];
        _seckillScrollView.pagingEnabled = YES;
        _seckillScrollView.showsHorizontalScrollIndicator = NO;
        _seckillScrollView.alwaysBounceHorizontal = YES;
        _seckillScrollView.delegate = self;
        _seckillScrollView.backgroundColor = self.VC.view.backgroundColor;
//        [_seckillScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.VC.tabBarController.navigationController.interactivePopGestureRecognizer];
//        _seckillScrollView.contentSize = CGSizeMake(YBLWindowWidth*tempCount, _seckillScrollView.height);
    }
    return _seckillScrollView;
}

- (UIScrollView *)bannerScrollView{
    
    if (!_bannerScrollView) {
        UIImage *bannebg1 = [UIImage imageNamed:@"banner_bg1"];
        CGFloat hi = (double)bannebg1.size.height/bannebg1.size.width*YBLWindowWidth;
        bannerHi = hi;
        _bannerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegmentControl.bottom, YBLWindowWidth, hi)];
        _bannerScrollView.scrollEnabled = NO;
        _bannerScrollView.contentSize = CGSizeMake(YBLWindowWidth, hi);
        self.reverseOrderBanner = [[YBLReverseOrderBanner alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, hi)];
        [_bannerScrollView addSubview:self.reverseOrderBanner];
    }
    return _bannerScrollView;
}

#pragma mark - method

- (void)checkPurchaseCollectionViewIsExsitWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    //1.检查data
    NSMutableArray *current_data_array = [self.viewModel getCurrentDataArrayWithIndex:index];
//    YBLPurchaseOrderCollectionView *exsit_collectionView = [self getCurrentCollectionViewWithIndex:index];
    if (current_data_array.count==0) {
        //1.2请求数据
        [self requestDataWithIndex:index isReload:isReload];
    }
}

- (void)requestDataWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    
    WEAK
    __block YBLPurchaseOrderCollectionView *collectionView = [self getCurrentCollectionViewWithIndex:index];
    [[self.viewModel signalForAllPurchaseOrderWithIndex:index isReload:isReload] subscribeNext:^(NSMutableArray*  _Nullable x) {
        STRONG
        if (!collectionView) {
            //2.1不存在 add
            collectionView = [self getPurchaseCollectionView:index];
            [self.seckillScrollView addSubview:collectionView];
            self.seckillScrollView.contentSize = CGSizeMake(self.seckillScrollView.width*self.viewModel.all_title_data_array.count, self.seckillScrollView.height);
        } else {
            [collectionView.mj_header endRefreshing];
        }
        //2.2赋值
        NSMutableArray *current_data_array = [self.viewModel getCurrentDataArrayWithIndex:index];
        collectionView.dataArray = current_data_array;
        if (isReload||!x) {
            [collectionView jsReloadData];
        } else {
            [collectionView insertItemsAtIndexPaths:x];
        }
        [self.textSegmentControl updateTitleData:self.viewModel.all_title_data_array];

    } error:^(NSError * _Nullable error) {
//        YBLPurchaseOrderCollectionView *exsit_collectionView = [self getCurrentCollectionViewWithIndex:index];
        [collectionView.mj_header endRefreshing];
    }];
    
}


//获取当前collectionview
- (YBLPurchaseOrderCollectionView *)getCurrentCollectionViewWithIndex:(NSInteger)index{
    YBLPurchaseOrderCollectionView *checkCollectionView = (YBLPurchaseOrderCollectionView *)[self.VC.view viewWithTag:collectionView_tag+index];
    return checkCollectionView;
}

//生成collectionview
- (YBLPurchaseOrderCollectionView *)getPurchaseCollectionView:(NSInteger)index{
    
    YBLGoodGridFlowLayout *layout = [YBLGoodGridFlowLayout new];
    CGSize iiSize = layout.itemSize;
    iiSize.height += space;
    layout.itemSize = iiSize;
    YBLPurchaseOrderCollectionView *orderMMCollectionView = [[YBLPurchaseOrderCollectionView alloc] initWithFrame:CGRectMake(self.seckillScrollView.width* index, 0, self.seckillScrollView.width, self.seckillScrollView.height)
                                                                                 collectionViewLayout:layout
                                                                                               MMType:MMTypeNoneHeader];
    orderMMCollectionView.contentInset = UIEdgeInsetsMake(self.bannerScrollView.height, 0, 0, 0);
    orderMMCollectionView.tag = collectionView_tag+index;
    kWeakSelf(self)
    orderMMCollectionView.orderMMCollectionViewRowSelectblock = ^(YBLPurchaseOrderModel *model){
        kStrongSelf(self)
        if ([YBLMethodTools checkLoginWithVc:self.VC]) {
            YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
            viewModel.purchaseDetailModel = model;
            YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
            detailVC.viewModel = viewModel;
            [YBLMethodTools pushVC:detailVC FromeUndefineVC:self.VC];
        }
    };
    orderMMCollectionView.orderMMCollectionViewScrollBlock = ^(UIScrollView *scrollView){
        kStrongSelf(self)
        CGFloat contentY = scrollView.contentOffset.y;
        if (-contentY<=bannerHi&&-contentY>=0) {
            self.bannerScrollView.top = self.textSegmentControl.bottom-(bannerHi+contentY);
        } else if(-contentY<0){
            self.bannerScrollView.top = self.textSegmentControl.bottom-bannerHi;
        } else if (-contentY>bannerHi) {
            self.bannerScrollView.top = self.textSegmentControl.bottom;
        }
    };
    orderMMCollectionView.viewPrestrainBlock = ^{
        kStrongSelf(self)
        BOOL isNomoreData = [self.viewModel.all_is_nomore_data_dict[@(index)] boolValue];
        if (!isNomoreData&&!self.viewModel.isReqesuting) {
            [self requestDataWithIndex:index isReload:NO];
        }
    };
    /**
     *  下拉刷新
     */
    [YBLMethodTools headerRefreshWithTableView:orderMMCollectionView completion:^{
        kStrongSelf(self)
        [self requestDataWithIndex:index isReload:YES];
        [self newPurchaseDataCount];
    }];
    
    return orderMMCollectionView;
}

#pragma mark -  seg delegate

- (void)textSegmentControlIndex:(NSInteger)index{
    
    self.viewModel.currentFoundIndex = index;
    [self.seckillScrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
    self.viewModel.selectTitle = self.viewModel.all_title_data_array[index];
    self.bannerScrollView.top = self.textSegmentControl.bottom;
    [self checkPurchaseCollectionViewIsExsitWithIndex:index isReload:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    if (self.viewModel.currentFoundIndex != index) {
        self.textSegmentControl.currentIndex = index;
//        self.viewModel.selectTitle = self.viewModel.all_title_data_array[index];
//        self.viewModel.currentFoundIndex = index;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.bannerScrollView.top = self.textSegmentControl.bottom;
}

@end

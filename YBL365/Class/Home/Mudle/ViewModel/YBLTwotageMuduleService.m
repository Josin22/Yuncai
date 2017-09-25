//
//  YBLTwotageMuduleService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTwotageMuduleService.h"
#import "YBLTwotageMuduleViewController.h"
#import "YBLGoodsListCollectionView.h"
#import "YBLTextSegmentControl.h"
#import "YBLFloorsModel.h"
#import "YBLGoodsDetailViewController.h"

static const NSInteger collectionView_tag = 4242;

@interface YBLTwotageMuduleService ()<YBLTextSegmentControlDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) YBLTwotageMuduleViewController *VC;

@property (nonatomic, strong) UIScrollView *goodListScrollView;

@property (nonatomic, strong) YBLTextSegmentControl *textSegment;

@property (nonatomic, strong) YBLTwotageMuduleViewModel *viewModel;

@end

@implementation YBLTwotageMuduleService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
     
        _VC = (YBLTwotageMuduleViewController *)VC;
        _viewModel = (YBLTwotageMuduleViewModel *)viewModel;
        
        [_VC.view addSubview:self.textSegment];
        [_VC.view addSubview:self.goodListScrollView];
        
        if (self.viewModel.index == 0) {
            [self checkModuleDataViewIsExsitWithIndex:0];
        } else {
            self.textSegment.currentIndex = self.viewModel.index;
        }
    
        WEAK
        [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
            STRONG
            self.textSegment.enableSegment = !x.boolValue;
        }];
    }
    return self;
}

- (UIScrollView *)goodListScrollView{
    
    if (!_goodListScrollView) {
        _goodListScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegment.bottom, self.textSegment.width, YBLWindowHeight-self.textSegment.height)];
        _goodListScrollView.pagingEnabled = YES;
        _goodListScrollView.delegate = self;
        _goodListScrollView.showsVerticalScrollIndicator = NO;
        _goodListScrollView.contentSize = CGSizeMake(_goodListScrollView.width*self.viewModel.moduleArray.count, _goodListScrollView.height);
        [_goodListScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.VC.navigationController.interactivePopGestureRecognizer];
    }
    return _goodListScrollView;
}

- (YBLTextSegmentControl *)textSegment{
    
    if (!_textSegment) {
        _textSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40) TextSegmentType:TextSegmentTypeNoArrow];
        _textSegment.delegate = self;
        NSMutableArray *titleArray = [NSMutableArray array];
        for (YBLFloorsModel *floorsModel in self.viewModel.moduleArray) {
            [titleArray addObject:floorsModel.title];
        }
        [_textSegment updateTitleData:titleArray];
        
    }
    return _textSegment;
}

#pragma mark - delegate

- (void)textSegmentControlIndex:(NSInteger)index{

    [self.goodListScrollView setContentOffset:CGPointMake(self.goodListScrollView.width*index, 0) animated:YES];
    
    [self checkModuleDataViewIsExsitWithIndex:index];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.goodListScrollView.width;
    self.textSegment.currentIndex = index;
}

#pragma mark - method

- (void)checkModuleDataViewIsExsitWithIndex:(NSInteger)index{
    
    NSMutableArray *currentDataArray = [self.viewModel getSingleItemDataArrayWithIndex:index];
    if (currentDataArray.count == 0) {
        [self getModuleDataWithIndex:index isReload:YES];
    } 
}

- (void)getModuleDataWithIndex:(NSInteger)index isReload:(BOOL)isReload{
    
    [[self.viewModel siganlForGoodListIdex:index isReload:isReload] subscribeNext:^(NSMutableArray*  _Nullable x) {
        
        YBLGoodsListCollectionView *collectionView = [self.VC.view viewWithTag:collectionView_tag+index];
        NSMutableArray *dataArray = [self.viewModel getSingleItemDataArrayWithIndex:index];
        if (!collectionView) {
            YBLGoodsListCollectionView *collectionView = [self getCollectionViewWithIndex:index];
            collectionView.dataArray = dataArray;
            [self.goodListScrollView addSubview:collectionView];;
        }else {
            collectionView.dataArray = dataArray;
        }
        [collectionView.mj_header endRefreshing];
        if (isReload) {
            [collectionView jsReloadData];
        } else {
            if (x.count>0) {
                [collectionView insertItemsAtIndexPaths:x];
            }
        }
        
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (YBLGoodsListCollectionView *)getCollectionViewWithIndex:(NSInteger)index{
    
    YBLGoodsListCollectionView *goodListCollection = [[YBLGoodsListCollectionView alloc]initWithFrame:CGRectMake(self.goodListScrollView.width*index, 0, self.goodListScrollView.width, self.goodListScrollView.height)
                                                                                  collectionType:CollectionTypeNormalGood];
    goodListCollection.tag = collectionView_tag+index;
    WEAK
    goodListCollection.goodsListCollectionViewCellDidSelectBlock = ^(NSIndexPath *selectIndexPath, id model) {
        STRONG
        YBLGoodModel *goodModel  = (YBLGoodModel *)model;
        YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
        viewModel.goodID = goodModel.id;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [self.VC.navigationController pushViewController:goodDetailVC animated:YES];
    };
    goodListCollection.viewPrestrainBlock = ^{
        STRONG
        BOOL isNomoreData = [self.viewModel.allModuleNoMoreDataDict[@(index)] boolValue];
        if (!isNomoreData&&!self.viewModel.isReqesuting) {
            [self getModuleDataWithIndex:self.textSegment.currentIndex isReload:NO];
        }
    };
    /**
     *  下拉刷新
     */
    [YBLMethodTools headerRefreshWithTableView:goodListCollection completion:^{
        STRONG
        [self getModuleDataWithIndex:self.textSegment.currentIndex isReload:YES];
    }];
    
    return goodListCollection;

}

@end


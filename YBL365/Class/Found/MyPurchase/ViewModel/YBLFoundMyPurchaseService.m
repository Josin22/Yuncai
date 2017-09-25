//
//  YBLFoundPurchaseService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundMyPurchaseService.h"
#import "YBLFoundMyPurchaseViewController.h"
#import "YBLSingleTextSegment.h"
#import "YBLMyPurchaseTableView.h"
#import "YBLMyPurchaseViewModel.h"
#import "YBLFooterSignView.h"
#import "YBLPopView.h"

static NSInteger const tag_tableview = 231;

@interface YBLFoundMyPurchaseService ()<UIScrollViewDelegate,YBLSingleTextSegmentDelegate>

@property (nonatomic, weak  ) YBLFoundMyPurchaseViewController *VC;

@property (nonatomic, weak  ) YBLMyPurchaseViewModel           *viewModel;

@property (nonatomic, strong) YBLSingleTextSegment             *textSegment;

@property (nonatomic, strong) UIScrollView                     *scrollView;

@end

@implementation YBLFoundMyPurchaseService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLFoundMyPurchaseViewController *)VC;
        _viewModel = (YBLMyPurchaseViewModel *)viewModel;
        
        [_VC.view addSubview:self.textSegment];
        [_VC.view addSubview:self.scrollView];
    
        [self requestMyPurchaseOrderIsReload:YES];
        
        WEAK
        [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
            STRONG
            self.textSegment.enableSegment = !x.boolValue;
        }];
    }
    return self;
}

- (void)requestMyPurchaseOrderIsReload:(BOOL)isReload{
    
    WEAK
    [[self.viewModel siganlForPersonPurchaseOrderIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        YBLMyPurchaseTableView *purchaseTabelView = [self getCurrentPurchaseTabelVieWith:self.viewModel.currentFoundIndex];
        [purchaseTabelView.mj_header endRefreshing];
        NSMutableArray *data = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        purchaseTabelView.dataArray = data;
        if (!data||isReload) {
            [purchaseTabelView reloadData];
        } else {
            [purchaseTabelView jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } error:^(NSError * _Nullable error) {
        
    }];
    
}

- (YBLSingleTextSegment *)textSegment{
    
    if (!_textSegment) {
        _textSegment = [[YBLSingleTextSegment alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 45) TitleArray:self.viewModel.titleArray[0]];
        _textSegment.backgroundColor = [UIColor whiteColor];
        _textSegment.delegate = self;
        _textSegment.enableSegment = YES;
    }
    return _textSegment;
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.textSegment.bottom, self.VC.view.width, self.VC.view.height-self.textSegment.bottom)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = self.VC.view.backgroundColor;
        _scrollView.contentSize = CGSizeMake(_scrollView.width*2, _scrollView.height);
    }
    return _scrollView;
}

- (YBLMyPurchaseTableView *)getCurrentPurchaseTabelVieWith:(NSInteger)index{
    
    YBLMyPurchaseTableView *purchaseTableView = (YBLMyPurchaseTableView *)[self.VC.view viewWithTag:tag_tableview+index];
    if (!purchaseTableView) {
        purchaseTableView = [[YBLMyPurchaseTableView alloc] initWithFrame:[self.scrollView bounds]
                                                                    style:UITableViewStylePlain
                                                             PurchaseType:index];
        purchaseTableView.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, purchaseTableView.width, kNavigationbarHeight+self.textSegment.bottom)];
        purchaseTableView.left = self.scrollView.width*index;
        WEAK
        purchaseTableView.myPurchasePrestrainBlock = ^{
            STRONG
            if ([self.viewModel isSatisfyRequestWithIndex:self.viewModel.currentFoundIndex]) {
                [self requestMyPurchaseOrderIsReload:NO];
            }
        };
        //shangla
        [YBLMethodTools headerRefreshWithTableView:purchaseTableView completion:^{
            STRONG
            [self requestMyPurchaseOrderIsReload:YES];
        }];
        purchaseTableView.tag = tag_tableview+index;
        purchaseTableView.VC = self.VC;
        purchaseTableView.viewModel = self.viewModel;
        [self.scrollView addSubview:purchaseTableView];
    }
    return purchaseTableView;
}
#pragma mark - delegate
- (void)CurrentSegIndex:(NSInteger)index{
    self.viewModel.currentFoundIndex = index;
    [self.scrollView setContentOffset:CGPointMake(YBLWindowWidth *index, 0) animated:YES];
    NSMutableArray *data = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
    if (data.count==0) {
        [self requestMyPurchaseOrderIsReload:YES];
    }
}

- (void)CurrentSegIndexReclick:(NSInteger)index{
    NSLog(@"CurrentSegIndexReclick:%@",@(index));
    NSArray *showTitleArray = [self.viewModel getCurrentTitleWithIndex:index];
    WEAK
    [YBLPopView showWithPoint:CGPointMake(YBLWindowWidth/4+(YBLWindowWidth/2)*index, kNavigationbarHeight+self.textSegment.bottom)
                       titles:showTitleArray
                       images:nil
                    doneBlock:^(NSInteger selectIndex) {
                        STRONG
                        NSString *selectTitle = showTitleArray[selectIndex];
                        [self.textSegment repalceTitleWith:selectTitle repIndex:index];
                        [self.viewModel handleSegValueWithIndex:index selectIndex:selectIndex];
                        [self requestMyPurchaseOrderIsReload:YES];
                    } dismissBlock:^{
         
                    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / YBLWindowWidth;
    self.textSegment.currentInex = index;
}
 
/*
 - (void)requestIsReload:(BOOL)isReload{
 
 WEAK
 YBLMyPurchaseTableView *purchaseTbv = (YBLMyPurchaseTableView *)[self.VC.view viewWithTag:tag_tableview+currentMyPurchaseIndex];
 BOOL isAllRecords = NO;
 if (self.viewModel.myPurchaseType == MyPurchaseTypePurchaseAllRecords) {
 isAllRecords = YES;
 }
 [[self.viewModel signalForPersonalPurchaseOrderWithIndex:currentMyPurchaseIndex isReload:isReload isAllRecords:isAllRecords] subscribeNext:^(NSMutableArray*  _Nullable x) {
 STRONG
 NSMutableArray *dataArray = self.viewModel.personalPurchaseOrderDict[@(currentMyPurchaseIndex)];
 purchaseTbv.dataArray = dataArray;
 //        [purchaseTbv jsReloadData];
 if (isReload) {
 [purchaseTbv jsReloadData];
 } else {
 [purchaseTbv jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
 }
 [purchaseTbv.mj_header endRefreshing];
 } error:^(NSError * _Nullable error) {
 [purchaseTbv.mj_header endRefreshing];
 }];
 
 [[self.viewModel signalForPersonalPurchaseOrderWithIndex:currentMyPurchaseIndex isReload:isReload isAllRecords:isAllRecords] subscribeError:^(NSError * _Nullable error) {
 [purchaseTbv.mj_header endRefreshing];
 } completed:^{
 STRONG
 NSMutableArray *dataArray = self.viewModel.personalPurchaseOrderDict[@(currentMyPurchaseIndex)];
 purchaseTbv.dataArray = dataArray;
 [purchaseTbv.mj_header endRefreshing];
 }];
 
 }
 */

@end

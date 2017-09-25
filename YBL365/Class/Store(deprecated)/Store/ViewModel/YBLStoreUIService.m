//
//  YBLStoreUIService.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreUIService.h"
#import "YBLStoreGoodsViewController.h"
#import "YBLStorePromotionViewController.h"
#import "YBLStoreNewViewController.h"
#import "YBLStoreShopDynamicViewController.h"
#import "YBLStoreHomeViewController.h"
#import "YBLStoreHeaderView.h"
#import "YBLStoreBottomView.h"
#import "YBLStoreCollectView.h"
#import "YBLStoreDetailViewController.h"

static CGFloat const tableHederHeight = 100;

@interface YBLStoreUIService ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) YBLStoreHeaderView * stroeTableHeaderView;
@property (nonatomic, strong) YBLStoreBottomView * storeBottomView;
@property (nonatomic, strong) YBLStoreCollectView * collectView;
@property (nonatomic, strong) YBLStoreHomeViewController * storeHomeVC;
@property (nonatomic, strong) YBLStoreGoodsViewController * storeGoodsVC;
@property (nonatomic, strong) YBLStorePromotionViewController * storePromotionVC;
@property (nonatomic, strong) YBLStoreNewViewController * storeNewVC;
@property (nonatomic, strong) YBLStoreShopDynamicViewController * storeShopDynamicVC;
@property (nonatomic, assign) CGFloat contentY;
@end

@implementation YBLStoreUIService

- (instancetype)init {
    if (self = [super init]) {
        self.contentY = -64;
        [self addSubViews];
    }
    return self;
}

- (YBLStoreHeaderView *)stroeTableHeaderView {
    if (!_stroeTableHeaderView) {
        _stroeTableHeaderView = [[YBLStoreHeaderView alloc]initWithFrame:CGRectMake(0, 64, YBLWindowWidth, tableHederHeight *ZOOM_SCALE+50)];
        _stroeTableHeaderView.backgroundColor = [UIColor whiteColor];
        
    }
    return _stroeTableHeaderView;
}

- (void)addSubViews {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64+tableHederHeight*ZOOM_SCALE+50, YBLWindowWidth,YBLWindowHeight-tableHederHeight*ZOOM_SCALE-50-64)];
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    
    for (int i = 0; i<3; i++) {
        if (i == 0) {
            _storeGoodsVC = [[YBLStoreGoodsViewController alloc]init];
            [_storeVC addChildViewController:_storeGoodsVC];
            _storeGoodsVC.view.frame = CGRectMake(YBLWindowWidth* i, 0, YBLWindowWidth, _scrollView.height);
            [_storeGoodsVC updateFeameWithY:_scrollView.height];
            [_scrollView addSubview:_storeGoodsVC.view];
            WEAK
            _storeGoodsVC.scrollYBlock = ^(CGFloat alpha,
                                           UIScrollView * scrollView) {
                STRONG
                [self scrollWithContentY:alpha scrollView:scrollView];
            };
        }
        if (i == 1) {
            _storePromotionVC = [[YBLStorePromotionViewController alloc]init];
            [_storeVC addChildViewController:_storePromotionVC];
            _storePromotionVC.view.frame = CGRectMake(YBLWindowWidth* i, 0, YBLWindowWidth, _scrollView.height);
            [_storePromotionVC updateFeameWithY:_scrollView.height];
            [_scrollView addSubview:_storePromotionVC.view];
            WEAK
            _storePromotionVC.scrollYBlock = ^(CGFloat alpha,
                                               UIScrollView * scrollView) {
                STRONG
                [self scrollWithContentY:alpha scrollView:scrollView];
            };
        }
        if (i == 2) {
            _storeNewVC = [[YBLStoreNewViewController alloc]init];
            [_storeVC addChildViewController:_storeNewVC];
            _storeNewVC.view.frame = CGRectMake(YBLWindowWidth* i, 0, YBLWindowWidth, _scrollView.height);
            [_storeNewVC updateFeameWithY:_scrollView.height];
            [_scrollView addSubview:_storeNewVC.view];
            WEAK
            _storeNewVC.scrollYBlock = ^(CGFloat alpha,
                                         UIScrollView *scrollView) {
                STRONG
                [self scrollWithContentY:alpha scrollView:scrollView];
            };
        }
    }
    _scrollView.contentSize = CGSizeMake(YBLWindowWidth*3, YBLWindowHeight-tableHederHeight*ZOOM_SCALE-50-64);
}

- (void)setStoreVC:(YBLStoreViewController *)storeVC {
    _storeVC = storeVC;
    [_storeVC.view addSubview:self.stroeTableHeaderView];
    [_storeVC.view addSubview:self.scrollView];
    WEAK
    _stroeTableHeaderView.storeDetailBlock = ^() {
        STRONG
        YBLStoreDetailViewController * storeDetailVC = [[YBLStoreDetailViewController alloc]init];
        [self.storeVC.navigationController pushViewController:storeDetailVC animated:YES];
    };
    _stroeTableHeaderView.classifyButtonBlock = ^(NSInteger selectIndex,
                                                  BOOL isSelect) {
        STRONG
        if (selectIndex == 3) {
            self.storeGoodsVC.isChangeList = isSelect;
        }else {
            self.scrollView.contentOffset = CGPointMake(YBLWindowWidth * selectIndex, 0);
        }
    };
}


- (void)scrollWithContentY:(CGFloat)contentY scrollView:(UIScrollView *)scrollView {
    
    NSLog(@"celloff:%@",@(scrollView.contentOffset.y));
    
    if (contentY <= 0) {
        return;
    }
    
    if (contentY+scrollView.height >= scrollView.contentSize.height) {
        return;
    }
    
    if (contentY - self.contentY >= 30) {
        self.contentY = contentY;
        if (self.stroeTableHeaderView.top == 64) {
            [UIView animateWithDuration:.5f delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.stroeTableHeaderView.top = -tableHederHeight *ZOOM_SCALE+64;
                                 self.scrollView.frame = CGRectMake(0, 64+50, YBLWindowWidth, YBLWindowHeight - 64-50);
                                 _storeGoodsVC.view.frame = CGRectMake(0, 0, YBLWindowWidth, self.scrollView.height);
                                 _storePromotionVC.view.frame = CGRectMake(YBLWindowWidth, 0, YBLWindowWidth, self.scrollView.height);
                                 _storeNewVC.view.frame = CGRectMake(YBLWindowWidth*2, 0, YBLWindowWidth, self.scrollView.height);
                                 [_storeGoodsVC updateFeameWithY:_scrollView.height];
                                 [_storePromotionVC updateFeameWithY:_scrollView.height];
                                 [_storeNewVC updateFeameWithY:_scrollView.height];
                   
                             } completion:^(BOOL finished) {
                                 
                             }];
          
        }
    }else if (self.contentY - contentY >= 30){
        self.contentY = contentY;
        if (self.stroeTableHeaderView.top == 64-tableHederHeight *ZOOM_SCALE) {
            [UIView animateWithDuration:.5f delay:0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.stroeTableHeaderView.top = 64;
                                 self.scrollView.frame = CGRectMake(0, self.stroeTableHeaderView.bottom, YBLWindowWidth, YBLWindowHeight-self.stroeTableHeaderView.bottom);
                                 _storeGoodsVC.view.frame = CGRectMake(0, 0, YBLWindowWidth, self.scrollView.height);
                                 _storePromotionVC.view.frame = CGRectMake(YBLWindowWidth, 0, YBLWindowWidth, self.scrollView.height);
                                 _storeNewVC.view.frame = CGRectMake(YBLWindowWidth*2, 0, YBLWindowWidth, self.scrollView.height);
                                 [_storeGoodsVC updateFeameWithY:_scrollView.height];
                                 [_storePromotionVC updateFeameWithY:_scrollView.height];
                                 [_storeNewVC updateFeameWithY:_scrollView.height];
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
            /*
            [UIView animateWithDuration:.5f animations:^{
                self.stroeTableHeaderView.top = 64;
                self.scrollView.frame = CGRectMake(0, self.stroeTableHeaderView.bottom, YBLWindowWidth, YBLWindowHeight-self.stroeTableHeaderView.bottom);
                _storeGoodsVC.view.frame = CGRectMake(0, 0, YBLWindowWidth, self.scrollView.height);
                _storePromotionVC.view.frame = CGRectMake(YBLWindowWidth, 0, YBLWindowWidth, self.scrollView.height);
                _storeNewVC.view.frame = CGRectMake(YBLWindowWidth*2, 0, YBLWindowWidth, self.scrollView.height);
                [_storeGoodsVC updateFeameWithY:_scrollView.height];
                [_storePromotionVC updateFeameWithY:_scrollView.height];
                [_storeNewVC updateFeameWithY:_scrollView.height];
            }];
            */
        }
    }
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger  speed    = scrollView.contentOffset.x/YBLWindowWidth;
    self.stroeTableHeaderView.selectIndex = speed;
}

@end

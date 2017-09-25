//
//  YBLCouponsManageViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsManageViewController.h"
#import "YBLCouponsSetViewController.h"
#import "YBLTextSegmentControl.h"
#import "YBLCouponsTableView.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLCouponsModel.h"

static NSInteger const tag_coupons_table_view = 47;

@interface YBLCouponsManageViewController ()<UIScrollViewDelegate,YBLTableViewDelegate,YBLTextSegmentControlDelegate>

@property (nonatomic, strong) YBLTextSegmentControl *textSegment;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation YBLCouponsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.viewModel.couponsListType == CouponsListTypeCustomerMine) {
        self.navigationItem.title = @"我的优惠券";
    } else {
        self.navigationItem.title = @"优惠券";
        self.navigationItem.rightBarButtonItem = self.addButtonItem;
    }
    
    [self loadMoreDataIsReload:YES];
    
    WEAK
    [RACObserve(self.viewModel, isReqesuting) subscribeNext:^(NSNumber *  _Nullable x) {
        STRONG
        self.textSegment.enableSegment = !x.boolValue;
    }];
}

- (void)addClick:(UIBarButtonItem *)btn{
    
    YBLCouponsSetViewController *couponsVc = [YBLCouponsSetViewController new];
    [self.navigationController pushViewController:couponsVc animated:YES];
}

- (YBLCouponsManageViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [YBLCouponsManageViewModel new];
    }
    return _viewModel;
}

- (YBLTextSegmentControl *)textSegment{
    if (!_textSegment) {
        _textSegment = [[YBLTextSegmentControl alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)
                                                    TextSegmentType:TextSegmentTypeGoodsDetail];
        _textSegment.delegate = self;
        [_textSegment updateTitleData:self.viewModel.titleArray[0].mutableCopy];
        [self.view addSubview:_textSegment];
    }
    return _textSegment;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
        _contentScrollView.top = self.textSegment.bottom;
        _contentScrollView.height = YBLWindowHeight-kNavigationbarHeight-self.textSegment.bottom;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.backgroundColor = self.view.backgroundColor;
        NSInteger allCount = self.textSegment.dataArray.count;
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.width*allCount, _contentScrollView.height);
        [_contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
        [self.view addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (void)loadMoreDataIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForCouponsIsReload:isReload] subscribeError:^(NSError * _Nullable error) {
        
    } completed:^{
        STRONG
        YBLCouponsTableView *orderTableView = [self getCouponsTableViewWithIndex:self.viewModel.currentFoundIndex];
        [orderTableView.mj_header endRefreshing];
        NSMutableArray *cureentData = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        orderTableView.dataArray = cureentData;
        [orderTableView jsReloadData];
    }];
}

- (YBLCouponsTableView *)getCouponsTableViewWithIndex:(NSInteger)index{
    YBLCouponsTableView *couponsTableView = [self.view viewWithTag:tag_coupons_table_view+index];
    if (!couponsTableView) {
        couponsTableView = [[YBLCouponsTableView alloc] initWithFrame:[self.contentScrollView bounds]
                                                            style:UITableViewStylePlain];
        couponsTableView.ybl_delegate = self;
        couponsTableView.tag = tag_coupons_table_view+index;
        couponsTableView.left = self.contentScrollView.width*index;
        UIView *headerLittleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, couponsTableView.width, space)];
        headerLittleView.backgroundColor = YBLColor(243, 243, 243, 1);
        couponsTableView.tableHeaderView = headerLittleView;
        [self.contentScrollView addSubview:couponsTableView];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:couponsTableView completion:^{
            STRONG
            [self loadMoreDataIsReload:YES];
        }];
        couponsTableView.prestrainBlock = ^{
            STRONG
            [self loadMoreDataIsReload:NO];
        };
    }
    return couponsTableView;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLCouponsModel *model = (YBLCouponsModel *)selectValue;
    NSString *url_id = model.product.id;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = url_id;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.navigationController pushViewController:goodDetailVC animated:YES];
   
}

- (void)textSegmentControlIndex:(NSInteger)index selectModel:(id)model{
    self.viewModel.currentFoundIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    NSMutableArray *data = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
    if (data.count==0) {
        [self loadMoreDataIsReload:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/YBLWindowWidth;
    self.textSegment.currentIndex = index;
}


@end

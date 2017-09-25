//
//  YBLOrderCommentsService.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderCommentsService.h"
#import "YBLOrderCommentsViewModel.h"
#import "YBLOrderCommentsViewController.h"
#import "YBLEvaluateTextSegment.h"
#import "YBLNormalGoodTableView.h"
#import "YBLOrderMakeCommentsViewModel.h"
#import "YBLOrderMakeCommentsViewController.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLGoodEvaluateViewController.h"
#import "YBLGoodEvaluateDetailViewController.h"

static NSInteger const tag_normal_comments_good = 382471;

@interface YBLOrderCommentsService ()<YBLEvaluateTextSegmentDelegate,UIScrollViewDelegate,YBLTableViewDelegate>

@property (nonatomic, weak  ) YBLOrderCommentsViewModel *viewModel;

@property (nonatomic, weak  ) YBLOrderCommentsViewController *selfVc;

@property (nonatomic, strong) YBLEvaluateTextSegment *textSegment;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@end

@implementation YBLOrderCommentsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {

        _viewModel = (YBLOrderCommentsViewModel *)viewModel;
        _selfVc = (YBLOrderCommentsViewController *)VC;
        
        [self.selfVc.view addSubview:self.contentScrollView];
        [self.selfVc.view addSubview:self.textSegment];
        
        
    }
    return self;
}

- (void)requestDataIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForOrderCommentsListIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        YBLNormalGoodTableView *normalTableView = [self getCurrentNormalTableView];
        [normalTableView.mj_header endRefreshing];
        NSMutableArray *cureentData = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        normalTableView.dataArray = cureentData;
        self.textSegment.nummberArray = self.viewModel.numberCountArray.mutableCopy;
        [normalTableView jsReloadData];

    } error:^(NSError * _Nullable error) {
        
    }];
}

- (YBLEvaluateTextSegment *)textSegment{
    if (!_textSegment) {
        _textSegment = [[YBLEvaluateTextSegment alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, buttonHeight)
                                                          titleArray:self.viewModel.titleArray[0]];
        _textSegment.delegate = self;
    }
    return _textSegment;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:[self.selfVc.view bounds]];
        _contentScrollView.top = self.textSegment.bottom;
        _contentScrollView.height -= self.textSegment.bottom;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.width*2, _contentScrollView.height);
        _contentScrollView.backgroundColor = self.selfVc.view.backgroundColor;
        _contentScrollView.delegate = self;
        [_contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.selfVc.navigationController.interactivePopGestureRecognizer];
    }
    return _contentScrollView;
}

- (YBLNormalGoodTableView *)getCurrentNormalTableView{
    YBLNormalGoodTableView *normalTableView = (YBLNormalGoodTableView *)[self.selfVc.view viewWithTag:tag_normal_comments_good+self.viewModel.currentFoundIndex];
    if (!normalTableView) {
        normalTableView = [self getNormalTableView];
    }
    return normalTableView;
}

- (YBLNormalGoodTableView *)getNormalTableView{
    NormalTableViewType type;
    if (self.viewModel.currentFoundIndex==0) {
        type = NormalTableViewTypeNotCommentsGood;
    } else {
        type = NormalTableViewTypeCommentedGood;
    }
    YBLNormalGoodTableView *normalGoodTableView = [[YBLNormalGoodTableView alloc] initWithFrame:self.contentScrollView.bounds
                                                                                          style:UITableViewStylePlain
                                                                                  tableViewType:type];
    normalGoodTableView.showsVerticalScrollIndicator = NO;
    normalGoodTableView.ybl_delegate = self;
    normalGoodTableView.left = self.viewModel.currentFoundIndex*self.contentScrollView.width;
    normalGoodTableView.tag = tag_normal_comments_good+self.viewModel.currentFoundIndex;
    WEAK
    normalGoodTableView.prestrainBlock = ^{
        STRONG
        if ([self.viewModel isSatisfyRequestWithIndex:self.viewModel.currentFoundIndex]) {
            [self requestDataIsReload:NO];
        }
    };
    
    [YBLMethodTools headerRefreshWithTableView:normalGoodTableView completion:^{
        STRONG
        [self requestDataIsReload:YES];
    }];
    [self.contentScrollView addSubview:normalGoodTableView];
    return normalGoodTableView;
}

- (void)checkCurrentTableViewIsExist{
    
    NSMutableArray *data = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
    if (data.count==0) {
        [self requestDataIsReload:YES];
    }
}

#pragma mark - delegate

- (void)textDidSelectIndex:(NSInteger)index clickItem:(TextImageButton *)clickItem{
    self.viewModel.currentFoundIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(YBLWindowWidth*index, 0) animated:YES];
    [self checkCurrentTableViewIsExist];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/YBLWindowWidth;
    self.textSegment.currentIndex = index;
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLOrderCommentsItemModel *commentModel = (YBLOrderCommentsItemModel *)selectValue;
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = commentModel.product_id;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.selfVc.navigationController pushViewController:goodDetailVC animated:YES];
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLOrderCommentsItemModel *commentModel = (YBLOrderCommentsItemModel *)selectValue;
    if (self.viewModel.currentFoundIndex == 0) {
        YBLOrderMakeCommentsViewModel *viewModel = [YBLOrderMakeCommentsViewModel new];
        viewModel.commentsModel = commentModel;
        YBLOrderMakeCommentsViewController *commentsVc = [YBLOrderMakeCommentsViewController new];
        commentsVc.viewModel = viewModel;
        [self.selfVc.navigationController pushViewController:commentsVc animated:YES];
    } else {
        //评价
//        YBLGoodEvaluateViewModel *viewModel = [YBLGoodEvaluateViewModel new];
//        viewModel.product_id = commentModel.product_id;
//        YBLGoodEvaluateViewController *evaluateVc = [YBLGoodEvaluateViewController new];
//        evaluateVc.viewModel = viewModel;
//        [self.selfVc.navigationController pushViewController:evaluateVc animated:YES];
        YBLGoodEvaluateDetailViewController *commentsDetailVc = [YBLGoodEvaluateDetailViewController new];
        commentsDetailVc.commentModel = commentModel.comment;
        [self.selfVc.navigationController pushViewController:commentsDetailVc animated:YES];
    }
}

@end

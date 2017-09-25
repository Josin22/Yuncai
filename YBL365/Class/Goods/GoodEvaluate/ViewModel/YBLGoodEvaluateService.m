//
//  YBLGoodEvaluateService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodEvaluateService.h"
#import "YBLGoodEvaluateViewController.h"
#import "YBLEvaluateTextSegment.h"
#import "YBLGoodEvaluateDetailPicVC.h"
#import "YBLGoodEvaluateViewModel.h"
#import "YBLEvaluateTableView.h"
#import "YBLGoodEvaluateDetailViewController.h"
#import "YBLGoodEvaluateDetailPicVC.h"
#import "YBLOrderCommentsItemModel.h"

static NSInteger const tag_comments_good = 65640001;

@interface YBLGoodEvaluateService ()<YBLEvaluateTextSegmentDelegate,YBLTableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) YBLGoodEvaluateViewController *selfVc;

@property (nonatomic, weak) YBLGoodEvaluateViewModel *viewModel;

@property (nonatomic, strong) YBLEvaluateTextSegment *textSegment;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *superView;

@end

@implementation YBLGoodEvaluateService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel superView:(UIView *)superView{

    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _selfVc  = (YBLGoodEvaluateViewController *)VC;
        _viewModel = (YBLGoodEvaluateViewModel *)viewModel;
        _superView = superView;
        
        [superView addSubview:self.contentScrollView];
        [superView addSubview:self.textSegment];
        
        [self requestDataIsReload:YES];
    }
    return self;
    
}

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _selfVc  = (YBLGoodEvaluateViewController *)VC;
        _viewModel = (YBLGoodEvaluateViewModel *)viewModel;
        
        [_selfVc.view addSubview:self.contentScrollView];
        [_selfVc.view addSubview:self.textSegment];
        
        [self requestDataIsReload:YES];
    }
    return self;
}

- (void)requestDataIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForProductCommentsIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        YBLEvaluateTableView *normalTableView = [self getCurrentCommentsTableView];
        [normalTableView.mj_header endRefreshing];
        NSMutableArray *cureentData = [self.viewModel getCurrentDataArrayWithIndex:self.viewModel.currentFoundIndex];
        normalTableView.dataArray = cureentData;
        self.textSegment.nummberArray = [self.viewModel.numberArray mutableCopy];
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
        _contentScrollView.contentSize = CGSizeMake(_contentScrollView.width*self.textSegment.titleArray.count, _contentScrollView.height);
        _contentScrollView.backgroundColor = self.selfVc.view.backgroundColor;
        _contentScrollView.delegate = self;
        if (!_superView) {
            [_contentScrollView.panGestureRecognizer requireGestureRecognizerToFail:self.selfVc.navigationController.interactivePopGestureRecognizer];   
        }
    }
    return _contentScrollView;
}

- (YBLEvaluateTableView *)getCurrentCommentsTableView{
    YBLEvaluateTableView *commentsTableView = (YBLEvaluateTableView *)[self.selfVc.view viewWithTag:tag_comments_good+self.viewModel.currentFoundIndex];
    if (!commentsTableView) {
        commentsTableView = [self getCommentsTableView];
    }
    return commentsTableView;
}

- (YBLEvaluateTableView *)getCommentsTableView{

    YBLEvaluateTableView *commentsTableView = [[YBLEvaluateTableView alloc] initWithFrame:self.contentScrollView.bounds
                                                                                      style:UITableViewStyleGrouped];
    commentsTableView.showsVerticalScrollIndicator = NO;
    commentsTableView.ybl_delegate = self;
    commentsTableView.left = self.viewModel.currentFoundIndex*self.contentScrollView.width;
    commentsTableView.tag = tag_comments_good+self.viewModel.currentFoundIndex;
    WEAK
    commentsTableView.prestrainBlock = ^{
        STRONG
        if ([self.viewModel isSatisfyRequestWithIndex:self.viewModel.currentFoundIndex]) {
            [self requestDataIsReload:NO];
        }
    };
    [YBLMethodTools headerRefreshWithTableView:commentsTableView completion:^{
        STRONG
        [self requestDataIsReload:YES];
    }];
    [self.contentScrollView addSubview:commentsTableView];
    return commentsTableView;
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
        
    YBLGoodEvaluateDetailViewController *commentsDetailVc = [YBLGoodEvaluateDetailViewController new];
    commentsDetailVc.commentModel = selectValue;
    [self.selfVc.navigationController pushViewController:commentsDetailVc animated:YES];
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLOrderCommentsModel *commentModel = (YBLOrderCommentsModel *)selectValue;
    UIImageView *imageView = (UIImageView *)tableview;
    [YBLGoodEvaluateDetailPicVC pushFromVc:self.selfVc commentModel:commentModel imageView:imageView];
    /*
    NSMutableArray *items = @[].mutableCopy;
    for (NSString *url in commentModel.pictures) {
        KSPhotoItem *itemModel = [[KSPhotoItem alloc] initWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
        [items addObject:itemModel];
    }
    YBLGoodEvaluateDetailPicViewModel *viewModel = [YBLGoodEvaluateDetailPicViewModel new];
    viewModel.commentModel = commentModel;
    YBLGoodEvaluateDetailPicVC *detailPicVc = [[YBLGoodEvaluateDetailPicVC alloc] initWithPhotoItems:items selectedIndex:commentModel.currentIndex];
    detailPicVc.viewModel = viewModel;
    detailPicVc.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    detailPicVc.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    detailPicVc.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    detailPicVc.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    detailPicVc.bounces = NO;
    [detailPicVc showFromViewController:self.selfVc];
    */
}

@end

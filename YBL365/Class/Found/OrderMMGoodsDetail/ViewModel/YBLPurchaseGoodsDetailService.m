//
//  YBLPurchaseGoodsDetailService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseGoodsDetailService.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLOrderMMGoodsDetailInfoCell.h"
#import "YBLOrderMMGoodsDetailOtherInfoCell.h"
#import "YBLOrderMMGoodsDetailOutPriceRecordsCell.h"
#import "YBLOrderMMGoodsDetailMiningSupplyProcessCell.h"
#import "YBLOrderMMGoodsDetailAddressCell.h"
#import "YBLOrderMMGoodsDetailBar.h"
#import "YBLPurchaseOutPriceRecordsVC.h"
#import "YBLOrderMMRankingListVC.h"
#import "YBLPurchaseBiddingVC.h"
#import "YBLOrderMMMyDepositVC.h"
#import "YBLSignLabel.h"
#import "YBLFullScreenImageView.h"
#import "YBLGoodsBannerView.h"
#import "YBLPurchaseGoodDetailViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLGoodParameterView.h"
#import "YBLPurchaseOutPriceRecordsViewModel.h"
#import "YBLSaveManyImageTools.h"
#import "YBLGoodBananerHeaderView.h"
#import "YBLPicTableView.h"
#import "YBLImageTextDetailPullView.h"

@interface YBLPurchaseGoodsDetailService ()<YBLGoodsBannerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSInteger imageIndex;
}
@property (nonatomic, weak  ) YBLPurchaseGoodsDetailVC       *VC;
@property (nonatomic, strong) YBLPurchaseGoodDetailViewModel *viewModel;
@property (nonatomic, strong) UIScrollView                   *bannerView;
@property (nonatomic, strong) UIView                         *headerView;
@property (nonatomic, strong) YBLGoodsBannerView             *bannerScrollView;
@property (nonatomic, strong) YBLOrderMMGoodsDetailBar       *detailBar;
@property (nonatomic, strong) YBLPicTableView                *BottonPicDetailView;
@property (nonatomic, strong) UIScrollView                   *topScrollView;

@end

@implementation YBLPurchaseGoodsDetailService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLPurchaseGoodsDetailVC *)VC;
        _viewModel = (YBLPurchaseGoodDetailViewModel *)viewModel;
        
        [_VC.view addSubview:self.topScrollView];
        [_VC.view addSubview:self.detailBar];
        
        [self requestPurchaseDetail];
        
        /* footer */
//        kWeakSelf(self)
//        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            kStrongSelf(self)
//            //设置动画效果
//            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                
//                [self.topScrollView setContentOffset:CGPointMake(0, YBLWindowHeight) animated:YES];
//                
//            } completion:^(BOOL finished) {
//                //结束加载
//                [self.orderMMGoodsDetailTableView.mj_footer endRefreshing];
//            }];
//        }];
//        footer.refreshingTitleHidden = YES;
//        self.orderMMGoodsDetailTableView.mj_footer = footer;
        
    }
    return self;
}

- (void)turnToLastView{
    //设置动画效果
    self.topScrollView.userInteractionEnabled = NO;
    self.orderMMGoodsDetailTableView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.topScrollView setContentOffset:CGPointMake(0, YBLWindowHeight) animated:YES];
    } completion:^(BOOL finished) {
        //结束加载
        self.orderMMGoodsDetailTableView.userInteractionEnabled = YES;
        self.topScrollView.userInteractionEnabled = YES;
    }];
}

- (void)requestPurchaseDetail{
    
    WEAK
    [[self.viewModel signalForSinglePurchaseOrderDetail] subscribeError:^(NSError * _Nullable error) {
        
    } completed:^{
        STRONG
        self.BottonPicDetailView.imageURLsArray = [self.viewModel.purchaseDetailModel.descs mutableCopy];
        [self.detailBar.timeDown setEndTime:self.viewModel.purchaseDetailModel.enddated_at NowTime:self.viewModel.purchaseDetailModel.system_time begainText:@"距离结束:"];
        [self.detailBar updatePurchaseDetailModel:self.viewModel.purchaseDetailModel];
        [self.orderMMGoodsDetailTableView jsReloadData];
        //单条记录
        [self requestSingleRecords];
    }];
}


- (void)requestSingleRecords
{
    //单条报价记录/
    if (!self.viewModel.isPurchaseDetailRequestDone) {
        return;
    }

    [[YBLPurchaseOutPriceRecordsViewModel siganlForPurchaseBidRecordsWithOrderId:self.viewModel.purchaseDetailModel._id] subscribeNext:^(YBLBidingRecordsModel *bidModel) {
        if (bidModel.bidding.count==0) {
            return ;
        }
        YBLPurchaseOrderModel *x = bidModel.bidding[0];
        if (x) {
            singleOutPriceRecords *custom_records = [singleOutPriceRecords new];
            custom_records.name = x.userinfoname;
            custom_records.price = x.price;
            [self.viewModel.purchaseDetailModel setValue:custom_records forKey:@"custom_records"];

            if (![self.viewModel.cellArray[1][0][cell_identity_key] isEqualToString:@"YBLOrderMMGoodsDetailOutPriceRecordsCell"]) {

                [self.viewModel.cellArray insertObject:@[@{cell_identity_key:@"YBLOrderMMGoodsDetailOutPriceRecordsCell"}] atIndex:1];
                [self.orderMMGoodsDetailTableView beginUpdates];
                [self.orderMMGoodsDetailTableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                [self.orderMMGoodsDetailTableView endUpdates];
            }
            [self.orderMMGoodsDetailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
    } error:^(NSError *error) {
        
    }];
    
}

#pragma mark lazy load view

- (YBLOrderMMGoodsDetailBar *)detailBar{
    
    if (!_detailBar) {
        _detailBar = [[YBLOrderMMGoodsDetailBar alloc] initWithFrame:CGRectMake(0, YBLWindowHeight-60-kNavigationbarHeight, YBLWindowWidth, 60)];
        WEAK
        [[_detailBar.qiangButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            STRONG
            if ([x.currentTitle isEqualToString:PurchaseBarButtonTitleGOGO]) {
                PurchaseBiddingParaModel *model = [PurchaseBiddingParaModel new];
                model._id = self.viewModel.purchaseDetailModel._id;
                model.price = self.viewModel.purchaseDetailModel.price;
                float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:self.viewModel.purchaseDetailModel.quantity.integerValue
                                                                      Price:self.viewModel.purchaseDetailModel.price.doubleValue];;
                
                model.baozhengjinprice = @(baozhengjin);
                
                YBLPurchaseBiddingViewModel *viewModel = [[YBLPurchaseBiddingViewModel alloc] init];
                viewModel.paraModel = model;
                viewModel.purchaseDetailModel = self.viewModel.purchaseDetailModel;
                YBLPurchaseBiddingVC *payVC = [[YBLPurchaseBiddingVC alloc] init];
                payVC.viewModel = viewModel;
                [self.VC.navigationController pushViewController:payVC animated:YES];
                
            } else if ([x.currentTitle isEqualToString:purchase_order_button_look_price]) {

                [self pushbiddingVC];
            }
        }];
    }
    return _detailBar;
}

- (UITableView *)orderMMGoodsDetailTableView{
    
    if (!_orderMMGoodsDetailTableView) {
        NSArray *cellIDArray = @[
                                 @"YBLOrderMMGoodsDetailInfoCell",
                                 @"YBLOrderMMGoodsDetailOtherInfoCell",
                                 @"YBLOrderMMGoodsDetailOutPriceRecordsCell",
                                 @"YBLOrderMMGoodsDetailMiningSupplyProcessCell",
                                 @"YBLOrderMMGoodsDetailAddressCell",
//                                 @"YBLOrderMMGoodsDetailBusinessStarCell",
//                                 @"YBLGoodsHotListCell",
//                                 @"YBLOrderMMGoodsDetailPicsCell"
                                 ];
        _orderMMGoodsDetailTableView = [[UITableView alloc] initWithFrame:[_VC.view bounds] style:UITableViewStyleGrouped];
        _orderMMGoodsDetailTableView.height -= self.detailBar.height;
        _orderMMGoodsDetailTableView.showsVerticalScrollIndicator = NO;
        _orderMMGoodsDetailTableView.backgroundColor = [UIColor whiteColor];
        _orderMMGoodsDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        for (NSString *cellID in cellIDArray) {
            [_orderMMGoodsDetailTableView registerClass:NSClassFromString(cellID) forCellReuseIdentifier:cellID];
        }
        _orderMMGoodsDetailTableView.dataSource = self;
        _orderMMGoodsDetailTableView.delegate = self;
        _orderMMGoodsDetailTableView.tableFooterView = [[YBLImageTextDetailPullView alloc] initWithFrame:CGRectMake(0, 0, _orderMMGoodsDetailTableView.width, self.detailBar.height+40)];
        
    }
    return _orderMMGoodsDetailTableView;
}
/*第一页scroll*/
- (UIScrollView *)topScrollView{
    
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:[self.VC.view bounds]];
        _topScrollView.pagingEnabled = YES;
        _topScrollView.directionalLockEnabled = YES;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.scrollEnabled = NO;
        _topScrollView.delegate = self;
        _topScrollView.contentSize = CGSizeMake(self.VC.view.width, self.VC.view.height*2);
        [_topScrollView addSubview:self.orderMMGoodsDetailTableView];
        [_topScrollView addSubview:self.BottonPicDetailView];
    }
    return _topScrollView;
}

/* 底部详情 */
- (YBLPicTableView *)BottonPicDetailView{
    
    if (!_BottonPicDetailView) {
        _BottonPicDetailView = [[YBLPicTableView alloc] initWithFrame:CGRectMake(0,self.topScrollView.height,  self.topScrollView.width, self.topScrollView.height-self.detailBar.height-kNavigationbarHeight)];
        _BottonPicDetailView.backgroundColor = [UIColor whiteColor];
        WEAK
        _BottonPicDetailView.picDetailScrollPullBlock = ^{
            STRONG
            [self.topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        };
    }
    return _BottonPicDetailView;
}

//- (UIView *)headerView{
//    
//    if (!_headerView) {
//        _headerView = [[YBLGoodBananerHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowWidth)];
//        _headerView.bannerView.delegate = self;
//        _headerView.clipsToBounds = YES;
//    }
//    return _headerView;
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.cellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.cellArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        
        return YBLWindowWidth+shadows_space;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.viewModel.cellArray.count-2) {
        return 0.1;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == self.viewModel.cellArray.count-2) {
        return 0;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, space)];
    bgView.backgroundColor = self.VC.view.backgroundColor;
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        WEAK
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowWidth+shadows_space)];
        self.headerView = headerView;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.width)];
        scrollView.contentSize   = CGSizeMake(headerView.width, headerView.width);
        scrollView.scrollEnabled = NO;
        scrollView.bounces = NO;
        [scrollView addSubview:({
            STRONG
            YBLGoodsBannerView *bannerView = [[YBLGoodsBannerView alloc] initWithFrame:[scrollView bounds]
                                                                         imageURLArray:self.viewModel.purchaseDetailModel.mains];
            bannerView.delegate = self;
            self.bannerScrollView = bannerView;
            self.bannerScrollView;
        })];
        [headerView addSubview:scrollView];
        self.bannerView = scrollView;
        
        YBLSignLabel *ingLabel = [[YBLSignLabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30) SiginDirection:SiginDirectionLeft];
        ingLabel.textFont = YBLFont(13);
        ingLabel.signText = self.viewModel.purchaseDetailModel.purchase_state_for_purchaser.mypurchase_head;
        ingLabel.fillColor = YBLThemeColor;
        [headerView addSubview:ingLabel];
        
        UIView * testView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom, headerView.width, shadows_space)];
        testView.backgroundColor = YBLLineColorAlph(.4);
        [headerView addSubview:testView];
        [YBLMethodTools addTopShadowToGoodView:testView];
        
        return self.headerView;

    } else {
        return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *cellName = _viewModel.cellArray[section][row][cell_identity_key];
    
    if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailInfoCell"]) {
        
        return [YBLOrderMMGoodsDetailInfoCell getGoodsDetailInfoCellHeight];
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailOtherInfoCell"]) {
        
        return [YBLOrderMMGoodsDetailOtherInfoCell getGoodsDetailOtherInfoCellHeight];
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailOutPriceRecordsCell"]) {
        
        return [YBLOrderMMGoodsDetailOutPriceRecordsCell getGoodsDetailOutPriceRecordsCellHeight];
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailMiningSupplyProcessCell"]) {
        
        return [YBLOrderMMGoodsDetailMiningSupplyProcessCell getGoodsDetailMiningSupplyProcessCellHeight];
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailAddressCell"]) {
        
        return [YBLOrderMMGoodsDetailAddressCell getGoodsDetailAddressCellHeight];
        
    }
//        else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailBusinessStarCell"]) {
//
//        return [YBLOrderMMGoodsDetailBusinessStarCell getBusinessStarCellHeight];
//        
//    } else if ([cellName isEqualToString:@"YBLGoodsHotListCell"]) {
//        
//        return [YBLGoodsHotListCell getGoodsHotListCellHeight];
//        
//    }
//    else {
//        return [YBLOrderMMGoodsDetailPicsCell getGoodsDetailPicsCellHeight];
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *cellName = _viewModel.cellArray[section][row][cell_identity_key];
    
    if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailInfoCell"]) {
        
        YBLOrderMMGoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        [self configureGoodsDetailInfoCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailOtherInfoCell"]) {
        
        YBLOrderMMGoodsDetailOtherInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        [self configureGoodsDetailOtherInfoCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailOutPriceRecordsCell"]) {
        
        YBLOrderMMGoodsDetailOutPriceRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        [self configureGoodsDetailOutPriceRecordsCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailMiningSupplyProcessCell"]) {
        
        YBLOrderMMGoodsDetailMiningSupplyProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        [self configureGoodsDetailMiningSupplyProcessCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailAddressCell"]) {
        
        YBLOrderMMGoodsDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        [self configureGoodsDetailAddressCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else {
        return 0;
    }
//        else if ([cellName isEqualToString:@"YBLOrderMMGoodsDetailBusinessStarCell"]) {
//
//        YBLOrderMMGoodsDetailBusinessStarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
//        
//        [self configureGoodsDetailBusinessStarCell:cell forRowAtIndexPath:indexPath];
//        
//        return cell;
//        
//    } else if ([cellName isEqualToString:@"YBLGoodsHotListCell"]) {
//        
//        YBLGoodsHotListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
//        
//        [self configureGoodsHotListCell:cell forRowAtIndexPath:indexPath];
//        
//        return cell;
//        
//    }
//        else {
//        
//        YBLOrderMMGoodsDetailPicsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
//        
//        [self configureGoodsDetailPicsCell:cell forRowAtIndexPath:indexPath];
//        
//        return cell;
//    }
    
//    return 0;
}

///商品信息
- (void)configureGoodsDetailInfoCell:(YBLOrderMMGoodsDetailInfoCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //要求
    WEAK
    [[[cell.askButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        [YBLGoodParameterView showGoodParameterViewInViewController:self.VC.navigationController
                                                       paraViewType:ParaViewTypePara
                                                           withData:self.viewModel.paraDataArray
                                                       completetion:^{}];
    }];
    
    [cell updateModel:self.viewModel.purchaseDetailModel];
}
///商品其他信息
- (void)configureGoodsDetailOtherInfoCell:(YBLOrderMMGoodsDetailOtherInfoCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell updateModel:self.viewModel.purchaseDetailModel];
}
///商品报价记录
- (void)configureGoodsDetailOutPriceRecordsCell:(YBLOrderMMGoodsDetailOutPriceRecordsCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *newName = [NSString stringWithFormat:@"***%@",[self.viewModel.purchaseDetailModel.custom_records.name substringFromIndex:self.viewModel.purchaseDetailModel.custom_records.name.length-1]];
    
    cell.recordLabel.text = [NSString stringWithFormat:@"出价记录 : %@ ¥%.2f",newName,self.viewModel.purchaseDetailModel.custom_records.price.doubleValue];
    
    WEAK
    [[[cell.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        [self pushbiddingVC];
    }];
}
///采购流程
- (void)configureGoodsDetailMiningSupplyProcessCell:(YBLOrderMMGoodsDetailMiningSupplyProcessCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAK
    [[[cell.guizeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        [YBLGoodParameterView showGoodParameterViewInViewController:self.VC.navigationController
                                                       paraViewType:ParaViewTypePayRule
                                                           withData:nil
                                                       completetion:^{
                                                           }];
    }];
}
///地址
- (void)configureGoodsDetailAddressCell:(YBLOrderMMGoodsDetailAddressCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateModel:self.viewModel.purchaseDetailModel];
}
/////商户等级
//- (void)configureGoodsDetailBusinessStarCell:(YBLOrderMMGoodsDetailBusinessStarCell *)cell
//    forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//}
/////更多采购
//- (void)configureGoodsHotListCell:(YBLGoodsHotListCell *)cell
//    forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.type = hotTypeCaiGou;
//    WEAK
//    [[[cell.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
//        STRONG
//        YBLOrderMMRankingListVC *rankingVC = [[YBLOrderMMRankingListVC alloc] init];
//        [self.VC.navigationController pushViewController:rankingVC animated:YES];
//    }];
//}
/////图片
//- (void)configureGoodsDetailPicsCell:(YBLOrderMMGoodsDetailPicsCell *)cell
//    forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//}

- (void)pushbiddingVC{
    
    YBLPurchaseOutPriceRecordsViewModel *viewModel = [[YBLPurchaseOutPriceRecordsViewModel alloc] init];
    viewModel.purchaseDetailModel = self.viewModel.purchaseDetailModel;
    YBLPurchaseOutPriceRecordsVC *recordsVC= [[YBLPurchaseOutPriceRecordsVC alloc] init];
    recordsVC.viewModel = viewModel;
    [self.VC.navigationController pushViewController:recordsVC animated:YES];
}

#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat cellOffY = scrollView.contentOffset.y;
    
    if (![scrollView isKindOfClass:[UITableView class]]) {
        return;
    }
    if (cellOffY>=0) {
        
        self.bannerView.top = cellOffY*0.5;;
        self.bannerView.height = (YBLWindowWidth+shadows_space)-cellOffY*0.5;;
        
    } else {
        
        CGPoint bananaPoint = [self.bannerView center];
        bananaPoint.y = (YBLWindowWidth+shadows_space - fabs(cellOffY))/2;
        self.bannerView.center = bananaPoint;
    }
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat cellOffY = scrollView.contentOffset.y;
    NSLog(@"+*****:%@",@(cellOffY));
    CGFloat lessHeight = self.orderMMGoodsDetailTableView.contentSize.height-self.VC.view.height;
    if ((cellOffY-lessHeight)>=Pull_Max_Y) {
        [self turnToLastView];
    }
}

- (void)banner:(YBLGoodsBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    
    CGRect frame = [self.headerView convertRect:self.bannerView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    YBLSystemSocialModel *socialModel = [self getNormalGoodModel];
    
    [YBLFullScreenImageView showFullScreenIamgeViewWithModel:socialModel
                                                currentIndex:index
                                                   orginRect:frame
                                           currentIndexBlock:^(NSInteger currentIndex) {
                                               self.bannerScrollView.currentPageIndex = currentIndex;
                                           }];
}

- (void)saveQRCodeIamge{
    
    YBLSystemSocialModel *socialModel = [self getNormalGoodModel];
    
    [YBLSaveManyImageTools saveImageModel:socialModel
                             Completetion:^(BOOL isSuccess) {
                                 
                             }];
}

- (YBLSystemSocialModel *)getNormalGoodModel{
    
    YBLSystemSocialModel *socialModel = [YBLSystemSocialModel new];
    socialModel.spec = self.viewModel.purchaseDetailModel.specification;
//    float allPrice = self.viewModel.purchaseDetailModel.quantity.integerValue*self.viewModel.purchaseDetailModel.price.doubleValue;
    socialModel.price = self.viewModel.purchaseDetailModel.price;
    socialModel.quantity = self.viewModel.purchaseDetailModel.quantity;
    socialModel.local = [self.viewModel.purchaseDetailModel.address_info.province_name stringByAppendingString:self.viewModel.purchaseDetailModel.address_info.city_name];
    socialModel.imagesArray = [self.viewModel.purchaseDetailModel.mains mutableCopy];
    socialModel.share_url = self.viewModel.purchaseDetailModel.share_url;
    socialModel.imageType = SaveImageTypePurchaseGoods;
    
    return socialModel;
}


@end

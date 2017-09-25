//
//  YBLGoodDetailTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodDetailTableView.h"
#import "YBLGoodsBannerView.h"
#import "YBLSeckillGoodsPriceCell.h"
#import "YBLGoodsDetailInfoCell.h"
#import "YBLGoodsWholesalePriceCell.h"
#import "YBLGoodsOriginInfoCell.h"
#import "YBLGoodsPromotionCell.h"
#import "YBLGoodsSpecCell.h"
#import "YBLGoodsDeliverToCell.h"
#import "YBLGoodsEvaluateCell.h"
#import "YBLGoodsStoreCell.h"
#import "YBLGoodsHotListCell.h"
#import "YBLGoodsEvaluateHeaderView.h"
#import "YBLGoodsEvaluateFooterView.h"
//#import "YBLGoodsPriceDownViewController.h"
#import "YBLChooseCityView.h"
#import "YBLGoodsSpecView.h"
#import <Photos/Photos.h>
#import "YBLFullScreenImageView.h"
#import "YBLSpecInfoCell.h"
#import "YBLGoodModel.h"
#import "YBLSelectAddressView.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreViewController.h"
#import "YBLImageTextDetailPullView.h"
#import "YBLNoneEvaluateCell.h"
#import "YBLGoodEvaluateDetailPicVC.h"
#import "YBLCouponsLabelsCell.h"

@interface YBLGoodDetailTableView ()<UITableViewDelegate,UITableViewDataSource,YBLGoodsBannerDelegate,UIScrollViewDelegate>

@property (nonatomic, weak  ) YBLGoodsBannerView *bannerScrollView;

@property (nonatomic, strong) UIScrollView       *bannerView;

@property (nonatomic, strong) UIView             *headerView;

@property (nonatomic, assign) CGFloat            picImageViewHeight;

@property (nonatomic, assign) GoodDetailShowType goodDetailShowType;

@end

@implementation YBLGoodDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame style:style goodDetailShowType:GoodDetailShowTypeNormalShow];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style goodDetailShowType:(GoodDetailShowType)goodDetailShowType{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _goodDetailShowType = goodDetailShowType;
        
        self.dataSource = self;
        self.delegate   = self;
        NSArray *cellNameArray = @[
                                   @"YBLSeckillGoodsPriceCell",
                                   @"YBLGoodsDetailInfoCell",
                                   @"YBLGoodsWholesalePriceCell",
                                   @"YBLGoodsOriginInfoCell",
                                   @"YBLGoodsPromotionCell",
                                   @"YBLGoodsSpecCell",
                                   @"YBLGoodsDeliverToCell",
                                   @"YBLGoodsEvaluateCell",
                                   @"YBLGoodsStoreCell",
                                   @"YBLGoodsHotListCell",
                                   @"YBLSpecInfoCell",
                                   @"YBLNoneEvaluateCell",
                                   @"YBLCouponsLabelsCell"
                                   ];
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        for (NSString *cellClassName in cellNameArray) {

            [self registerClass:NSClassFromString(cellClassName) forCellReuseIdentifier:cellClassName];
        }
        [self registerClass:NSClassFromString(@"YBLGoodsEvaluateHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLGoodsEvaluateHeaderView"];
        [self registerClass:NSClassFromString(@"YBLGoodsEvaluateFooterView") forHeaderFooterViewReuseIdentifier:@"YBLGoodsEvaluateFooterView"];
        self.tableFooterView = [[YBLImageTextDetailPullView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    }
    return self;
}


- (void)updateCellIDArray:(NSMutableArray *)cellArray goodDetailModel:(YBLGoodModel *)goodDetailModel{
    
    _goodDetailModel = goodDetailModel;
    _cellIDArray = cellArray;
    
    [self jsReloadData];
}


#pragma mark -  delegate

- (void)banner:(YBLGoodsBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    
    if (_goodDetailShowType == GoodDetailShowTypeEditShow) {
        return;
    }
    CGRect frame = [self.headerView convertRect:self.bannerView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    YBLSystemSocialModel *model = [YBLSystemSocialModel new];
    model.imagesArray = [self.goodDetailModel.mains mutableCopy];
    model.imageType = SaveImageTypeNormalGoods;
    model.share_url = self.goodDetailModel.share_url;
    WEAK
    [YBLFullScreenImageView showFullScreenIamgeViewWithModel:model
                                                currentIndex:index
                                                   orginRect:frame
                                           currentIndexBlock:^(NSInteger currentIndex) {
                                               STRONG
                                               self.bannerScrollView.currentPageIndex = currentIndex;
                                           }];
}

- (void)banner:(YBLGoodsBannerView *)bannerView scrollToLastItem:(NSInteger)lastIndex{
    
    BLOCK_EXEC(self.goodDetailTableViewBannerScrollToLastItemBlock,)
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellIDArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.cellIDArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellName = self.cellIDArray[section][row][cell_identity_key];;
    //秒杀
    if ([cellName isEqualToString:@"YBLSeckillGoodsPriceCell"]) {
        
        return [YBLSeckillGoodsPriceCell getSeckillGoodsPriceCellHeight];
        
    } else if ([cellName isEqualToString:@"YBLGoodsDetailInfoCell"]){
        //商品信息
        return [YBLGoodsDetailInfoCell getItemCellHeightWithModel:self.goodDetailModel];
        
    }else if ([cellName isEqualToString:@"YBLGoodsWholesalePriceCell"]){
        //批发价
        return [YBLGoodsWholesalePriceCell getWholesalePriceCellHeight];
        
    }else if ([cellName isEqualToString:@"YBLGoodsOriginInfoCell"]){
        //原产地
        return [YBLGoodsOriginInfoCell getOriginInfoCellHeight];
        
    }else if ([cellName isEqualToString:@"YBLSpecInfoCell"]){
        //规格信息
        return [YBLSpecInfoCell getHI];
        
    }else if ([cellName isEqualToString:@"YBLGoodsPromotionCell"]){
        //促销
        return [YBLGoodsPromotionCell getPromotionCellHeight];
        
    }else if ([cellName isEqualToString:@"YBLGoodsSpecCell"]){
        //商品规格
        return [YBLGoodsSpecCell getGoodsSpecCellHeight];
        
    }else if ([cellName isEqualToString:@"YBLGoodsDeliverToCell"]){
        //送至
        return [YBLGoodsDeliverToCell getItemCellHeightWithModel:self.goodDetailModel.selectAddressModel];
        
    }else if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]){
        //商品评价
        YBLOrderCommentsModel *model = self.goodDetailModel.comments[row];
        return [YBLGoodsEvaluateCell  getItemCellHeightWithModel:model];
        
    } else if ([cellName isEqualToString:@"YBLNoneEvaluateCell"]){
        
        return [YBLNoneEvaluateCell getItemCellHeightWithModel:nil];
        
    } else if ([cellName isEqualToString:@"YBLGoodsStoreCell"]){
        //店铺
        return [YBLGoodsStoreCell  getGoodsStoreCellHeight];
        
    }else if ([cellName isEqualToString:@"YBLGoodsHotListCell"]){
        //热卖
        return [YBLGoodsHotListCell  getGoodsHotListCellHeight];
        
    }else if ([cellName isEqualToString:@"YBLCouponsLabelsCell"]){
        //热卖
        return [YBLCouponsLabelsCell getItemCellHeightWithModel:nil];
        
    } else  {
        return 0;
    }
    
}

#pragma mark - header view height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString *cellName = self.cellIDArray[section][0][cell_identity_key];
    
    if (section == 0){
        
        return YBLWindowWidth+shadows_space;
        
    }else if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]) {
        
        return [YBLGoodsEvaluateHeaderView getGoodsEvaluateHeaderViewHeight];
        
    } else if ([cellName isEqualToString:@"YBLGoodsStoreCell"]){
        
        return 10;
    }
    return 0.1;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *cellName = self.cellIDArray[section][0][cell_identity_key];
    
    if (section == 0){
        WEAK
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowWidth+shadows_space)];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.width)];
        scrollView.contentSize   = CGSizeMake(headerView.width, headerView.width);
        scrollView.scrollEnabled = NO;
        scrollView.bounces = NO;
        [scrollView addSubview:({
            STRONG
            YBLGoodsBannerView *bannerView = [[YBLGoodsBannerView alloc] initWithFrame:[scrollView bounds]
                                                                         imageURLArray:self.goodDetailModel.mains];
            bannerView.delegate = self;
            self.bannerScrollView = bannerView;
            self.bannerScrollView;
        })];
        [headerView addSubview:scrollView];
        self.bannerView = scrollView;
        self.headerView = headerView;
        
        UIView * testView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom, headerView.width, shadows_space)];
        testView.backgroundColor = YBLLineColorAlph(.4);
        [headerView addSubview:testView];
        [YBLMethodTools addTopShadowToGoodView:testView];
        
        
        return self.headerView;
        
    }else  if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]) {
        
        YBLGoodsEvaluateHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLGoodsEvaluateHeaderView"];
        [headerView updateEVcount:self.goodDetailModel.comments_total.integerValue evPercent:self.goodDetailModel.good_comments_rate.doubleValue];
        WEAK
        [[[headerView.goodEvaluateButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            BLOCK_EXEC(self.goodDetailTableViewScrollToCommentsBlock,)
        }];

        return headerView;
        
    }
    return 0;
}

#pragma mark - footer view height
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSString *cellName = self.cellIDArray[section][0][cell_identity_key];
    
    if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]) {
        
        return [YBLGoodsEvaluateFooterView getGoodsEvaluateFooterViewHeight];
    }
    return 10;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSString *cellName = self.cellIDArray[section][0][cell_identity_key];
    
    if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]) {
        
        YBLGoodsEvaluateFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLGoodsEvaluateFooterView"];
        WEAK
        [[[footerView.picButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:footerView.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            BLOCK_EXEC(self.goodDetailTableViewScrollToCommentsBlock,)
        }];
        return footerView;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, space)];
    bgView.backgroundColor = YBLViewBGColor;
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellName = self.cellIDArray[section][row][cell_identity_key];
    UITableViewCell *baseCell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];;
    //秒杀
    if ([cellName isEqualToString:@"YBLSeckillGoodsPriceCell"]) {
        
        [self configurePriceCell:(YBLSeckillGoodsPriceCell *)baseCell forRowAtIndexPath:indexPath];
        
    } else if ([cellName isEqualToString:@"YBLGoodsDetailInfoCell"]){
        //商品信息
        
        [self configureInfoCell:(YBLGoodsDetailInfoCell *)baseCell forRowAtIndexPath:indexPath];
        
    }else if ([cellName isEqualToString:@"YBLGoodsWholesalePriceCell"]){
        //批发价
        
        [self configureWholesalePriceCell:(YBLGoodsWholesalePriceCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLGoodsOriginInfoCell"]){
        //原产地
        
        [self configureOriginCell:(YBLGoodsOriginInfoCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLSpecInfoCell"]){
        //规格信息
        
        [self configureSpecInfoCell:(YBLSpecInfoCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLGoodsPromotionCell"]){
        //促销
        
        [self configurePromotionCell:(YBLGoodsPromotionCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLGoodsSpecCell"]){
        //商品规格
        
        [self configureSpecCell:(YBLGoodsSpecCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLGoodsDeliverToCell"]){
        //送至
        
        [self configureDeliverToCell:(YBLGoodsDeliverToCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]){
        //商品评价
        
        [self configureEvaluateCell:(YBLGoodsEvaluateCell *)baseCell forRowAtIndexPath:indexPath];
        
        
    }else if ([cellName isEqualToString:@"YBLNoneEvaluateCell"]){
    
        YBLNoneEvaluateCell *cell  = (YBLNoneEvaluateCell *)baseCell;
        WEAK
        [[[cell.goodEvaluateButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            BLOCK_EXEC(self.goodDetailTableViewScrollToCommentsBlock,)
        }];
        
    }else if ([cellName isEqualToString:@"YBLGoodsStoreCell"]){
        //店铺
        
        [self configureStoreCell:(YBLGoodsStoreCell *)baseCell forRowAtIndexPath:indexPath];
        
    }else if ([cellName isEqualToString:@"YBLGoodsHotListCell"]){
        //热卖
        
        [self configureHotListCell:(YBLGoodsHotListCell *)baseCell forRowAtIndexPath:indexPath];
        
    }else if ([cellName isEqualToString:@"YBLCouponsLabelsCell"]){

        YBLCouponsLabelsCell *cell = (YBLCouponsLabelsCell *)baseCell;
        
        [cell updateItemCellModel:_goodDetailModel.coupons];
    }
    
    return baseCell;
    
}

#pragma mark - 秒杀cell
- (void)configurePriceCell:(YBLSeckillGoodsPriceCell *)cell
         forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark - 商品信息cell
- (void)configureInfoCell:(YBLGoodsDetailInfoCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateItemCellModel:self.goodDetailModel];
    
}
#pragma mark - 批发价cell
- (void)configureWholesalePriceCell:(YBLGoodsWholesalePriceCell *)cell
                  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateItemCellModel:self.goodDetailModel];

}
#pragma mark - 原产地cell
- (void)configureOriginCell:(YBLGoodsOriginInfoCell *)cell
          forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *unit = @"";
    if (self.goodDetailModel.unit) {
        unit = self.goodDetailModel.unit;
    }
    cell.countLabel.text = [NSString stringWithFormat:@"已售%d%@",self.goodDetailModel.sale_count.intValue,unit];
    NSString *expressCompany = @"";
    if (self.goodDetailModel.expressCompanyItemModel.express_company) {
        expressCompany = self.goodDetailModel.expressCompanyItemModel.express_company;
    }
    // 物流价格
    NSString *expressName = @"";
    if ([expressCompany isEqualToString:@"mine"]) {
        expressName = @"商家自配";
    } else {
        expressName = [NSString stringWithFormat:@"%@",expressCompany];
    }
    [cell.priceCountButton setTitle:expressName forState:UIControlStateNormal];
//    self.goodDetailModel.
//    cell.originLabel.text = [NSString stringWithFormat:@"%@% %@",];
//    
//    WEAK
//    [[[cell.cutsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
//        STRONG
//        YBLGoodsPriceDownViewController *priceDownVC = [[YBLGoodsPriceDownViewController alloc] init];
//        [self.goodsDetailVC.navigationController pushViewController:priceDownVC animated:YES];
//    }];
    
}

#pragma mark - 规格信息cell
- (void)configureSpecInfoCell:(YBLSpecInfoCell *)cell
            forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.goodDetailModel.specification;
}

#pragma mark - 促销cell
- (void)configurePromotionCell:(YBLGoodsPromotionCell *)cell
             forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark - 规格cell
- (void)configureSpecCell:(YBLGoodsSpecCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.specLabel.text = [NSString stringWithFormat:@"%@个",self.goodDetailModel.quantity];
}
#pragma mark - 送至cell
- (void)configureDeliverToCell:(YBLGoodsDeliverToCell *)cell
             forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.kgLabel.text = [NSString stringWithFormat:@"%.1fkg",self.goodDetailModel.weight.doubleValue];
    [cell updateItemCellModel:self.goodDetailModel.selectAddressModel];
}
#pragma mark - 评价cell
- (void)configureEvaluateCell:(YBLGoodsEvaluateCell *)cell
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBLOrderCommentsModel *model = self.goodDetailModel.comments[indexPath.row];
    WEAK
    [cell updateItemCellModel:model];
    cell.imageCollectionView.evaluatePicCollectionDidSelectBlock = ^(NSInteger index,UIImageView *imageView){
        STRONG
        model.currentIndex = index;
        [YBLGoodEvaluateDetailPicVC pushFromVc:self.goodsDetailVC commentModel:model imageView:imageView];
    };
}
#pragma mark - 店铺cell
- (void)configureStoreCell:(YBLGoodsStoreCell *)cell
         forRowAtIndexPath:(NSIndexPath *)indexPath
{

    [cell updateItemCellModel:self.goodDetailModel.shop];
    
    WEAK
    [[[cell.callButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        [YBLMethodTools callWithNumber:self.goodDetailModel.shop.contactphone];
    }];
    
    [[[cell.goStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
        viewModel.shopid = self.goodDetailModel.shop_id;
        YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
        storeVC.viewModel = viewModel;
        [self.goodsDetailVC.navigationController pushViewController:storeVC animated:YES];
    }];
}
#pragma mark - 热卖cell
- (void)configureHotListCell:(YBLGoodsHotListCell *)cell
           forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = hotTypeNormal;
    WEAK
    cell.hotListCollectionView.hotCollectionDidSelectBlock = ^(){
        STRONG
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        [self.goodsDetailVC.navigationController pushViewController:goodDetailVC animated:YES];
    };
}

#pragma mark - 选中事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellName = self.cellIDArray[section][row][cell_identity_key];
    if ([cellName isEqualToString:@"YBLGoodsEvaluateCell"]) {
        BLOCK_EXEC(self.goodDetailTableViewScrollToCommentsBlock,)
    } else {
        BLOCK_EXEC(self.goodDetailTableViewDidSelectBlock,indexPath,cellName)
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat cellOffY = scrollView.contentOffset.y;
    
    if (cellOffY>=0) {
        self.bannerView.top = cellOffY*0.5;;
        self.bannerView.height = self.headerView.height-cellOffY*0.5;;
    } else {
        CGPoint bananaPoint = [self.bannerView center];
        bananaPoint.y = (self.headerView.height - fabs(cellOffY))/2;
        self.bannerView.center = bananaPoint;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat cellOffY = scrollView.contentOffset.y;
    CGFloat lessHeight = self.contentSize.height-self.superview.height;
    if ((cellOffY-lessHeight)>=Pull_Max_Y) {
        BLOCK_EXEC(self.goodDetailTableViewScrollToImageTextBlock,)
    } else if ((-cellOffY)>=Pull_FooterPrints_Max_Y){
        BLOCK_EXEC(self.footerPrintsBlock,)
    }
}


@end

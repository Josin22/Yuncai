//
//  YBLHomeBannerCell.m
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLHomeBannerCell.h"
#import "YBLListBaseModel.h"
#import "YBLHomeViewController.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLOrderBulletModel.h"
#import "YBLAdsModel.h"

@interface YBLHomeBannerCell ()<SDCycleScrollViewDelegate,OrderBarrageViewDelegate>

@property (nonatomic, weak) YBLListCellItemModel *model;
@property (nonatomic, strong) SDCycleScrollView *bannerView;

@end

@implementation YBLHomeBannerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBannerUI];
    }
    return self;
}

- (void)createBannerUI{
    
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:[self bounds] imageNamesGroup:nil];
    bannerView.delegate = self;
    bannerView.backgroundColor = YBLColor(220, 220, 220, 1);
    bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    bannerView.pageDotImage = [UIImage imageNamed:@"YCMainPage_Banner_Index"];
    bannerView.currentPageDotImage = [UIImage imageNamed:@"YCMainPage_Banner_Index_Selected"];
    bannerView.autoScrollTimeInterval = 3.f;
    [self.contentView addSubview:bannerView];
    self.bannerView = bannerView;
    
    self.barrageView = [[YBLOrderBarrageView alloc] initWithFrame:CGRectMake(0, kNavigationbarHeight, self.width/2, self.height-kNavigationbarHeight)];
    self.barrageView.delegate = self;
    [self.contentView addSubview:self.barrageView];
}

- (void)updateItemCellModel:(id)itemModel{
    if ([itemModel isKindOfClass:[YBLListCellItemModel class]]) {
        self.model = (YBLListCellItemModel *)itemModel;
        self.bannerView.imageURLStringsGroup = self.model.valueOfRowItemCellData;
    }
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    
    CGFloat fin_hi = (double)Iphone6ScaleHeight*160;
    
    return fin_hi;
}

#pragma mark - 

- (void)orderBarrageViewItemSelect:(id)selectModel{
    NSLog(@"---点击了%@", selectModel);
    YBLOrderBulletModel *bulletsModel = (YBLOrderBulletModel *)selectModel;
    [self goGoodVc:bulletsModel.product_id];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    YBLAdsModel *adsModel = self.model.orginValueOfRowItemCellData[index];
    [YBLMethodTools handleAdsModel:adsModel Vc:self.homeVC];
}

- (void)goGoodVc:(NSString *)gID{
    YBLGoodsDetailViewModel *viewModel = [[YBLGoodsDetailViewModel alloc] init];
    viewModel.goodID = gID;
    YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    goodDetailVC.viewModel = viewModel;
    [self.homeVC.navigationController pushViewController:goodDetailVC animated:YES];
}

@end

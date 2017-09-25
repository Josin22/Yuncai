
//
//  YBLGoodBananerHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodBananerHeaderView.h"
#import "YBLGoodsBannerView.h"
#import "YBLSignLabel.h"
#import "YBLGoodModel.h"
#import "YBLPurchaseOrderModel.h"

@implementation YBLGoodBananerHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
    scrollView.contentSize   = CGSizeMake(self.width, self.height);
    scrollView.scrollEnabled = NO;
    [scrollView addSubview:({
        YBLGoodsBannerView *bannerView = [[YBLGoodsBannerView alloc] initWithFrame:[scrollView bounds]];
        self.bannerView = bannerView;
        self.bannerView;
    })];
    [self addSubview:scrollView];
    self.contentScrollView = scrollView;
    
    YBLSignLabel *ingLabel = [[YBLSignLabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30) SiginDirection:SiginDirectionLeft];
    ingLabel.textFont = YBLFont(13);
//    ingLabel.signText = self.viewModel.purchaseDetailModel.purchase_state.mypurchase_head;
    [self addSubview:ingLabel];
    self.ingLabel = ingLabel;
    
    
}

- (void)updateModel:(id)model{
    
    if ([model isKindOfClass:[YBLPurchaseOrderModel class]]) {
        
        YBLPurchaseOrderModel *purchaseModel = (YBLPurchaseOrderModel *)model;
        self.ingLabel.signText = purchaseModel.purchase_state_for_purchaser.mypurchase_head;
        self.bannerView.imageURLArray = purchaseModel.mains;
        
    } else if ([model isKindOfClass:[YBLGoodModel class]]) {
        
        YBLGoodModel *goodModel = (YBLGoodModel *)model;
        self.bannerView.imageURLArray = goodModel.mains;
    }
}

@end

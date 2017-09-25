//
//  YBLGoodBananerHeaderView.h
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLGoodsBannerView,YBLSignLabel;

@interface YBLGoodBananerHeaderView : UIView

@property (nonatomic, strong) YBLGoodsBannerView *bannerView;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) YBLSignLabel *ingLabel;

- (void)updateModel:(id)model;

@end

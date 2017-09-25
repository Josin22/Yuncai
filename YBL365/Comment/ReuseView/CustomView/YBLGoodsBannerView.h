//
//  YBLGoodsBannerView.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLGoodsBannerView;

@protocol YBLGoodsBannerDelegate <NSObject>

@optional

- (void)banner:(YBLGoodsBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index;

- (void)banner:(YBLGoodsBannerView *)bannerView currentItemAtIndex:(NSInteger)index;

- (void)banner:(YBLGoodsBannerView *)bannerView scrollToLastItem:(NSInteger)lastIndex;

@end

typedef NS_ENUM(NSInteger,GoodsBannerViewType) {
    GoodsBannerViewTypeGoodDetailBanner = 0,
    GoodsBannerViewTypeStoreBannerSetting
};

@interface YBLGoodsBannerView : UIView

@property (weak, nonatomic) id<YBLGoodsBannerDelegate> delegate;

@property (assign, nonatomic) NSInteger currentPageIndex;

@property (nonatomic, strong) NSArray *imageURLArray;

- (instancetype)initWithFrame:(CGRect)frame
                imageURLArray:(NSArray *)imageURLArray;

- (instancetype)initWithFrame:(CGRect)frame
                imageURLArray:(NSArray *)imageURLArray
          goodsBannerViewType:(GoodsBannerViewType)goodsBannerViewType;

@end

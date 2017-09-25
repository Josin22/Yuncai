//
//  YBLBannerView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLBannerViewDelegate <NSObject>

- (void)selectAction:(NSInteger)didSelectAtIndex didSelectView:(id)view;

@end

@interface YBLBannerView : UIView

- (instancetype)initViewWithFrame:(CGRect)frame
                         viewList:(NSArray *)viewList
                     timeInterval:(CGFloat)timeInterval;

- (instancetype)initImageViewWithFrame:(CGRect)frame
                             imageList:(NSArray<NSString *> *)imageList
                          timeInterval:(CGFloat)timeInterval;

- (instancetype)initImageViewWithFrame:(CGRect)frame
                      placeholderImage:(NSString *)placeholder
                             imageList:(NSArray<NSString *> *)imageList
                          timeInterval:(CGFloat)timeInterval;

@property (nonatomic, weak  ) id<YBLBannerViewDelegate> delegate;
@property (nonatomic, strong) UIPageControl         *pageControl;

@end

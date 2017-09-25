//
//  YBLCategoryListHeadView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLGoodListFilterItemHeadView.h"

static NSInteger const tag_filter_button = 216546541;

static NSString *const price_no_normal = @"jshop_price_arrow_normal";
/**
 *  升序
 */
static NSString *const price_up_select = @"jshop_price_arrow_up";
/**
 *  降序
 */
static NSString *const price_down_select = @"jshop_price_arrow_down";

@interface YBLGoodListFilterItemHeadView ()

{
    NSInteger currentIndex;
}

@end

@implementation YBLGoodListFilterItemHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews {
    
    currentIndex = 0;
    self.backgroundColor = [UIColor whiteColor];
    NSArray *title = @[key_composite,key_sale_count,key_price];
    NSInteger count = title.count;
    CGFloat width = YBLWindowWidth/count;
    CGFloat imageWi = 12;
    
    kWeakSelf(self)
    
    for (int i = 0; i < count; i++) {
        NSString *titleText = title[i];
        YBLCustomEventButton *filterButton = [[YBLCustomEventButton alloc] initWithFrame:CGRectMake(i*width, 0, width, self.height)];
        [filterButton setTitle:titleText forState:UIControlStateNormal];
        [filterButton setTitleColor:YBLColor(70, 70, 70, 1) forCurrentButtonState:CurrentButtonStateNormal];
        [filterButton setTitleColor:YBLThemeColor forCurrentButtonState:CurrentButtonStateClickFirstOnce];
        filterButton.titleLabel.font = YBLFont(14);
        filterButton.tag = tag_filter_button+i;
        filterButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [filterButton setTitleColor:YBLThemeColor forCurrentButtonState:CurrentButtonStateClickLastOnce];
        [filterButton setImage:[UIImage imageNamed:price_no_normal] forCurrentButtonState:CurrentButtonStateNormal];
        [filterButton setImage:[UIImage imageNamed:price_up_select] forCurrentButtonState:CurrentButtonStateClickFirstOnce];
        [filterButton setImage:[UIImage imageNamed:price_down_select] forCurrentButtonState:CurrentButtonStateClickLastOnce];
        filterButton.titleRect = CGRectMake(0, 0, width/2+space, self.height);
        filterButton.imageRect = CGRectMake(width/2+space, (self.height-imageWi)/2, imageWi, imageWi);
        if (i == currentIndex) {
            filterButton.currentButtonState = CurrentButtonStateClickLastOnce;
        }
        [self addSubview:filterButton];
        
        filterButton.clickBlock = ^(YBLCustomEventButton *button, CurrentButtonState currentButtonState) {
            kStrongSelf(self)
            NSInteger buttonIndex = button.tag-tag_filter_button;
            if (currentIndex!=buttonIndex) {
                YBLCustomEventButton *oldButton = (YBLCustomEventButton *)[self viewWithTag:currentIndex+tag_filter_button];
                oldButton.currentButtonState = CurrentButtonStateNormal;
                button.currentButtonState = CurrentButtonStateClickFirstOnce;
                currentIndex = buttonIndex;
            }
            BLOCK_EXEC(self.categoryListHeadViewItemClickBlock,button.currentTitle,currentButtonState)
        };
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}

@end







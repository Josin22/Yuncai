//
//  YBLHomeNavigationView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,NavigationType) {
    NavigationTypeHome = 0,
    NavigationTypeCatgory,
    NavigationTypeGoodList
};

@interface YBLHomeNavigationView : UIView

- (instancetype)initWithFrame:(CGRect)frame navigationType:(NavigationType)navigationType;

@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UILabel *searchLabel;

/**
 *  修改颜色
 */
- (void)changeColorWithState:(BOOL)state;

- (void)transFormMassageButtonOrgin;

@end

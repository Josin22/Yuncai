//
//  YBLShopCarLoginHeadView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLShopCarLoginHeadView : UIView

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *homeButton;

- (void)showNoGoodView;

- (void)showLoginView;

@end

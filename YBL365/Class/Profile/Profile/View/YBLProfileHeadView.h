//
//  YBLProfileHeadView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLASFillImageView.h"

@interface YBLProfileHeadView : UIView

@property (nonatomic, strong) YBLASFillImageView *userImageView;
@property (nonatomic, strong) UILabel     *userLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *rowImageView;
@property (nonatomic, strong) UILabel     *storeLabel;
@property (nonatomic, strong) UIView      *starView;
@property (nonatomic, strong) UIButton    *bgButton;

- (void)updateWithIsLogin:(BOOL)isLogin;

- (void)reloadUserHeaderView;

@end

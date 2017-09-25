//
//  YBLBriberyMoneyView.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat itemViewHI = 110;

typedef NS_ENUM(NSInteger, BriberyType) {
    /**
     *  正常红包
     */
    BriberyTypeNormal = 0,
    /**
     *  已经领取
     */
    BriberyTypeReceived,
    /**
     *  已经失效
     */
    BriberyTypeOverdued
};

@interface YBLBriberyItemView : UIView

@property (nonatomic, assign) BriberyType briberyType;

@property (nonatomic, strong) UIImageView *briberyIconImageView;

@property (nonatomic, strong) UILabel *briberyTitleLabel;

@property (nonatomic, strong) UILabel *briberyInfoLabel;

@property (nonatomic, strong) UIImageView *briberyStateImageView;

@property (nonatomic, strong) UILabel *briberyTypeLabel;

@end

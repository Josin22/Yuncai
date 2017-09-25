//
//  YBLShopCarBannerView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BarType) {
    BarTypeNormal = 0,
    BarTypeEdit
};

@interface YBLShopCarBarView : UIView

@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UIButton *buyButton;

//@property (nonatomic, strong) UILabel *subPriceLabel;
@property (nonatomic, strong) UILabel *realPriceLabel;

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *careButton;
@property (nonatomic, strong) UIButton *deleButton;


@property (nonatomic, assign) NSInteger goodNumber;

- (void)updateWithType:(BarType )carType;


@end

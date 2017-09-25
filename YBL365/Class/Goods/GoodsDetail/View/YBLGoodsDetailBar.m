//
//  YBLGoodsDetailBar.m
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLGoodsDetailBar.h"

static NSInteger BUTTON_TAG = 88888555;

@interface YBLGoodsDetailBar ()

@end

@implementation YBLGoodsDetailBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBarUI];
    }
    return self;
}

- (void)createBarUI{

    self.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
    
    CGFloat wid1 = self.width/5;
//    CGFloat wid2 = wid1*2;
    CGFloat height = self.height-0.5;
    
    CGFloat space = 20;
    
    self.storeButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.storeButton.frame = CGRectMake(0, 0.5, wid1, height);
    [self.storeButton setImage:[UIImage imageNamed:@"goods_store"] forState:UIControlStateNormal];
    [self.storeButton setTitle:@"店铺" forState:UIControlStateNormal];
    self.storeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.storeButton.tag = BUTTON_TAG;
    self.storeButton.titleLabel.font = YBLFont(10);
    self.storeButton.titleRect = CGRectMake(0, self.storeButton.height-13, self.storeButton.width, 12);
    self.storeButton.imageRect = CGRectMake(self.storeButton.width/2-(self.storeButton.height-space)/2, 5, self.storeButton.height-space, self.storeButton.height-space);
    [self.storeButton setTitleColor:YBLColor(70, 70, 70, 1) forState:UIControlStateNormal];
    [self.storeButton addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.storeButton];
    
    
    self.foucsButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.foucsButton.frame = CGRectMake(CGRectGetMaxX(self.storeButton.frame), self.storeButton.origin.y, wid1, height);
    [self.foucsButton setImage:[UIImage imageNamed:@"goods_foucs_normal"] forState:UIControlStateNormal];    
    [self.foucsButton setImage:[UIImage imageNamed:@"goods_foucs_select"] forState:UIControlStateSelected];
    [self.foucsButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.foucsButton setTitle:@"已关注" forState:UIControlStateSelected];
    self.foucsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.foucsButton.titleLabel.font = YBLFont(10);
    self.foucsButton.titleRect = CGRectMake(0, self.foucsButton.height-13, self.foucsButton.width, 12);
    self.foucsButton.imageRect = CGRectMake(self.foucsButton.width/2-(self.foucsButton.height-space)/2, 5, self.foucsButton.height-space, self.foucsButton.height-space);
    self.foucsButton.tag = BUTTON_TAG+1;
    [self.foucsButton setTitleColor:YBLColor(70, 70, 70, 1) forState:UIControlStateNormal];
    [self.foucsButton addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.foucsButton];
   
    UILabel *foucLabel = [[UILabel alloc] initWithFrame:[self.foucsButton frame]];
    foucLabel.textColor = YBLThemeColor;
    foucLabel.font = YBLFont(18);
    foucLabel.text = @"+1";
    foucLabel.textAlignment = NSTextAlignmentCenter;
    foucLabel.hidden = YES;
    [self addSubview:foucLabel];
    self.foucLabel = foucLabel;
     
    self.carButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.carButton.frame = CGRectMake(CGRectGetMaxX(self.foucsButton.frame), self.foucsButton.origin.y, wid1, height);
    [self.carButton setTitleColor:YBLColor(70, 70, 70, 1) forState:UIControlStateNormal];
    self.carButton.tag = BUTTON_TAG+2;
    self.carButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.carButton setTitle:@"购物车" forState:UIControlStateNormal];
    [self.carButton setImage:[UIImage imageNamed:@"gooddetail_car"] forState:UIControlStateNormal];
    self.carButton.titleRect = CGRectMake(0, self.carButton.height-13, self.carButton.width, 12);
    self.carButton.imageRect = CGRectMake(self.carButton.width/2-(self.carButton.height-space)/2, 5, self.carButton.height-space, self.carButton.height-space);
    [self.carButton addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.carButton.titleLabel.font = YBLFont(10);
    [self addSubview:self.carButton];
    
    self.addToCartButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    self.addToCartButton.frame = CGRectMake(CGRectGetMaxX(self.carButton.frame), 0, self.width-self.carButton.right, self.height);
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [self.addToCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    self.addToCartButton.tag = BUTTON_TAG+3;
    self.addToCartButton.titleLabel.font = YBLFont(18);
    [self.addToCartButton addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addToCartButton];
    
    YBLBadgeLabel *bageLabel = [[YBLBadgeLabel alloc] initWithFrame:CGRectZero];
    [self.carButton addSubview:bageLabel];
    bageLabel.bageValue = [YBLUserManageCenter shareInstance].cartsCount;
    bageLabel.left = wid1/2+bageLabel.width/2;
    bageLabel.top = 0;
    self.bageLabel = bageLabel;
}

- (void)buttonClickMethod:(YBLButton *)btn{

    NSInteger tag_index = btn.tag - BUTTON_TAG;
    BarItemType type = tag_index;
    if ([btn.currentTitle isEqualToString:@"加入购物车"]) {
        type = BarItemTypeAddToCart;
    } else if ([btn.currentTitle isEqualToString:@"到货通知"]) {
        type = BarItemTypeDaoHuoNotification;
    }
    BLOCK_EXEC(self.goodsDetailBarItemClickBlock,type,btn);
    /*
    if ([btn.currentTitle isEqualToString:@"店铺"]) {
        type = BarItemTypeStore;
    } else if ([btn.currentTitle isEqualToString:@"购物车"]) {
        type = BarItemTypeCart;
    } else if ([btn.currentTitle isEqualToString:@"加入购物车"]) {
        type = BarItemTypeAddToCart;
    } else if ([btn.currentTitle isEqualToString:@"到货通知"]) {
        type = BarItemTypeDaoHuoNotification;
    } else if ([btn.currentTitle isEqualToString:@"关注"]) {
        type = BarItemTypeFoucs;
        self.foucLabel.hidden = NO;
        [UIView animateWithDuration:1.5 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             self.foucLabel.top = -self.height*3/2;
                             self.foucLabel.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.foucLabel removeFromSuperview];
                             btn.enabled = !btn.enabled;
                         }];

    }
     */
 
}

- (void)setIsBarEnable:(BOOL)isBarEnable{
    
    _isBarEnable = isBarEnable;
    if (!_isBarEnable) {
        [self.addToCartButton setTitle:@"到货通知" forState:UIControlStateNormal];
        [self.addToCartButton setBackgroundColor:YBLColor(254, 181, 21, 1) forState:UIControlStateNormal];
    } else {
        [self.addToCartButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
        [self.addToCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
}

@end

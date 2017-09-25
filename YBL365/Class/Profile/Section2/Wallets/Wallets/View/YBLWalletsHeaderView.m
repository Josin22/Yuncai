//
//  YBLWalletsHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWalletsHeaderView.h"

@interface YBLWalletsHeaderView ()

@end

@implementation YBLWalletsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = YBLThemeColorAlp(.8);
    
    CGFloat bottomHi = 40;
    CGFloat tophHi = self.height-bottomHi;
    
    self.yunMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, self.width-space*2, 30)];
    self.yunMoneyLabel.text = @"0.00 个";
    self.yunMoneyLabel.textColor = [UIColor whiteColor];
    self.yunMoneyLabel.font = YBLFont(25);
    self.yunMoneyLabel.centerY = tophHi/2-self.yunMoneyLabel.height/2;
    [self addSubview:self.yunMoneyLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, self.yunMoneyLabel.bottom+space, self.yunMoneyLabel.width, 20)];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = YBLFont(12);
    infoLabel.text = @"小云币 , 大用处 , 进货不花钱";
    [self addSubview:infoLabel];
 
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-bottomHi, self.width, bottomHi)];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    [self addSubview:bottomView];
    
    if ([[YBLUserManageCenter shareInstance].userInfoModel.mobile isEqualToString:TEST_MOBILE]) {
        return;
    }
    
    self.goRechargeWalletsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goRechargeWalletsButton.frame = CGRectMake(0, 0, bottomView.width/2, bottomView.height);
    [self.goRechargeWalletsButton setTitle:@"去充值" forState:UIControlStateNormal];
    [self.goRechargeWalletsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goRechargeWalletsButton.titleLabel.font = YBLFont(16);
    [bottomView addSubview:self.goRechargeWalletsButton];
    
    self.unfineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unfineButton.frame = CGRectMake(bottomView.width/2, 0, bottomView.width/2, bottomView.height);
    [self.unfineButton setTitle:@"优惠券" forState:UIControlStateNormal];
    [self.unfineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.unfineButton.titleLabel.font = YBLFont(16);
    [bottomView addSubview:self.unfineButton];
    
    UIView *lineView = [YBLMethodTools addLineView:CGRectMake(bottomView.width/2, space, 1, bottomView.height-space*2)];
    lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    [bottomView addSubview:lineView];
    
}

@end

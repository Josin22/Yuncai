//
//  YBLProfileWaveHeaderView.m
//  YC168
//
//  Created by 乔同新 on 2017/7/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLProfileWaveHeaderView.h"

@interface YBLProfileWaveHeaderView ()

@property (nonatomic, retain) UILabel *nickNameLabel;

@property (nonatomic, retain) UILabel *companyTypeLabel;

@end

@implementation YBLProfileWaveHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    CGFloat waveHeight = 15;
    
    self.waveView = [[JSWave alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.waveView.waveHeight = waveHeight;
    self.waveView.waveSpeed = .5;
    [self addSubview:self.waveView];
    [self.waveView startWaveAnimation];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = CGRectMake(0, 30, self.width, self.height-waveHeight-30);
    [self addSubview:bgButton];
    self.bgButton = bgButton;
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    userImageView.frame = CGRectMake(0, 0, self.bgButton.width/5, self.bgButton.width/5);
    userImageView.centerX = self.bgButton.width/2;
    userImageView.layer.cornerRadius = userImageView.height/2;
    userImageView.layer.masksToBounds = YES;
    userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    userImageView.layer.borderWidth = 1;
    userImageView.userInteractionEnabled = YES;
    [self.bgButton addSubview:userImageView];
    self.userImageView = userImageView;
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] init];
    [self.userImageView addGestureRecognizer:userTap];
    self.userTap = userTap;
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, userImageView.bottom+space, self.bgButton.width, 15)];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = YBLFont(13);
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgButton addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    
    UILabel *companyTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nickNameLabel.bottom+10, nickNameLabel.width, nickNameLabel.height)];
    companyTypeLabel.textColor = [UIColor whiteColor];
    companyTypeLabel.font = YBLFont(13);
    companyTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgButton addSubview:companyTypeLabel];
    self.companyTypeLabel = companyTypeLabel;
    
    self.setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.setButton.frame = CGRectMake(self.width - 45 - 10, 20, 45, 44);
    [self.setButton setImage:[UIImage imageNamed:@"nav_setting_icon_22x22_"] forState:UIControlStateNormal];
    [self addSubview:self.setButton];
    
}

- (void)reloadHeaderData{
    
    BOOL isLogin = [YBLUserManageCenter shareInstance].isLoginStatus;
    if (isLogin) {
        [self.userImageView setImage:[UIImage imageNamed:@"login_head_icon_70x70_"] ];
    }else {
        [self.userImageView setImage:[UIImage imageNamed:@"unlogin_head_icon_70x70_"]];
    }
    if ([YBLUserManageCenter shareInstance].userInfoModel.nickname) {
        self.nickNameLabel.text = [YBLUserManageCenter shareInstance].userInfoModel.nickname;
    } else {
        self.nickNameLabel.text = @"设置个昵称吧";
    }
    NSString *shopName = [YBLUserManageCenter shareInstance].userInfoModel.shopname==nil?@"":[YBLUserManageCenter shareInstance].userInfoModel.shopname;
    if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
        NSString *com_type = [YBLUserManageCenter shareInstance].userInfoModel.company_type_title==nil?@"":[YBLUserManageCenter shareInstance].userInfoModel.company_type_title;
        self.companyTypeLabel.text = [NSString stringWithFormat:@"%@(%@)",shopName,com_type];
    } else {
        self.companyTypeLabel.text = [NSString stringWithFormat:@"%@",shopName];
    }
    NSString *useIconUrl = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
    if ([useIconUrl rangeOfString:@"missing.png"].location == NSNotFound) {
        [self.userImageView js_alpha_setImageWithURL:[NSURL URLWithString:useIconUrl] placeholderImage:nil];
    }
}

@end

//
//  YBLProfileHeadView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLProfileHeadView.h"

@interface YBLProfileHeadView ()

@end

@implementation YBLProfileHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViewsWithLogin:NO];
    }
    return self;
}


- (void)createSubViewsWithLogin:(BOOL)isLogin {
    if (!self.bgImageView) {
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.userInteractionEnabled = YES;
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(@0);
        }];
    }
    if (!self.bgButton) {
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.bgButton];
        [self.bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(@0);
        }];
    }
    if (!self.userImageView) {
        self.userImageView = [[YBLASFillImageView alloc] initWithFrame:CGRectMake(20, 0, 60, 60)];
        self.userImageView.centerY = self.height/2;
        self.userImageView.layer.cornerRadius = self.userImageView.height/2;
        self.userImageView.layer.masksToBounds = YES;

        self.userImageView.backgroundColor = YBLColor(200, 200, 200, 0.5);
        [self addSubview:self.userImageView];
    }
    
    if (!self.userLabel) {
        self.userLabel = [[UILabel alloc] init];
        self.userLabel.textColor = [UIColor whiteColor];
        self.userLabel.font = YBLFont(16);
        [self addSubview:self.userLabel];
    }
    if (!self.starView) {
        self.starView = [[UIView alloc] initWithFrame:CGRectMake(20, self.height-10-20, 92, 20)];
        [self addSubview:self.starView];
        /*
        for (int i = 0; i < 5; i++) {
            UIButton *xingjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [xingjiButton setImage:[UIImage imageNamed:@"store_xinji_normal"] forState:UIControlStateNormal];
            [xingjiButton setImage:[UIImage imageNamed:@"store_xinji_select"] forState:UIControlStateSelected];
            xingjiButton.frame = CGRectMake(i*(20+3), 0, 20, 20);
            xingjiButton.selected = YES;
            [self.starView addSubview:xingjiButton];
        }
         */
    }
    if (!self.storeLabel) {
        self.storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.starView.right+4*space, self.starView.top, self.width-self.starView.right-5*space, self.starView.height)];
        self.storeLabel.centerX = self.width/2;
        self.storeLabel.textAlignment = NSTextAlignmentCenter;
        self.storeLabel.textColor = YBLColor(80, 76, 79, 1);
        self.storeLabel.font = YBLFont(15);
        [self addSubview:self.storeLabel];
    }
    
    if (!isLogin) {
        self.userLabel.text = @"登录/注册";
        [self.userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            make.centerY.equalTo(self.userImageView.mas_centerY);
            make.height.equalTo(@40);
        }];
        [self.userImageView setImage:[UIImage imageNamed:@"unlogin_head_icon_70x70_"]];
        self.rowImageView.hidden = YES;
        self.starView.hidden = YES;
        self.storeLabel.hidden = YES;
    }else {
        self.userLabel.text = @"您还没有昵称";
        self.storeLabel.text = @"";
        [self.userImageView setImage:[UIImage imageNamed:@"login_head_icon_70x70_"] ];
        [self.userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userImageView.mas_right).with.offset(10);
            make.top.equalTo(self.userImageView.mas_top);
            make.height.equalTo(@38);
        }];
        
        if (!self.rowImageView) {
            self.rowImageView = [[UIImageView alloc] init];
            self.rowImageView.image = [UIImage imageNamed:@"flight_datebar_arrow_right"];
            [self addSubview:self.rowImageView];
            [self.rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@7);
                make.height.equalTo(@16);
                make.right.equalTo(@-20);
                make.centerY.equalTo(self.userImageView.mas_centerY);
            }];
        }
        
        self.starView.hidden = NO;
        self.storeLabel.hidden = NO;
    }
 
}


- (void)updateWithIsLogin:(BOOL)isLogin {
    [self createSubViewsWithLogin:isLogin];
    if (isLogin) {
        self.bgImageView.image = [UIImage imageNamed:@"jshop_scratch_bg"];
    }else {
        self.bgImageView.image = [UIImage imageNamed:@"my_unlogin_bg_p_375x160_"];
    }
}

- (void)reloadUserHeaderView{

    if ([YBLUserManageCenter shareInstance].userInfoModel.nickname) {
        self.userLabel.text = [YBLUserManageCenter shareInstance].userInfoModel.nickname;
    } else {
        self.userLabel.text = @"设置个昵称吧";
    }
    NSString *shopName = [YBLUserManageCenter shareInstance].userInfoModel.shopname==nil?@"":[YBLUserManageCenter shareInstance].userInfoModel.shopname;
    if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller) {
        NSString *com_type = [YBLUserManageCenter shareInstance].userInfoModel.company_type_title==nil?@"":[YBLUserManageCenter shareInstance].userInfoModel.company_type_title;
        self.storeLabel.text = [NSString stringWithFormat:@"%@(%@)",shopName,com_type];
    } else {
        self.storeLabel.text = [NSString stringWithFormat:@"%@",shopName];
    }
    NSString *useIconUrl = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
    if ([useIconUrl rangeOfString:@"missing.png"].location == NSNotFound) {
        [self.userImageView js_alpha_setImageWithURL:[NSURL URLWithString:useIconUrl] placeholderImage:nil];
    }
}

@end

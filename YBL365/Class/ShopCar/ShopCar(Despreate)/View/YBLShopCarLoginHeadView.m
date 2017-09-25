//
//  YBLShopCarLoginHeadView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarLoginHeadView.h"

@implementation YBLShopCarLoginHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = VIEW_BASE_COLOR;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(@0);
            make.height.equalTo(@10);
        }];
        
    }
    return self;
}

- (void)showLoginView{
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"登录后同步电脑与手机购物车中的商品";
    descLabel.font = YBLFont(13);
    descLabel.textColor = YBLColor(120, 120, 120, 1.0);
    [self addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.height.equalTo(@22);
        make.centerX.equalTo(self.mas_centerX).with.offset(37.5);
    }];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton = loginButton;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:YBLColor(120, 120, 120, 1.0) forState:UIControlStateNormal];
    loginButton.titleLabel.font = YBLFont(13);
    loginButton.layer.cornerRadius = 3;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.borderWidth = 0.5;
    loginButton.layer.borderColor = YBLColor(120, 120, 120, 1.0).CGColor;
    [self addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(descLabel.mas_left).with.offset(-10);
        make.height.equalTo(@22);
        make.width.equalTo(@65);
        make.top.equalTo(@5);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_BASE_COLOR;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.top.equalTo(loginButton.mas_bottom).with.offset(4.5);
    }];
}


- (void)showNoGoodView {
    UILabel *descLabel2 = [[UILabel alloc] init];
    descLabel2.text = @"购物车是空的,您可以";
    descLabel2.font = YBLFont(13);
    descLabel2.textColor = YBLColor(180, 180, 180, 1.0);
    [self addSubview:descLabel2];
    [descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.loginButton == nil){
            make.top.equalTo(@30);
        }else {
            make.top.equalTo(self.loginButton.mas_bottom).with.offset(30);
        }
        make.height.equalTo(@20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"cartNoContentIcon"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@33);
        make.right.equalTo(descLabel2.mas_left).with.offset(-10);
        make.centerY.equalTo(descLabel2.mas_centerY);
    }];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.homeButton = homeButton;
    [homeButton setTitle:@"逛逛首页" forState:UIControlStateNormal];
    [homeButton setTitleColor:YBLColor(120, 120, 120, 1.0) forState:UIControlStateNormal];
    homeButton.titleLabel.font = YBLFont(13);
    homeButton.layer.cornerRadius = 3;
    homeButton.layer.masksToBounds = YES;
    homeButton.layer.borderWidth = 0.5;
    homeButton.layer.borderColor = YBLColor(120, 120, 120, 1.0).CGColor;
    [self addSubview:homeButton];
    [homeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(descLabel2.mas_right).with.offset(10);
        make.height.equalTo(@22);
        make.width.equalTo(@65);
        make.centerY.equalTo(descLabel2.mas_centerY);
    }];
}

- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}




@end

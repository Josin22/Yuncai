//
//  YBLSearchNavView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLSearchNavView.h"

@implementation YBLSearchNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = self.height/2;
        self.layer.masksToBounds = YES;
        self.backgroundColor = YBLColor(240, 242, 245, 1.0);
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(@0);
    }];
    __weak typeof (self)weakSelf = self;
    [[searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (weakSelf.searchBlock) {
            weakSelf.searchBlock();
        }
    }];
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7.5, 15, 15)];
    searchImageView.image = [UIImage imageNamed:@"JDMainPage_icon_search02_15x15_"];
    [searchButton addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@8);
        make.centerY.equalTo(searchButton.mas_centerY);
        make.width.height.equalTo(@15);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = YBLFont(14);
    titleLabel.text = @"搜索云采商品/店铺";
    titleLabel.textColor = YBLColor(170, 172, 179, 1);
    [searchButton addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(searchImageView.mas_right).with.offset(3);
    }];
    self.titleLabel = titleLabel;
}

@end

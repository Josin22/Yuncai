//
//  YBLCategoryListHeadView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryListHeadView.h"


@implementation YBLCategoryListHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
        _lastFilterButton = self.synthesisButton;
        self.layer.masksToBounds = YES;
    }
    return self;
}


- (void)createSubViews {
    CGFloat width = YBLWindowWidth/4;
    self.synthesisButton = [YBLCustomButton buttonWithType:UIButtonTypeCustom];
    [self.synthesisButton setTitle:@"综合" forState:UIControlStateNormal];
    self.synthesisButton.titleLabel.font = YBLFont(14);
    [self.synthesisButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    [self.synthesisButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.synthesisButton setImage:[UIImage imageNamed:@"Mystow_down_normal_4x2_"] forState:UIControlStateNormal];
    [self.synthesisButton setImage:[UIImage imageNamed:@"Mystow_down_selected_4x2_"] forState:UIControlStateSelected];
    self.synthesisButton.frame = CGRectMake(0, 0, width, 45);
    [self addSubview:self.synthesisButton];
    
    
    self.salesButton = [YBLCustomButton buttonWithType:UIButtonTypeCustom];
    [self.salesButton setTitle:@"销量" forState:UIControlStateNormal];
    self.salesButton.titleLabel.font = YBLFont(14);
    [self.salesButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    [self.salesButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.salesButton.frame = CGRectMake(width, 0, width, 45);
    [self addSubview:self.salesButton];
    
    
    self.priceButton = [YBLCustomButton buttonWithType:UIButtonTypeCustom];
    self.priceButton.upImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mystow_up_normal_4x2_"]];
    self.priceButton.bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mystow_down_normal_4x2_"]];
    
    [self.priceButton addSubview:self.priceButton.upImageView];
    [self.priceButton addSubview:self.priceButton.bottomImageView];
    [self.priceButton setTitle:@"价格" forState:UIControlStateNormal];
    self.priceButton.titleLabel.font = YBLFont(14);
    [self.priceButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    [self.priceButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.priceButton.frame = CGRectMake(width*2, 0, width, 45);
    [self addSubview:self.priceButton];
    
    
    self.filterButton = [YBLCustomButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
    self.filterButton.titleLabel.font = YBLFont(14);
    [self.filterButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    [self.filterButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.filterButton setImage:[UIImage imageNamed:@"search_sort_filter_icon"] forState:UIControlStateNormal];
    [self.filterButton setImage:[UIImage imageNamed:@"search_sort_filter_red_icon"] forState:UIControlStateSelected];
    self.filterButton.frame = CGRectMake(width*3, 0, width, 45);
    [self addSubview:self.filterButton];
    
    
    
    
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    
    CGFloat bgWidth = width - 16;
    for (int i = 0 ; i < 4; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8*(i+1)+i*(bgWidth+8), 53, bgWidth, 29)];
        switch (i) {
            case 0:
                self.bgView1 = bgView;
                break;
            case 1:
                self.bgView2 = bgView;
                break;
            case 2:
                self.bgView3 = bgView;
                break;
            case 3:
                self.bgView4 = bgView;
                break;
                
            default:
                break;
        }
        bgView.backgroundColor = YBLColor(240, 240, 240, 1.0);
        bgView.layer.cornerRadius = 3;
        [self addSubview:bgView];
    }
    
    
    
    self.descButtton1 = [self createSubButton:@"云采配送" upImage:nil  bottomImage:nil];
    self.descButtton1.frame = CGRectMake(0, 46, width, 43);
    [self.descButtton1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self addSubview:self.descButtton1];
    
    
    self.descButtton2 = [self createSubButton:@"品牌" upImage:@"Mystow_down_normal_4x2_" bottomImage:@"Mystow_up_normal_4x2_"];
    self.descButtton2.frame = CGRectMake(width, 46, width, 43);
    [self addSubview:self.descButtton2];
    
    
    self.descButtton3 = [self createSubButton:@"颜色" upImage:@"Mystow_down_normal_4x2_" bottomImage:@"Mystow_up_normal_4x2_"];
    self.descButtton3.frame = CGRectMake(width*2, 46, width, 43);
    [self addSubview:self.descButtton3];
    
    
    self.descButtton4 = [self createSubButton:@"尺寸" upImage:@"Mystow_down_normal_4x2_" bottomImage:@"Mystow_up_normal_4x2_"];
    self.descButtton4.frame = CGRectMake(width*3, 46, width, 43);
    [self addSubview:self.descButtton4];
    

    
}

- (YBLCustomButton *)createSubButton:(NSString *)title upImage:(NSString *)upImage bottomImage:(NSString *)bottomImage {
    YBLCustomButton *button = [YBLCustomButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    if (upImage) {
        [button setImage:[UIImage imageNamed:upImage] forState:UIControlStateNormal];
    }
    if (bottomImage) {
        [button setImage:[UIImage imageNamed:bottomImage] forState:UIControlStateSelected];
    }
    button.titleLabel.font = YBLFont(13);
    [button setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    return button;
}


@end







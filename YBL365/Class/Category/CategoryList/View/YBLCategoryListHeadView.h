//
//  YBLCategoryListHeadView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLCustomButton.h"


@interface YBLCategoryListHeadView : UIView

//综合
@property (nonatomic, strong) YBLCustomButton *synthesisButton;

@property (nonatomic, assign) BOOL isSynthesis;

//销量
@property (nonatomic, strong) YBLCustomButton *salesButton;
//价格
@property (nonatomic, strong) YBLCustomButton *priceButton;
//筛选
@property (nonatomic, strong) YBLCustomButton *filterButton;

@property (nonatomic, assign) BOOL isPrice;

@property (nonatomic, strong) YBLCustomButton *descButtton1;
@property (nonatomic, strong) YBLCustomButton *descButtton2;
@property (nonatomic, strong) YBLCustomButton *descButtton3;
@property (nonatomic, strong) YBLCustomButton *descButtton4;


@property (nonatomic, strong) UIView *bgView1;
@property (nonatomic, strong) UIView *bgView2;
@property (nonatomic, strong) UIView *bgView3;
@property (nonatomic, strong) UIView *bgView4;


@property (nonatomic, strong) YBLCustomButton *lastFilterButton;









@end

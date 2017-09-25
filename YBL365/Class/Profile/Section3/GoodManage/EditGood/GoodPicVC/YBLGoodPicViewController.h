//
//  YBLGoodPicViewController.h
//  YC168
//
//  Created by 乔同新 on 2017/6/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMainViewController.h"

@class YBLGoodModel;

@interface YBLGoodPicViewController : YBLMainViewController

@property (nonatomic, assign) GoodCategoryType goodCategoryType;

@property (nonatomic, strong) YBLGoodModel *pModel;

@end

//
//  YBLCategoryListService.h
//  YBL365
//
//  Created by 乔同新 on 16/12/22.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CategoryFilterType) {
    CategoryFilterTypeSynthesis = 0,
    CategoryFilterTypeScale,
    CategoryFilterTypePriceDown,
    CategoryFilterTypeUp,
    CategoryFilterTypeFilter
};

@class YBLCategoryListViewController;

@interface YBLCategoryListService : NSObject


@property (nonatomic, weak)YBLCategoryListViewController *categoryListVC;

//是否是单排
@property (nonatomic, assign) BOOL isList;


- (void)updateWithGoodArray:(NSArray *)dataArray;

@end

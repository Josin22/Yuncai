//
//  YBLGoodListViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLTwotageMuduleViewModel.h"


@interface YBLGoodListViewModel : YBLTwotageMuduleViewModel
/**
 *  关键字搜索
 */
@property (nonatomic, strong) NSString          *keyWord;
/**
 *  二级商品id
 */
@property (nonatomic, strong) NSString          *category_id;
/**
 *  店铺id
 */
@property (nonatomic, strong) NSString          *userinfo_id;
/**
 *  排序 顺序
 */
@property (nonatomic, assign) OrderSequence     orderSequence;
/**
 *  排序 字段
 */
@property (nonatomic, assign) OrderSequenceText orderSequenceText;

@property (nonatomic, assign) CGFloat           lastPosition;

@property (nonatomic, assign) NSInteger         page_list;

@property (nonatomic, assign) NSInteger         page_count;

@property (nonatomic, strong) NSMutableArray    *searchDataArray;

- (RACSignal *)siganlForSearchGoodsAgain:(BOOL)isNewSearch;

@end

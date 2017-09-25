//
//  YBLTwotageMuduleViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"
#import "YBLFloorsModel.h"
#import "YBLPerPageBaseViewModel.h"

@interface YBLTwotageMuduleViewModel : YBLPerPageBaseViewModel

@property (nonatomic, copy  ) NSString            *titleImageUrl;
@property (nonatomic, copy  ) NSString            *titleText;
@property (nonatomic, assign) NSInteger           index;
@property (nonatomic, strong) NSArray             *moduleArray;
///全部二级下所有商品
///@{@():@[]}
@property (nonatomic, strong) NSMutableDictionary *allModuleDataDict;
///二级
@property (nonatomic, strong) NSMutableDictionary *allModulePageDict;
///
@property (nonatomic, strong) NSMutableDictionary *allModuleNoMoreDataDict;


- (RACSignal *)siganlForGoodListIdex:(NSInteger)index categoryID:(NSString *)categoryID isReload:(BOOL)isReload;

- (RACSignal *)siganlForGoodListIdex:(NSInteger)index isReload:(BOOL)isReload;

- (RACSignal *)siganlForGoodListCategoryID:(NSString *)categoryID
                                userinfoID:(NSString *)userinfoID
                                searchText:(NSString *)searchText
                                orderField:(NSString *)orderField
                                  orderAsc:(NSString *)orderAsc
                                      page:(NSInteger)page;

- (NSString *)getCurrentModuleCategoryIDWithIndex:(NSInteger)index;

- (NSMutableArray *)getSingleItemDataArrayWithIndex:(NSInteger)index;

@end

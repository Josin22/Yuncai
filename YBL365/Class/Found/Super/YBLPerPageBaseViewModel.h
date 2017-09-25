//
//  YBLPerPageBaseViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLCategoryTreeModel.h"

@interface YBLPerPageBaseViewModel : NSObject
{
    NSInteger page_index;
}

@property (nonatomic, strong) NSMutableArray *fin_indexps;

/*  ---------------------------  单个tablevie -------------------------------  */
/**
 *  单个tableview是否无更多数据
 */
@property (nonatomic, assign) BOOL                              isNoMoreData;
/**
 *  单个tableview数据
 */
@property (nonatomic, strong) NSMutableArray                    *singleDataArray;
/**
 *  单个列表加载更多条件
 *
 *  @return bool
 */
- (BOOL)isSatisfyLoadMoreRequest;

- (RACSignal *)siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                          url:(NSString *)url
                                                     isReload:(BOOL)isReload;

- (RACSignal *)siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                     isReload:(BOOL)isReload
                                                          url:(NSString *)url
                                                      dictKey:(NSString *)dictKey
                                                jsonClassName:(NSString *)jsonClassName;

- (RACSignal *)js_siganlForSingleListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                        isReload:(BOOL)isReload
                                                             url:(NSString *)url
                                                         dictKey:(NSString *)dictKey
                                                   jsonClassName:(NSString *)jsonClassName;

/**
 *  是否在请求
 */
@property (nonatomic, assign) BOOL                              isReqesuting;

- (void)hanldeTitleData;

/*  ---------------------------  多个tablevie -------------------------------  */
/**
 *  多tableview采购订单数据
 */
@property (nonatomic, strong) NSMutableDictionary               *all_purchase_order_data_dict;
/**
 *  多tableview各分类当前的page
 */
@property (nonatomic, strong) NSMutableDictionary               *all_page_data_dict;
/**
 *  多tableview分类名字  warning:若想没有第一个全部,则子类init时remove all ,add 自己 obj
 */
@property (nonatomic, strong) NSMutableArray                    *all_title_data_array;
/**
 *  多个tableview当前index
 */
@property (nonatomic, assign) NSInteger                         currentFoundIndex;
@property (nonatomic, strong) NSString                          *selectTitle;
@property (nonatomic, strong) NSArray<NSArray *>                *titleArray;
/**
 *  多tableview各自分类是否无更多数据
 */
@property (nonatomic, strong) NSMutableDictionary               *all_is_nomore_data_dict;
/**
 *  当前index索引下的数据
 *
 *  @param index 当前index索引
 *
 *  @return 数据
 */
- (NSMutableArray *)getCurrentDataArrayWithIndex:(NSInteger)index;
/**
 *  多个列表加载更多条件
 *
 *  @param index 当前索引
 *
 *  @return bool
 */
- (BOOL)isSatisfyRequestWithIndex:(NSInteger)index;

/**
 *  多个列表加载更多 old!!!
 *
 *  @param para                 para
 *  @param url                  url
 *  @param isReload             isReload
 *
 *  @return siganl
 */
- (RACSignal *)siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                        url:(NSString *)url
                                                   isReload:(BOOL)isReload;
/**
 *  多个列表加载更多 new!!!
 *
 *  @param para                 para
 *  @param url                  url
 *  @param isReload             isReload
 *
 *  @return siganl
 */
- (RACSignal *)siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                   isReload:(BOOL)isReload
                                                        url:(NSString *)url
                                                    dictKey:(NSString *)dictKey
                                              jsonClassName:(NSString *)jsonClassName;

- (RACSignal *)js_siganlForManyListViewRequestLoadMoreWithPara:(NSMutableDictionary *)para
                                                      isReload:(BOOL)isReload
                                                           url:(NSString *)url
                                                       dictKey:(NSString *)dictKey
                                                 jsonClassName:(NSString *)jsonClassName;
/* 处理数据 和 indexps */

- (NSMutableArray *)getNewIndexpathWithDataArray:(NSArray *)dataArray
                                      categotyID:(NSString *)categoryID
                                        isReload:(BOOL)isReload;

- (NSMutableArray *)getNewIndexpathWithDataArray:(NSArray *)dataArray
                                      categotyID:(NSString *)categoryID
                                        isReload:(BOOL)isReload
                                   isFromSection:(BOOL)isFromSection;

@end

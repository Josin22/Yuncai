//
//  YBLGoodsManageViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"
#import "YBLPerPageBaseViewModel.h"

@interface YBLGoodsManageViewModel : YBLPerPageBaseViewModel

/**
 *  old
 */
//@property (nonatomic, strong) NSMutableArray      *titleArray;
//@property (nonatomic, strong) NSMutableDictionary *allGoodListDict;
//@property (nonatomic, strong) RACSignal           *GoodListSignal;

- (RACSignal *)siganlForStoreWithIndex:(NSInteger)index isReload:(BOOL)isReload;

/**
 *  上架
 *
 *  @param _id 商品id
 *
 *  @return racsiganl
 */
- (RACSignal *)siganlForOnlineGoodWithId:(NSString *)_id;
/**
 *  下架
 *
 *  @param _id 商品id
 *
 *  @return racsiganl
 */
- (RACSignal *)siganlForOfflineGoodWithId:(NSString *)_id;

+ (RACSignal *)siganlForChangeGoodStatusWithID:(NSString *)_id isOnline:(BOOL)isOnline;
/**
 *  删除商品
 *
 *  @param _id 商品id
 *
 *  @return return value
 */
+ (RACSignal *)siganlForDeleteGoodWithId:(NSString *)_id;

@end

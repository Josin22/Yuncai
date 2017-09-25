//
//  YBLAddGoodListViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"

@interface YBLAddGoodListViewModel : NSObject

@property (nonatomic, assign) GoodCategoryType goodCategoryType;

@property (nonatomic, strong) NSMutableArray *goodListArray;

@property (nonatomic, strong) NSString *category_id;

@property (nonatomic, strong) NSString *keyword;

@property (nonatomic, assign) BOOL isNoMoreData;

@property (nonatomic, assign) BOOL isRequesting;

- (RACSignal *)singalForMoreCategoryDataListRealod:(BOOL)isReload;

+ (RACSignal *)singalForSaveToStoreWithId:(NSString *)_id;

- (RACSignal *)singalForSaveToStoreWithId:(NSString *)_id;

- (RACSignal *)siganlForProductSearchIsReload:(BOOL)isReload;

@end

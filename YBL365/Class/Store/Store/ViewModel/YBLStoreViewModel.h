//
//  YBLStoreViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLShopFixtrueModel.h"
#import "YBLShopModel.h"
#import "YBLPerPageBaseViewModel.h"

typedef NS_ENUM(NSInteger,StoreType) {
    StoreTypeOpen = 0,//
    StoreTypePersonal //个人店铺
};

@interface YBLStoreViewModel : YBLPerPageBaseViewModel

@property (nonatomic, assign) StoreType storeType;

@property (nonatomic, strong) NSString *shopid;

@property (nonatomic, strong) shop     *shopinfo;

@property (nonatomic, strong) NSMutableDictionary *goodCategoryDataDict;

@property (nonatomic, strong) NSMutableArray *nummberValueArray;

- (RACSignal *)signalForGetShopFixtrue;

- (RACSignal *)signalForUploadShopLogoWithImage:(UIImage *)image;

+ (RACSignal *)signalForShopDataWithID:(NSString *)shopID isReload:(BOOL)isReload;

- (RACSignal *)signalForShopDataWithIsReload:(BOOL)isReload;

- (RACSignal *)signalForShopDataWithID:(NSString *)shopID
                           category_id:(NSString *)category_id
                              isReload:(BOOL)isReload;

+ (RACSignal *)signalForStore:(NSString *)storeID isFollow:(BOOL)isFollow;
- (RACSignal *)signalForStoreFollow:(BOOL)isFollow;

- (BOOL)isHasBriberyMoney;

@end

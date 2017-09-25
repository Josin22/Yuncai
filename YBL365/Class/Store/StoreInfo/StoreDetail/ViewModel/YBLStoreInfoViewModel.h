//
//  YBLStoreInfoViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class shop,YBLShopInfoModel;

@interface YBLStoreInfoViewModel : NSObject

@property (nonatomic, strong) shop *shopModel;

@property (nonatomic, assign) NSInteger allProductCount;
//new
@property (nonatomic, strong) YBLShopInfoModel *shopInfoModel;

@property (nonatomic, strong) NSMutableArray *cellDataArray;
//old
//- (RACSignal *)siganlForStoreInfo;

+ (RACSignal *)siganlForShopInfoWithShopID:(NSString *)shopid;

- (RACSignal *)siganlForShopInfo;

@end

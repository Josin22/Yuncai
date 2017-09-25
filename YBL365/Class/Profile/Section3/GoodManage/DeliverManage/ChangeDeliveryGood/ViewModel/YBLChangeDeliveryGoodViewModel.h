//
//  YBLChangeDeliveryGoodViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLChangeDeliveryGoodViewModel : NSObject

@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  id
 */
@property (nonatomic, copy) NSString *_id;
/**
 *  获取快递物流数组-->>NSMutableDictionary
 */
@property (nonatomic, strong) NSMutableDictionary *getExpressCompanyDataDict;
/**
 *  获取地区价格数组-->>NSMutableDictionary
 */
@property (nonatomic, strong) NSMutableDictionary *getAreaPriceDataDict;
/**
 *  获取商品价格物流信息-->>RACSignal
 */
- (RACSignal *)getShippingPricesSiganl;
+ (RACSignal *)getShippingPricesSiganlWithID:(NSString *)_id;

/**
 *  设置商品配送
 */
- (RACSignal *)settingGoodShippingPriceSiganl;

@end

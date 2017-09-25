//
//  YBLChooseDeliveryViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLChooseDeliveryViewModel : NSObject
/**
 *  已选商品
 */
@property (nonatomic, strong) NSMutableArray *selectGoodsArray;
/**
 *  已选快递
 */
@property (nonatomic, strong) NSMutableArray *selectExpressCompanyArray;
/**
 *  添加到地区的快递物流
 */
@property (nonatomic, strong) NSMutableArray *addToAreaAddressArray;
/**
 *  获取已开通物流公司列表
 */
@property (nonatomic, strong) RACSignal *validExpressCompaniesSiganl;

- (BOOL)isHaveSelectGoods;

- (BOOL)isHaveSelectExpressCompany;

+ (RACSignal *)validExpressCompaniesSiganl;

- (RACSignal *)siganlForSettingShippingsPricesWith:(NSMutableDictionary *)selectAreaDict;

@end

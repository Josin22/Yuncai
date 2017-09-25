//
//  YBLShopCarService.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ParseDataBlock)(NSArray *carGoodArray);
typedef void(^ParsePriceBlock)(CGFloat allPrice, CGFloat subPrice, BOOL isCheckAll,NSInteger goodNumber);

@interface YBLShopCarService : NSObject

//购物车数据组装回调
@property (nonatomic, copy) ParseDataBlock parseDataBlock;

//解析购物车价格
@property (nonatomic, copy) ParsePriceBlock parsePriceBlock;

//组装购物车数据
- (void)starParseCarGoods:(NSArray *)carGoodArray;

//解析价格 是否全选
- (void)parseAllPriceAndIsSelectedAllWithGoodArray:(NSArray *)goodArray;

//解析编辑状态下 是否全选
- (void)parseDeleteAll:(NSArray *)goodArray block:(void(^)(BOOL isCheckAll))block;

//解析选中的商品 去下单
- (void)parseSelectedOrderGoodArray:(NSArray *)goodArray block:(void(^)(NSArray *orderGoodArray))block;


@end

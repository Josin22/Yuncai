//
//  YBLShopCarService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarService.h"
#import "YBLShopCarTempGoodModel.h"

@implementation YBLShopCarService

//解析数据
- (void)starParseCarGoods:(NSArray *)carGoodArray {
    
    //先解析单例中的数据
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *shops = [NSMutableArray array];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSDictionary *cargood in [YBLShopCarModel shareInstance].carGoodArray) {
        NSString *shop = cargood[@"shop"];
        NSMutableArray *items = [tempDic objectForKey:shop];
        if (items == nil) {
            items = [NSMutableArray array];
        }
        for (NSDictionary *type in cargood[@"types"]) {
            //解析成购物车商品模型
            YBLShopCarTempGoodModel *model = [[YBLShopCarTempGoodModel alloc] init];
            model.name = cargood[@"name"];
            model.shop = cargood[@"shop"];
            model.image = cargood[@"image"];
            model.expressMoney = [cargood[@"express"] integerValue];
            model.price = type[@"price"];
            model.gid = type[@"id"];
            model.desc = type[@"desc"];
            model.num = [type[@"num"] integerValue];
            model.isDelete = NO;
            if (carGoodArray != nil) {
                if (carGoodArray.count > 0) {
                    for (NSDictionary *oldCarDic in carGoodArray) {
                        for (YBLShopCarTempGoodModel *oldGood in oldCarDic[@"items"]) {
                            if ([oldGood.gid isEqualToString:model.gid]) {
                                model.isCheck = oldGood.isCheck;
                            }
                        }
                    }
                }
            }
            [items addObject:model];
        }
        [tempDic setObject:items forKey:shop];
        
        if (![shops containsObject:shop]) {
            [shops addObject:shop];
        }
    }
    for (NSString *shopName in shops) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *items = [tempDic objectForKey:shopName];
        [dic setObject:items forKey:@"items"];
        [dic setObject:shopName forKey:@"shop"];
        [array addObject:dic];
    }
    
    if (self.parseDataBlock) {
        self.parseDataBlock(array);
    }
}


//解析价格 是否全选
- (void)parseAllPriceAndIsSelectedAllWithGoodArray:(NSArray *)goodArray {
    BOOL isCheckAll = YES;
    if (goodArray == nil) {
        isCheckAll = NO;
    }
    if (goodArray.count == 0) {
        isCheckAll = NO;
    }
    CGFloat price = 0.0;
    NSInteger number = 0;
    NSInteger carNumber = 0;
    for (NSDictionary *goodDic in goodArray) {
        for (YBLShopCarTempGoodModel *good in goodDic[@"items"]) {
            carNumber += good.num;
            if (good.isCheck) {
                price += [[good.price substringFromIndex:2] doubleValue]*good.num;
                number += good.num;
            }else {
                isCheckAll = NO;
            }
        }
    }
    [YBLShopCarModel shareInstance].carNumber = carNumber;
    if (self.parsePriceBlock) {
        self.parsePriceBlock(price,20,isCheckAll,number);
    }
}

//解析编辑状态下 是否全选
- (void)parseDeleteAll:(NSArray *)goodArray block:(void(^)(BOOL isCheckAll))block {
    BOOL isCheckAll = YES;
    for (NSDictionary *goodDic in goodArray) {
        for (YBLShopCarTempGoodModel *good in goodDic[@"items"]) {
            if (good.isDelete == NO) {
                isCheckAll = NO;
                break;
            }
        }
    }
    if (block) {
        block(isCheckAll);
    }
}


//解析选中的商品 去下单
- (void)parseSelectedOrderGoodArray:(NSArray *)goodArray block:(void(^)(NSArray *orderGoodArray))block {
    NSMutableArray *orderGoodArray = [NSMutableArray array];
    
    for (NSDictionary *goodDic in goodArray) {
        for (YBLShopCarTempGoodModel *good in goodDic[@"items"]) {
            if (good.isCheck) {
                [orderGoodArray addObject:good];
            }
        }
    }
    
    if (block) {
        block(orderGoodArray);
    }
}



- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}


@end

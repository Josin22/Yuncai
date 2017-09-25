//
//  YBLShopCarModel.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLShopCarModel : NSObject

//添加的购物数量
@property (nonatomic, assign) NSInteger carNumber;

//购物车数据
@property (nonatomic, strong) NSMutableArray *carGoodArray;


//临时商品数据
@property (nonatomic, strong) NSArray *tempGoods;


+ (instancetype)shareInstance;



//添加商品到购物车
- (void)addGoodToCar:(id)good;



//减少商品到购物车
- (void)subtractGoodToCar:(id)good;




@end

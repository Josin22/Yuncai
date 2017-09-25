//
//  shop.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shop :YBLUserInfoModel

@property (nonatomic , copy  ) NSString              * shopid;
@property (nonatomic , copy  ) NSString              * contactphone;
@property (nonatomic , copy  ) NSString              * province;
@property (nonatomic , strong) NSNumber              * pdcount;
@property (nonatomic , strong) NSNumber              * credit_year;
@property (nonatomic , strong) NSNumber              * followed;
@property (nonatomic , copy  ) NSString              * share_url;
@property (nonatomic , copy  ) NSString              * banner_url;
@property (nonatomic , strong) NSNumber              * wallet_follow_quota;
@property (nonatomic , strong) NSNumber              * follow_shop_money;
@property (nonatomic , strong) NSMutableArray        * shop_products;

//购物车
///店铺选中状态
@property (nonatomic, assign) BOOL                shop_select;
///店铺商品价格
@property (nonatomic, strong) NSString            *shop_select_goods_price;
///店铺下商品数量
@property (nonatomic, strong) NSNumber            *shop_select_goods_count;
///店铺下商品种类
@property (nonatomic, strong) NSNumber            *shop_select_goods_zhong_count;

@end


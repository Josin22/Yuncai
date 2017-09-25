//
//  YBLShopCarTempGoodModel.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLShopCarTempGoodModel.h"

@implementation YBLShopCarTempGoodModel

- (instancetype)init {
    if (self = [super init]) {
        NSArray *array = @[@"您购买的厦门泰盛有限公司商品“满499元或66件免运费”总重24.55kg",@"您购买的厦门泰盛有限公司商品10件或0.1元包邮",@"您购买的厦门泰盛有限公司商品还差1件或差20元才能包邮哦！！"];
        self.express = array[arc4random()%3];
    }
    return self;
}

@end

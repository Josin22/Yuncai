//
//  YBLShopModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "shop.h"
#import "YBLGoodModel.h"

@interface YBLShopModel : NSObject

@property (nonatomic, strong) shop *shopinfo;

@property (nonatomic, strong) NSMutableArray *products;

@end

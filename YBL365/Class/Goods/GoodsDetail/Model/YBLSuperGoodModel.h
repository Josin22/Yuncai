//
//  YBLSuperGoodModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLGoodModel.h"
#import "YBLOrderCommentsItemModel.h"

@interface YBLSuperGoodModel : NSObject

@property (nonatomic, strong ) YBLGoodModel                  *product;
@property (nonatomic, strong ) NSNumber                      *followed;
@property (nonatomic, strong ) NSNumber                      *comments_total;
@property (nonatomic, strong ) NSMutableArray                *comments;
@property (nonatomic, strong ) NSMutableArray                *shipping_prices;
@property (nonatomic , strong) YBLCompanyTypePricesParaModel *prices;
@end

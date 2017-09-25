//
//  YBLGetProductShippPricesModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLExpressCompanyItemModel.h"

@interface area_prices : NSObject

@property (nonatomic, copy  ) NSString *area_id;

@property (nonatomic, copy  ) NSString *area_text;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, copy  ) NSString *expressCompanyName;

@end

@interface YBLGetProductShippPricesModel : NSObject

@property (nonatomic, copy  ) NSString                   *id;

@property (nonatomic, strong) NSMutableArray             *area_prices;

@property (nonatomic, strong) YBLExpressCompanyItemModel *express_company;

@end

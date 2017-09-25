//
//  YBLGoodModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodModel.h"
//#import <WCDB/WCDB.h>

@implementation YBLGoodModel

CoreArchiver_MODEL_M

+ (NSDictionary *)modelContainerPropertyGenericClass{
    
    return @{@"product_shipping_methods":[YBLShowPayShippingsmentModel class],
             @"product_payment_methods":[YBLShowPayShippingsmentModel class],
             @"company_type_prices":[YBLCompanyTypePricesParaModel class],
             @"shipping_prices":[YBLShippingPriceItemModel class]
             };
    
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return@{@"self_description" :@"description"};
}

- (void)handleAttPrice{
    
    NSString *priceString = [NSString stringWithFormat:@"%.2f",self.price.doubleValue];
    NSMutableAttributedString *attStr = [NSString price:priceString color:YBLThemeColor font:20];
    self.att_price = attStr;
}


//WCDB_IMPLEMENTATION(YBLGoodModel)
//WCDB_SYNTHESIZE(id)
//WCDB_SYNTHESIZE(avatar)
//WCDB_SYNTHESIZE(title)
//WCDB_SYNTHESIZE(price)
//
//WCDB_PRIMARY(YBLGoodModel,id)
//WCDB_INDEX(YBLGoodModel,)

@end

@implementation state

@end

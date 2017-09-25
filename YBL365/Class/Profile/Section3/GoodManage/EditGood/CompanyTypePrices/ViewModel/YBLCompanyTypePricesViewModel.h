//
//  YBLCompanyTypePricesViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCompanyTypePricesViewModel : NSObject
/**
 *  商品id
 */
@property (nonatomic, strong) NSString *product_id;
/**
 *  二级公司类型id
 */
@property (nonatomic, strong) NSString *companyType_id;

@property (nonatomic, strong) NSString *unitValue;

/**
 *  价格数据
 */
@property (nonatomic, strong) NSMutableArray *pricesDataArray;
/**
 *  已设置完数据
 */
@property (nonatomic, strong) NSMutableArray *company_type_prices;

- (RACSignal *)siganlForSettingCompanyTypePrices;

- (RACSignal *)siganlForTwoLeverlCompanyTypeData;
/**
 *  -1 
 */
- (void)resetMin:(NSInteger)min
       salePrice:(double)salePrice
fromIndexOfArray:(NSInteger)fromIndexOfArray
         section:(NSInteger)section
isAllButtonnAction:(BOOL)isAllButtonnAction
     isPureWrite:(BOOL)isPureWrite;

@end

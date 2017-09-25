//
//  YBLSalesDisplayPriceModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/29.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLAddressAreaModel.h"

@interface YBLSalesDisplayPriceModel : NSObject

/**
 *  销售显示区域
 */
@property (nonatomic , strong) NSNumber       * enable_sales_area;
@property (nonatomic , strong) NSNumber       * enable_display_price_area;
@property (nonatomic , strong) NSMutableArray * sales_area;
@property (nonatomic , strong) NSMutableArray * display_price_area;

@end

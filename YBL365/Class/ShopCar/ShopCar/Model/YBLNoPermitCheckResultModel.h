//
//  YBLNoPermitCheckResultModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface check_result_model : NSObject

@property (nonatomic, strong) NSNumber *inadequate_stock;
@property (nonatomic, strong) NSNumber *no_default_payment_method;
@property (nonatomic, strong) NSNumber *no_default_shipping_method;
@property (nonatomic, strong) NSNumber *no_sellable;
@property (nonatomic, strong) NSNumber *no_ship_address;
@property (nonatomic, strong) NSNumber *no_ship_prices;
@property (nonatomic, strong) NSNumber *off_store;

@end



@interface YBLNoPermitCheckResultModel : NSObject

@property (nonatomic, strong) check_result_model *check_result;

@property (nonatomic, strong) NSNumber *no_permit;

@end

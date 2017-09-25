//
//  YBLTakeOrderModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLOrderItemModel.h"
#import "YBLTakeOrderPaymentModel.h"

@interface YBLTakeOrderModel : NSObject

//@property (nonatomic, strong) NSArray *orders;

@property (nonatomic, strong) NSNumber *total;

@property (nonatomic, strong) NSArray *payments;

@end

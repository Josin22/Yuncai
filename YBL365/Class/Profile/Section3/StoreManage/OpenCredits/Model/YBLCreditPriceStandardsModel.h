//
//  YBLCreditPriceStandardsModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCreditPriceStandardsModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSNumber *discount;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *position;

@end

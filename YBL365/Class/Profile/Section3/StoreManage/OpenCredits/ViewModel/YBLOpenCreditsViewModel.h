//
//  YBLOpenCreditsViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YBLOpenCreditsViewModel : NSObject

@property (nonatomic, strong) NSArray *credit_price_standards_array;

///信用通
@property (nonatomic, strong) RACSignal *creditPriceStandardsSignal;


@end

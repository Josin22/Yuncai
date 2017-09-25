//
//  YBLCreditOrderModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCreditOrderModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *begin_date;
@property (nonatomic, strong) NSString *end_date;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSNumber *pay_mode;
@property (nonatomic, strong) id pay_url;

@end

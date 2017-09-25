//
//  YBLGoodDetailCouponsModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLGoodDetailCouponsModel : NSObject

@property (nonatomic, copy  ) NSString *id;

@property (nonatomic, copy  ) NSString *start_time;

@property (nonatomic, copy  ) NSString *end_time;

@property (nonatomic, copy  ) NSString *state;

@property (nonatomic, strong) NSNumber *total;

@property (nonatomic, strong) NSNumber *quantity;

@property (nonatomic, strong) NSNumber *condition;

@property (nonatomic, strong) NSNumber *value;

@property (nonatomic, strong) NSNumber *binded;

@end

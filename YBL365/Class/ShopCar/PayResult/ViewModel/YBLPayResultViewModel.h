//
//  YBLPayResultViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  YBLPayResultModel : NSObject

@property (nonatomic, strong) NSString *payWay;

@property (nonatomic, strong) NSNumber *payMoney;

@property (nonatomic, strong) NSString *pay_id;

@property (nonatomic, assign) TakeOrderType takeOrderType;

@end

@interface YBLPayResultViewModel : NSObject

@property (nonatomic, strong) YBLPayResultModel *payResultModel;

@end

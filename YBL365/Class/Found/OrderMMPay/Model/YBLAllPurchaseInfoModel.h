//
//  YBLAllPurchaseInfoModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLpurchaseInfosModel.h"

@interface YBLAllPurchaseInfoModel : NSObject

@property (nonatomic, strong) NSMutableArray *paytypes;

@property (nonatomic, strong) NSMutableArray *distributions;
/*old*/
/**
 *  @[@[{},{}],@[{},{}]]
 */
@property (nonatomic, strong) NSMutableArray *filter_distributions;
@property (nonatomic, strong) YBLPurchaseInfosModel *sameCityModel;
/*new*/
/**
 *  @[@{},@{},@{}]
 */
@property (nonatomic, strong) NSMutableArray *filter_infos_data_array;

@end

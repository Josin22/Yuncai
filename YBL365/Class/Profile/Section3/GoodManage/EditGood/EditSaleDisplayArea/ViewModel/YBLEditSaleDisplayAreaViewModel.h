//
//  YBLEditSaleDisplayAreaViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLSalesDisplayPriceModel.h"

@interface YBLEditSaleDisplayAreaViewModel : NSObject

@property (nonatomic, copy  ) NSString *_id;

@property (nonatomic, strong) NSMutableDictionary *getSalesPriceDict;
@property (nonatomic, strong) NSMutableDictionary *getDisplayPriceDict;

@property (nonatomic, strong) YBLSalesDisplayPriceModel *getSaleDisplayPriceModel;

- (RACSignal *)siganlForSaveSaleArea;

- (RACSignal *)siganlForSaveDisplayPriceArea;

- (RACSignal *)siganlForGetAreaInfo;

- (RACSignal *)siganlForSalesAreaStatus:(BOOL)isOn;

- (RACSignal *)siganlForDisplayPriceAreaStatus:(BOOL)isOn;

+ (RACSignal *)siganlForGetAreaInfoWithID:(NSString *)_id;

@end

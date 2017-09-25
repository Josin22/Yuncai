//
//  YBLMyPurchaseViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLBaseFoundViewModel.h"

@interface YBLMyPurchaseViewModel : YBLBaseFoundViewModel
//------------------------------------个人

- (RACSignal *)siganlForPersonPurchaseOrderIsReload:(BOOL)isReload;

@property (nonatomic, strong) NSArray *segTitleDataArray;

@property (nonatomic, copy  ) NSString *seg1Value;

@property (nonatomic, copy  ) NSString *seg2Value;

- (NSArray *)getCurrentTitleWithIndex:(NSInteger)index;

- (void)handleSegValueWithIndex:(NSInteger)index selectIndex:(NSInteger)selectIndex;

@end

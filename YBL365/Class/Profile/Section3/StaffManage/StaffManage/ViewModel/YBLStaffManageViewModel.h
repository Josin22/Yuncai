//
//  YBLStaffManageViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLStaffManageModel.h"

@interface YBLStaffManageViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *staffDataArray;

- (RACSignal *)straffManageSignal;

+ (RACSignal *)signalForDeleteStaffWithid:(NSString *)_id;

- (RACSignal *)signalForDeleteStaffWithid:(NSString *)_id;

+ (RACSignal *)signalForUpdateStaffWithID:(NSString *)_id rolse:(NSString *)rolse salesMan:(NSDictionary *)salesMan;

@end

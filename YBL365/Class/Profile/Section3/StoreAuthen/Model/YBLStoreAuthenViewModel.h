//
//  YBLStoreAuthenViewModel.h
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLStoreAuthenViewModel : NSObject

+ (RACSignal *)signalForCompanyTypesWith:(NSString *)types;

@end

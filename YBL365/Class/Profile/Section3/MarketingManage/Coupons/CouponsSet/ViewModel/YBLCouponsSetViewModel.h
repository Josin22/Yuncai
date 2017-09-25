//
//  YBLCouponsSetViewModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCouponsSetViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *cellDataArray;

- (RACSignal *)siganlForSaveCoupons;

@end

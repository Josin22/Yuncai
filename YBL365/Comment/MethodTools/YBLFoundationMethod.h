//
//  YBLFoundationMethod.h
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FoundationMethodAddressBookBlock)(NSString *name,NSString *phone);

@interface YBLFoundationMethod : NSObject

+ (instancetype)shareInstance;

- (void)showAddressBookWithVc:(UIViewController *)Vc handleSelectBlock:(FoundationMethodAddressBookBlock)block;

@end

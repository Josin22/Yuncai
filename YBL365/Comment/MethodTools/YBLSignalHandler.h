//
//  YBLSignalHandler.h
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/signal.h>

@interface YBLSignalHandler : NSObject

//注册捕获信号的方法
+ (void)RegisterSignalHandler;

@end

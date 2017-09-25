//
//  YBLSingletonMethodTools.h
//  YC168
//
//  Created by 乔同新 on 2017/6/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLSingletonMethodTools : NSObject

+ (YBLSingletonMethodTools *)shareMethodTools;

@property (nonatomic, strong) NSDateFormatter *cachedDateFormatter;

@end

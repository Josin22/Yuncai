//
//  YBLSingletonMethodTools.m
//  YC168
//
//  Created by 乔同新 on 2017/6/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSingletonMethodTools.h"

static YBLSingletonMethodTools *singletonMethodTools = nil;

@implementation YBLSingletonMethodTools

+ (YBLSingletonMethodTools *)shareMethodTools{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonMethodTools = [YBLSingletonMethodTools new];
    });
    return singletonMethodTools;
}

- (NSDateFormatter *)cachedDateFormatter{
    
    // If the date formatters aren't already set up, create them and cache them for reuse.
    if (!_cachedDateFormatter) {
        _cachedDateFormatter = [[NSDateFormatter alloc] init];
        [_cachedDateFormatter setLocale:[NSLocale currentLocale]];
        [_cachedDateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    }
    return _cachedDateFormatter;
    
}

@end

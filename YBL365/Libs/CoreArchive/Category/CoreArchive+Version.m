//
//  CoreArchive+Version.m
//  CoreArchive
//
//  Created by 冯成林 on 15/7/7.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreArchive+Version.h"

static NSString *NewFeatureVersionKey = @"NewFeatureVersionKey";

@implementation CoreArchive (Version)

/** 保存当前版本信息 */
+(void)saveCurrentVersionInfo{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[self currentVersion];
    
    //保存
    [CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
}




/** 本地是否已经保存过当前版本信息 */
+(BOOL)isSavedCurrentVersionInfo{
    
    //本地版本号：归档
    NSString *versionLocal = [CoreArchive strForKey:NewFeatureVersionKey];
    
    //当前版本号:获取
    NSString *versionCurrent = [self currentVersion];
    
    return (versionLocal!=nil && [versionCurrent isEqualToString:versionLocal]);
}


/*
 *  当前程序的版本号
 */
+(NSString *)currentVersion{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    return versionValueStringForSystemNow;
}




@end

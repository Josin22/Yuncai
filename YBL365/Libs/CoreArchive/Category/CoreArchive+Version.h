//
//  CoreArchive+Version.h
//  CoreArchive
//
//  Created by 冯成林 on 15/7/7.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreArchive.h"

@interface CoreArchive (Version)


/** 保存当前版本信息 */
+(void)saveCurrentVersionInfo;


/** 本地是否已经保存过当前版本信息 */
+(BOOL)isSavedCurrentVersionInfo;


/** 当前程序的版本号：系统版本号，非归档本地版本号 */
+(NSString *)currentVersion;


@end

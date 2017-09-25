//
//  CoreArchiveHeader.h
//  CoreArchive
//
//  Created by 成林 on 15/6/19.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#ifndef CoreArchive_CoreArchiveHeader_h
#define CoreArchive_CoreArchiveHeader_h

/** 自动存储宏定义 */
#define CoreArchiver_SingCACHE_PATH(name) [[NSString cachesFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.arc",name]]

#define CoreArchiver_ArrayCACHE_PATH(name) [[NSString cachesFolder] stringByAppendingPathComponent:[NSString stringWithFormat:@"Array%@.arc",name]]

#define CoreArchiver_MODEL_H \
+(BOOL)saveSingleModel:(id)model forKey:(NSString *)key;\
+(instancetype)readSingleModelForKey:(NSString *)key;\
+(BOOL)saveListModel:(NSArray *)ListModel forKey:(NSString *)key;\
+(NSArray *)readListModelForKey:(NSString *)key;\


#define CoreArchiver_MODEL_M \
MJCodingImplementation\
+(BOOL)saveSingleModel:(id)model forKey:(NSString *)key{\
NSString *pathKey = key==nil?NSStringFromClass(self):key;\
return [CoreArchive archiveRootObject:model toFile:CoreArchiver_SingCACHE_PATH(pathKey)];\
}\
+(instancetype)readSingleModelForKey:(NSString *)key{\
NSString *pathKey = key==nil?NSStringFromClass(self):key;\
return [CoreArchive unarchiveObjectWithFile:CoreArchiver_SingCACHE_PATH(pathKey)];\
}\
+(BOOL)saveListModel:(NSArray *)ListModel forKey:(NSString *)key{\
NSString *pathKey = key==nil?NSStringFromClass(self):key;\
return [CoreArchive archiveRootObject:ListModel toFile:CoreArchiver_ArrayCACHE_PATH(pathKey)];\
}\
+(NSArray *)readListModelForKey:(NSString *)key{\
NSString *pathKey = key==nil?NSStringFromClass(self):key;\
return [CoreArchive unarchiveObjectWithFile:CoreArchiver_ArrayCACHE_PATH(pathKey)];\
}\


#endif

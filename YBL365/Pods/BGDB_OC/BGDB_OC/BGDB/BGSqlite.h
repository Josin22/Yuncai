//
//  BGSqlite.h
//  BGDB_OC
//
//  Created by huangzhibiao on 17/3/25.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTool.h"
#import "BGSqliteConfig.h"

@interface BGSqlite : NSObject
@property(nonatomic,assign)BOOL debug;
+(instancetype)shareInstance;
/**
 获取某个类的数据条数.
 */
+(NSInteger)count:(Class)model_class where:(NSString*)where;
/**
 直接调用sqliteb的原生函数计算sun,min,max,avg等.
 */
+(NSInteger)sqliteMethodWithClass:(Class)model_class type:(bg_sqliteMethodType)methodType key:(NSString*)key where:(NSString*)where;
/**
 插入对象.
 @object 对象
 */
+(BOOL)insert:(id)object;
/**
 忽略某些key值不做插入.
 @object 对象
 @ignoredKeys 存放忽略key值的数组.
 */
+(BOOL)insert:(id)object ignoredKeys:(NSArray* const)ignoredKeys;
+(BOOL)insertOrUpdate:(id)object;
+(BOOL)insertOrUpdate:(id)object ignoredKeys:(NSArray* const)ignoredKeys;
/**
 批量插入.
 @array 存放对象的数组.
 */
+(BOOL)inserts:(NSArray* const)array;
/**
 批量插入.
 @array 存放对象的数组.
 @ignoredKeys 存放忽略key值的数组.
 */
+(BOOL)inserts:(NSArray* const)array ignoredKeys:(NSArray* const)ignoredKeys;
/**
 查询类数据.
 @model_class 要查询的类
 */
+(NSArray*)queryWithClass:(Class)model_class where:(NSString*)where;
/**
 对象数据更新.
 */
+(BOOL)updateObj:(id)object where:(NSString*)where;
/**
 对象(可以忽略某些属性)数据更新.
 */
+(BOOL)updateObj:(id)object ignoredKeys:(NSArray* const)ignoredKeys where:(NSString*)where;
/**
 类数据更新.
 */
+(BOOL)updateSet:(Class)model_class sql:(NSString*)sql;
/**
 删除数据.
 */
+(BOOL)deleteWithClass:(Class)model_class where:(NSString*)where;
/**
 删除类对应的数据库.
 */
+(BOOL)dropWithClass:(Class)model_class;
/**
 刷新数据库版本.
 */
+(void)refresh:(Class)cla ignoredKeys:(NSArray*)ignoredKeys;
@end

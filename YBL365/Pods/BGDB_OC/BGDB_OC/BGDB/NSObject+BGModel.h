//
//  NSObject+BGModel.h
//  BGDB_OC
//
//  Created by huangzhibiao on 17/3/25.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGSqliteConfig.h"

@protocol BGProtocol <NSObject>
//可选择操作
@optional
/**
 自定义 “唯一约束” 函数,如果需要 “唯一约束”字段,则在自定类中自己实现该函数.
 @return 返回值是 “唯一约束” 的字段名(即相对应的变量名).
 */
+(NSArray*)bg_uniqueKeys;
/**
 数组中需要转换的模型类
 @return 字典中的key是数组属性名，value是数组中存放模型的Class
 */
+(NSDictionary*)bg_objectClassInArray;
/**
 如果模型中有自定义类变量,则实现该函数对应进行集合到模型的转换.
 字典转模型用.
 */
+(NSDictionary*)bg_objectClassForCustom;
/**
 将模型中对应的自定义类变量转换为字典.
 模型转字典用.
 */
+(NSDictionary*)bg_dictForCustomClass;
@end

@interface NSObject (BGModel)<BGProtocol>
@property(nonatomic,strong)NSNumber* ID;//本库自带的自动增长主键.
/**
 为了方便开发者，特此加入以下两个字段属性供开发者做参考.(自动记录数据的存入时间和更新时间)
 @createTime 数据创建时间(即存入数据库的时间).
 @updateTime 数据最后那次更新的时间.
 */
//@property(nonatomic,copy)NSString* _Nonnull createTime;
//@property(nonatomic,copy)NSString* _Nonnull updateTime;
#pragma mark 以下是使用API
/**
 设置调试模式
 @debug YES:打印调试信息, NO:不打印调试信息.
 */
extern void bg_setDebug(BOOL debug);
/**
 存储.
 */
-(BOOL)bg_save;
/**
 存储.
 @ignoredkeys 忽略某些属性不要存.
 */
-(BOOL)bg_saveIgnoredkeys:(NSArray* const)ignorekeys;
/**
 存储.
 当有'唯一约束'时使用此API存储会更方便些,此API会自动判断如果同一约束数据已存在则更新,没有则存储.
 */
-(BOOL)bg_saveOrUpdate;
/**
 存储.
 当有'唯一约束'时使用此API存储会更方便些,此API会自动判断如果同一约束数据已存在则更新,没有则存储.
 @ignoredkeys 忽略某些属性不要存.
 */
-(BOOL)bg_saveOrUpdate:(NSArray* const)ignorekeys;
/**
 批量存储.
 */
+(BOOL)bg_saveArray:(NSArray* const)array;
/**
 批量存储.
 @ignoredkeys 忽略某些属性不要存.
 */
+(BOOL)bg_saveArray:(NSArray* const)array ignoredkeys:(NSArray* const)ignorekeys;
/**
 查询全部.
 */
+(NSArray*)bg_findAll;
/**
 条件查询.
 */
+(NSArray*)bg_findWhere:(NSString*)where;
/**
 更新.
 */
-(BOOL)bg_updateWhere:(NSString*)where;
/**
 忽略某些属性不要更新.
 @ignoredkeys 忽略某些属性不要更新.
 */
-(BOOL)bg_updateWhere:(NSString*)where ignoredkeys:(NSArray* const)ignoredkeys;
/**
 批量更新.
 */
+(BOOL)bg_updateSet:(NSString*)setSql;
/**
 根据条件删除数据.
 @where 删除条件语句,nil时删除全部.
 */
+(BOOL)bg_deleteWhere:(NSString*)where;
/**
 删除数据库.
 */
+(BOOL)bg_drop;
/**
 查询该类中有多少条数据
 */
+(NSInteger)bg_countWhere:(NSString*)where;
/**
 直接调用sqliteb的原生函数计算sun,min,max,avg等.
 */
+(NSInteger)bg_sqliteMethodWithType:(bg_sqliteMethodType)methodType key:(NSString*)key where:(NSString*)where;
/**
 获取数据库版本号.
 为了防止发生函数名冲突,所以加上bg_前缀.
 */
+(NSInteger)bg_version;
/**
 更新数据库.
 当'唯一约束'发生改变时,调用此API进行数据库更新升级.
 注：本次更新的版本号要大于现有的版本号,否则不做升级.
 */
+(void)bg_updateVersion:(NSInteger)version;

#pragma mark 下面附加字典转模型API,简单好用,在只需要字典转模型功能的情况下,可以不必要再引入MJExtension那么多文件,造成代码冗余,缩减安装包.
/**
 字典转模型.
 @keyValues 字典(NSDictionary)或json格式字符.
 说明:如果模型中有数组且存放的是自定义的类(NSString等系统自带的类型就不必要了),那就实现objectClassInArray这个函数返回一个字典,key是数组名称,value是自定的类Class,用法跟MJExtension一样.
 */
+(id)bg_objectWithKeyValues:(id)keyValues;
+(id)bg_objectWithDictionary:(NSDictionary*)dictionary;
/**
 模型转字典.
 @ignoredKeys 忽略掉模型中的哪些key(即模型变量)不要转,nil时全部转成字典.
 */
-(NSMutableDictionary*)bg_keyValuesIgnoredKeys:(NSArray*)ignoredKeys;
@end

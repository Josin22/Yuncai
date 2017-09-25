//
//  NSObject+BGModel.m
//  BGDB_OC
//
//  Created by huangzhibiao on 17/3/25.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import "NSObject+BGModel.h"
#import <objc/message.h>
#import "BGSqlite.h"


@implementation NSObject (BGModel)

//分类中只生成属性get,set函数的声明,没有声称其实现,所以要自己实现get,set函数.
-(NSNumber*)ID{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setID:(NSNumber*)ID{
    objc_setAssociatedObject(self,@selector(ID),ID,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//-(NSString *)createTime{
//    return objc_getAssociatedObject(self, _cmd);
//}
//-(void)setCreateTime:(NSString *)createTime{
//    objc_setAssociatedObject(self,@selector(createTime),createTime,OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//-(NSString *)updateTime{
//    return objc_getAssociatedObject(self, _cmd);
//}
//-(void)setUpdateTime:(NSString *)updateTime{
//    objc_setAssociatedObject(self,@selector(updateTime),updateTime,OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
#pragma mark 以下是使用API实现.

/**
 设置调试模式
 @debug YES:打印调试信息, NO:不打印调试信息.
 */
void bg_setDebug(BOOL debug){
    if ([BGSqlite shareInstance].debug != debug){//防止重复设置.
        [BGSqlite shareInstance].debug = debug;
    }
}


/**
 存储.
 */
-(BOOL)bg_save{
    return [BGSqlite insert:self];
}
/**
 存储.
 @ignoredkeys 忽略某些属性不要存.
 */
-(BOOL)bg_saveIgnoredkeys:(NSArray* const)ignorekeys{
    return [BGSqlite insert:self ignoredKeys:ignorekeys];
}
/**
 存储.
 当有'唯一约束'时使用此API存储会更方便些,此API会自动判断如果同一约束数据已存在则更新,没有则存储.
 */
-(BOOL)bg_saveOrUpdate{
    return [BGSqlite insertOrUpdate:self];
}
/**
 存储.
 当有'唯一约束'时使用此API存储会更方便些,此API会自动判断如果数据存在则更新,没有则存储.
 @ignoredkeys 忽略某些属性不要存.
 */
-(BOOL)bg_saveOrUpdate:(NSArray* const)ignorekeys{
    return [BGSqlite insertOrUpdate:self ignoredKeys:ignorekeys];
}
/**
 批量存储.
 */
+(BOOL)bg_saveArray:(NSArray* const)array{
    return [BGSqlite inserts:array];
}
/**
 批量存储.
 @ignoredkeys 忽略某些属性不要存.
 */
+(BOOL)bg_saveArray:(NSArray* const)array ignoredkeys:(NSArray* const)ignorekeys{
    return [BGSqlite inserts:array ignoredKeys:ignorekeys];
}
/**
 查询全部.
 */
+(NSArray*)bg_findAll{
    return [BGSqlite queryWithClass:[self class] where:nil];
}
/**
 条件查询.
 */
+(NSArray*)bg_findWhere:(NSString*)where{
    return [BGSqlite queryWithClass:[self class] where:where];
}
/**
 更新.
 */
-(BOOL)bg_updateWhere:(NSString*)where{
    return [BGSqlite updateObj:self where:where];
}
/**
 忽略某些属性不要更新.
 @ignoredkeys 忽略某些属性不要更新.
 */
-(BOOL)bg_updateWhere:(NSString*)where ignoredkeys:(NSArray* const)ignoredkeys{
    return [BGSqlite updateObj:self ignoredKeys:ignoredkeys where:where];
}
/**
 更新.
 */
+(BOOL)bg_updateSet:(NSString*)setSql{
    return [BGSqlite updateSet:[self class] sql:setSql];
}
/**
 根据条件删除数据.
 @where 删除条件语句,nil时删除全部.
 */
+(BOOL)bg_deleteWhere:(NSString*)where{
    return [BGSqlite deleteWithClass:[self class] where:where];
}
/**
 删除数据库.
 */
+(BOOL)bg_drop{
    return [BGSqlite dropWithClass:[self class]];
}
/**
 查询该类中有多少条数据
 */
+(NSInteger)bg_countWhere:(NSString*)where{
    return [BGSqlite count:[self class] where:where];
}
/**
 直接调用sqliteb的原生函数计算sun,min,max,avg等.
 */
+(NSInteger)bg_sqliteMethodWithType:(bg_sqliteMethodType)methodType key:(NSString*)key where:(NSString*)where{
    return [BGSqlite sqliteMethodWithClass:[self class] type:methodType key:key where:where];
}
/**
 获取数据库版本号.
 为了防止发生函数名冲突,所以加上bg_前缀.
 */
+(NSInteger)bg_version{
    NSString* tableName = [BGTool getTableNameWithCalss:[self class]];
    return [BGTool getIntegerWithKey:tableName];
}

/**
 更新数据库.
 当'唯一约束'发生改变时,调用此API进行数据库更新升级.
 注：本次更新的版本号要大于现有的版本号,否则不做升级.
 */
+(void)bg_updateVersion:(NSInteger)version{
    if (version > [self bg_version]) {
        NSString* tableName = [BGTool getTableNameWithCalss:[self class]];
        [BGTool setIntegerWithKey:tableName value:version];
        [BGSqlite refresh:[self class] ignoredKeys:nil];
    }
}

#pragma mark 下面附加字典转模型API,简单好用,在只需要字典转模型功能的情况下,可以不必要再引入MJExtension那么多文件,造成代码冗余,缩减安装包.
/**
 字典转模型.
 @keyValues 字典(NSDictionary)或json格式字符.
 说明:如果模型中有数组且存放的是自定义的类(NSString等系统自带的类型就不必要了),那就实现objectClassInArray这个函数返回一个字典,key是数组名称,value是自定的类Class,用法跟MJExtension一样.
 */
+(id)bg_objectWithKeyValues:(id)keyValues{
    return [BGTool bg_objectWithClass:[self class] value:keyValues];
}
+(id)bg_objectWithDictionary:(NSDictionary *)dictionary{
    return [BGTool bg_objectWithClass:[self class] value:dictionary];
}
/**
 模型转字典.
 @ignoredKeys 忽略掉模型中的哪些key(即模型变量)不要转,nil时全部转成字典.
 */
-(NSMutableDictionary*)bg_keyValuesIgnoredKeys:(NSArray*)ignoredKeys{
    return [BGTool bg_keyValuesWithObject:self ignoredKeys:ignoredKeys];
}
@end

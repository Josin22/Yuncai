//
//  BGSqlite.m
//  BGDB_OC
//
//  Created by huangzhibiao on 17/3/25.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import "BGSqlite.h"
#import <sqlite3.h>

/**
 日志输出.
 */
#ifdef DEBUG
#define BGLog(...) NSLog(__VA_ARGS__)
#else
#define BGLog(...)
#endif

/**
 debug打印.
 */
#define BGDebug(param) \
if([BGSqlite shareInstance].debug){\
BGLog(@"调试输出: %@",param);\
}

/**
 开始事务.
 */

#define Begin_Transcation \
if(![BGSqlite shareInstance].inTransaction){\
[BGSqlite shareInstance].inTransaction = [self execSql:@"begin transaction"];\
}

/**
 提交事务.
 */
#define Commit_Transcation \
if([BGSqlite shareInstance].inTransaction){\
[self execSql:@"commit transaction"];\
[BGSqlite shareInstance].inTransaction = NO;\
}
/**
 回滚事务.
 */
#define Rollback_Transcation \
if([BGSqlite shareInstance].inTransaction){\
[self execSql:@"rollback transaction"];\
[BGSqlite shareInstance].inTransaction=NO;\
}


typedef int(^BGDBExecuteStatementsCallbackBlock)(NSDictionary *resultsDictionary);

@interface BGSqlite()

@property (nonatomic, strong) dispatch_semaphore_t BG_Semaphore;
@property (nonatomic, assign) BOOL inTransaction;//事务标志

@end

static sqlite3* BG_Database;
@implementation BGSqlite

-(instancetype)init{
    self = [super init];
    if (self) {
        _BG_Semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

+(instancetype)shareInstance{
    static BGSqlite* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BGSqlite new];
    });
    return instance;
}

+ (void)close {
    if (![BGSqlite shareInstance].inTransaction && BG_Database) {
        sqlite3_close(BG_Database);
        BG_Database = nil;
    }
}
/**
 获取数据库的存放目录.
 */
+ (NSString *)BGSqliteCacheDirectory {
    return [NSString stringWithFormat:@"%@/Library/Caches/BGSqlite/",NSHomeDirectory()];
}

/**
 执行数据库语句.
 */
+ (BOOL)execSql:(NSString *)sql {
    BGDebug(sql)//打印sql语句.
    char *errmsg = nil;
    BOOL result = sqlite3_exec(BG_Database, [sql UTF8String], nil, nil, &errmsg) == SQLITE_OK;
    if (!result) {
        if (errmsg) {
            NSString* sqlError = [NSString stringWithFormat:@"SQL语句执行错误: %s", errmsg];
            BGDebug(sqlError)//打印错误信息.
            sqlite3_free(errmsg);
        }
    }
    return result;
}
/**
 建表函数.
 */
+ (BOOL)createTable:(Class)model_class{
    NSString* tableName = [BGTool getTableNameWithCalss:model_class];
    NSArray<BGPropertyInfo*>* properInfos = [BGTool getClassIvarList:model_class];
    NSMutableString * tempSql = [NSMutableString stringWithFormat:@"create table if not exists %@(",tableName];
    [properInfos enumerateObjectsUsingBlock:^(BGPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempSql appendFormat:@"%@ %@,",obj.sqlColumnName,obj.sqlColumnType];
    }];
    NSString* createTableSql = [NSString stringWithFormat:@"%@);",[tempSql substringToIndex:tempSql.length-1]];//去掉最后那个逗号.
    return [self execSql:createTableSql];
}

+(BOOL)createTable:(Class)model_class ignoredKeys:(NSArray*)ignoredKeys{
    NSString* tableName = [BGTool getTableNameWithCalss:model_class];
    NSArray<BGPropertyInfo*>* properInfos = [BGTool getClassIvarList:model_class];
    NSMutableArray* newIgnoredKeys = [NSMutableArray arrayWithArray:ignoredKeys];
    NSMutableArray<BGPropertyInfo*>* newProperInfos = [NSMutableArray array];
    
    for(int i=0;i<properInfos.count;i++){
        NSString* key = properInfos[i].sqlColumnName;
        if ([key containsString:BG_PropertySeparator]) {
            key = [key stringByReplacingOccurrencesOfString:BG_PropertySeparator withString:@"."];
        }
        if (![newIgnoredKeys containsObject:key]) {
            [newProperInfos addObject:properInfos[i]];
            continue;
        }
        [newIgnoredKeys removeObject:key];
    }
    if (newIgnoredKeys.count) {
        [self deleteSqliteWithClass:model_class];//失败后先删除数据库文件.
        NSAssert(NO,@"有key名称错误,请检查ignoredKeys数组里的key值是否正确!");
    }
    NSMutableString * tempSql = [NSMutableString stringWithFormat:@"create table if not exists %@(",tableName];
    [newProperInfos enumerateObjectsUsingBlock:^(BGPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempSql appendFormat:@"%@ %@,",obj.sqlColumnName,obj.sqlColumnType];
    }];
    NSString* createTableSql = [NSString stringWithFormat:@"%@);",[tempSql substringToIndex:tempSql.length-1]];//去掉最后那个逗号.
    return [self execSql:createTableSql];
}

+(BOOL)isExistSqliteWithClass:(Class)model_class{
    NSString* tableName = [BGTool getTableNameWithCalss:model_class];
    NSString* CacheDir = [self BGSqliteCacheDirectory];
    NSInteger version = [BGTool getIntegerWithKey:tableName];
    NSString* path = [NSString stringWithFormat:@"%@%@_v%@.sqlite",CacheDir,tableName,@(version)];
    NSFileManager * file_manager = [NSFileManager defaultManager];
    if ([file_manager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

+(BOOL)deleteSqliteWithClass:(Class)model_class{
    NSString* tableName = [BGTool getTableNameWithCalss:model_class];
    NSString* CacheDir = [self BGSqliteCacheDirectory];
    NSInteger version = [BGTool getIntegerWithKey:tableName];
    NSString* path = [NSString stringWithFormat:@"%@%@_v%@.sqlite",CacheDir,tableName,@(version)];
    NSFileManager * file_manager = [NSFileManager defaultManager];
    NSError* error;
    if ([file_manager fileExistsAtPath:path]) {
        [file_manager removeItemAtPath:path error:&error];
    }
    return error==nil;
}

+(NSString*)getSqlitePathWithClass:(Class)model_class{
    NSString* tableName = [BGTool getTableNameWithCalss:model_class];
    NSString* CacheDir = [self BGSqliteCacheDirectory];
    NSFileManager * file_manager = [NSFileManager defaultManager];
    BOOL is_directory = YES;
    if (![file_manager fileExistsAtPath:CacheDir isDirectory:&is_directory]) {
        [file_manager createDirectoryAtPath:CacheDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSInteger version = [BGTool getIntegerWithKey:tableName];
    return [NSString stringWithFormat:@"%@%@_v%@.sqlite",CacheDir,tableName,@(version)];
    
}
int BGDBExecuteBulkSQLCallback(void *theBlockAsVoid, int columns, char **values, char **names);
int BGDBExecuteBulkSQLCallback(void *theBlockAsVoid, int columns, char **values, char **names) {
    
    if (!theBlockAsVoid) {
        return SQLITE_OK;
    }
    
    int (^execCallbackBlock)(NSDictionary *resultsDictionary) = (__bridge int (^)(NSDictionary *__strong))(theBlockAsVoid);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:(NSUInteger)columns];
    
    for (NSInteger i = 0; i < columns; i++) {
        NSString *key = [NSString stringWithUTF8String:names[i]];
        id value = values[i] ? [NSString stringWithUTF8String:values[i]] : [NSNull null];
        [dictionary setObject:value forKey:key];
    }
    
    return execCallbackBlock(dictionary);
}


+(NSInteger)count:(Class)model_class where:(NSString*)where{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    __block NSInteger count = -1;
    @autoreleasepool {
    if (![self isExistSqliteWithClass:model_class])return count;
    
    NSString* database_cache_path = [self getSqlitePathWithClass:model_class];
    if (sqlite3_open([database_cache_path UTF8String], &BG_Database) != SQLITE_OK)return count;
    BGDBExecuteStatementsCallbackBlock block = ^(NSDictionary* info){
        count = [[info.allValues lastObject] integerValue];
        return 0;
    };
    NSString* SQL = [NSString stringWithFormat:@"select count(*) from %@",NSStringFromClass(model_class)];
    if (where) {
        SQL = [SQL stringByAppendingFormat:@" %@",where];
    }
    char *errmsg = nil;
    BGDebug(SQL)
    sqlite3_exec(BG_Database, [SQL UTF8String], block ? BGDBExecuteBulkSQLCallback : nil, (__bridge void *)(block), &errmsg);
    if (errmsg) {
        NSString* sqlError = [NSString stringWithFormat:@"执行SQL语句错误: %s", errmsg];
        BGDebug(sqlError)
        sqlite3_free(errmsg);
    }
    [self close];
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return count;
}

+(NSInteger)sqliteMethodWithClass:(Class)model_class type:(bg_sqliteMethodType)methodType key:(NSString*)key where:(NSString*)where{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    __block NSInteger num = -1;
    @autoreleasepool {
        if (![self isExistSqliteWithClass:model_class])return num;
        
        NSString* database_cache_path = [self getSqlitePathWithClass:model_class];
        if (sqlite3_open([database_cache_path UTF8String], &BG_Database) != SQLITE_OK)return num;
        BGDBExecuteStatementsCallbackBlock block = ^(NSDictionary* info){
            id dbResult = [info.allValues lastObject];
            if(dbResult && ![dbResult isKindOfClass:[NSNull class]]) {
                num = [dbResult integerValue];
            }else{
                num = 0;
            }
            return 0;
        };
        if([key containsString:@"."]) {
            key = [key stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
        }
        NSString* method;
        switch (methodType) {
            case bg_min:
                method = [NSString stringWithFormat:@"min(%@%@)",BG,key];
                break;
            case bg_max:
                method = [NSString stringWithFormat:@"max(%@%@)",BG,key];
                break;
            case bg_sum:
                method = [NSString stringWithFormat:@"sum(%@%@)",BG,key];
                break;
            case bg_avg:
                method = [NSString stringWithFormat:@"avg(%@%@)",BG,key];
                break;
            default:
                NSAssert(NO,@"请传入方法类型!");
                break;
        }
        if ([where containsString:@"."]) {
            where = [where stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
        }
        NSString* SQL;
        if(where){
            SQL = [NSString stringWithFormat:@"select %@ from %@ %@",method,NSStringFromClass(model_class),where];
        }else{
            SQL = [NSString stringWithFormat:@"select %@ from %@",method,NSStringFromClass(model_class)];
        }
        char *errmsg = nil;
        BGDebug(SQL)
        sqlite3_exec(BG_Database, [SQL UTF8String], block ? BGDBExecuteBulkSQLCallback : nil, (__bridge void *)(block), &errmsg);
        if (errmsg) {
            NSString* sqlError = [NSString stringWithFormat:@"执行SQL语句错误: %s", errmsg];
            BGDebug(sqlError)
            sqlite3_free(errmsg);
        }
        [self close];
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return num;

}

+(BOOL)openTable:(Class)model_class{
    NSString* database_cache_path = [self getSqlitePathWithClass:model_class];
    return  sqlite3_open([database_cache_path UTF8String], &BG_Database) == SQLITE_OK;
}

/**
 打开数据库表格.
 */
+(BOOL)createTableifNotExist:(Class)model_class{
    NSString* database_cache_path = [self getSqlitePathWithClass:model_class];
    //NSLog(@"path = %@",database_cache_path);
    if([self isExistSqliteWithClass:model_class]){
        return sqlite3_open([database_cache_path UTF8String], &BG_Database) == SQLITE_OK;
    }else{
        if(sqlite3_open([database_cache_path UTF8String], &BG_Database) == SQLITE_OK){
            return [self createTable:model_class];
        }
    }
    return NO;
}

+(BOOL)createTableifNotExist:(Class)model_class ignoredKeys:(NSArray*)ignoredKeys{
    NSString* database_cache_path = [self getSqlitePathWithClass:model_class];
    //NSLog(@"path = %@",database_cache_path);
    if([self isExistSqliteWithClass:model_class]){
        return sqlite3_open([database_cache_path UTF8String], &BG_Database) == SQLITE_OK;
    }else{
        if (sqlite3_open([database_cache_path UTF8String], &BG_Database) == SQLITE_OK){
            return [self createTable:model_class ignoredKeys:ignoredKeys];
        }
    }
    return NO;
}

+(BOOL)insertToDB:(id)object{
    NSString* insertSql;
    //获取对象数据
    NSArray<BGModelInfo*>* modelInfos = [BGModelInfo modelInfoWithObject:object sqlOption:BG_Insert inOutObj:&insertSql];
    BGDebug(insertSql)
    sqlite3_stmt * pp_stmt = nil;
    if (sqlite3_prepare_v2(BG_Database, [insertSql UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        [modelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int index = (int)idx+1;
            if ([obj.sqlColumnType isEqualToString:SqlInteger]) {
                sqlite3_bind_int64(pp_stmt, index, (sqlite3_int64)[obj.sqlColumnValue longLongValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlReal]){
                sqlite3_bind_double(pp_stmt, index, [obj.sqlColumnValue doubleValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlText]){
                sqlite3_bind_text(pp_stmt, index, [obj.sqlColumnValue UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                //二进制类型.
                sqlite3_bind_blob(pp_stmt, index, [obj.sqlColumnValue bytes], (int)[obj.sqlColumnValue length], SQLITE_TRANSIENT);
            }
        }];
        if (sqlite3_step(pp_stmt) != SQLITE_DONE) {
            sqlite3_finalize(pp_stmt);
        }
    }else{
        BGDebug(@"数据库存储失败,请检查是否有不支持的类型")
        return NO;
    }
    return YES;
}


+(BOOL)insertToDB:(id)object ignoredKeys:(NSArray*)ignoredKeys{
    //忽略掉不要的key.
    NSArray<BGModelInfo*>* modelInfos = [BGModelInfo modelInfoWithObject:object property:nil];
    NSMutableArray* newIgnoredKeys = [NSMutableArray arrayWithArray:ignoredKeys];
    NSMutableArray<BGModelInfo*>* newModelInfos = [NSMutableArray array];
    for(int i=0;i<modelInfos.count;i++){
        NSString* key = modelInfos[i].sqlColumnName;
        if ([key containsString:BG_PropertySeparator]) {
            key = [key stringByReplacingOccurrencesOfString:BG_PropertySeparator withString:@"."];
        }
        if (![newIgnoredKeys containsObject:key]) {
            [newModelInfos addObject:modelInfos[i]];
            continue;
        }
        [newIgnoredKeys removeObject:key];
    }
    //合成插入语句.
    NSMutableString* TempSql1 = [NSMutableString stringWithFormat:@"insert into %@(",[BGTool getTableNameWithCalss:[object class]]];
    NSMutableString* TempSql2 = [NSMutableString stringWithString:@") values("];
    [newModelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [TempSql1 appendFormat:@"%@,",obj.sqlColumnName];
        [TempSql2 appendString:@"?,"];
    }];
    TempSql1 = [NSMutableString stringWithString:[TempSql1 substringToIndex:TempSql1.length-1]];
    TempSql2 = [NSMutableString stringWithFormat:@"%@);",[TempSql2 substringToIndex:TempSql2.length-1]];
    NSString* insertSql = [NSString stringWithFormat:@"%@%@",TempSql1,TempSql2];
    BGDebug(insertSql)
    sqlite3_stmt * pp_stmt = nil;
    if (sqlite3_prepare_v2(BG_Database, [insertSql UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        [newModelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int index = (int)idx+1;
            if ([obj.sqlColumnType isEqualToString:SqlInteger]) {
                sqlite3_bind_int64(pp_stmt, index, (sqlite3_int64)[obj.sqlColumnValue longLongValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlReal]){
                sqlite3_bind_double(pp_stmt, index, [obj.sqlColumnValue doubleValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlText]){
                sqlite3_bind_text(pp_stmt, index, [obj.sqlColumnValue UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                //二进制类型.
                sqlite3_bind_blob(pp_stmt, index, [obj.sqlColumnValue bytes], (int)[obj.sqlColumnValue length], SQLITE_TRANSIENT);
            }
        }];
        if (sqlite3_step(pp_stmt) != SQLITE_DONE) {
            sqlite3_finalize(pp_stmt);
        }
    }else{
        BGDebug(@"数据库存储失败,请检查是否有不支持的类型")
        return NO;
    }
    return YES;

}

+(BOOL)insert:(id)object{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = YES;
    @autoreleasepool {
        if([self createTableifNotExist:[object class]]){
            [self ifIvarChangeForClass:[object class] ignoredKeys:nil];//自动判断更新数据库.
            Begin_Transcation
            [self insertToDB:object];
            Commit_Transcation
        }else{
            result = NO;
        }
        [self close];
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}

+(BOOL)insert:(id)object ignoredKeys:(NSArray* const)ignoredKeys{
    NSAssert(ignoredKeys,@"数组不能为空!");
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = YES;
    @autoreleasepool {
        if([self createTableifNotExist:[object class] ignoredKeys:ignoredKeys]){
            [self ifIvarChangeForClass:[object class] ignoredKeys:ignoredKeys];//自动判断更新数据库.
            Begin_Transcation
            [self insertToDB:object ignoredKeys:ignoredKeys];
            Commit_Transcation
        }else{
            result = NO;
        }
        [self close];
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;

}

+(BOOL)insertOrUpdate:(id)object{
    NSArray* uniqueKeys = [BGTool isRespondsToSelector:NSSelectorFromString(@"bg_uniqueKeys") forClass:[object class]];
    if(uniqueKeys.count) {
        NSString* uniqueKey = uniqueKeys.firstObject;
        id value = [object valueForKey:uniqueKey];
        NSString* where;
        if([value isKindOfClass:[NSString class]]){
            where = [NSString stringWithFormat:@"where %@='%@'",uniqueKey,value];
        }else{
            where = [NSString stringWithFormat:@"where %@=%@",uniqueKey,value];
        }
        NSArray* querys = [self queryWithClass:[object class] where:where];
        if(querys.count){
            return [self updateObj:object where:where];
        }else{
            return [self insert:object];
        }
    }else{
        return [self insert:object];
    }
}

+(BOOL)insertOrUpdate:(id)object ignoredKeys:(NSArray* const)ignoredKeys{
    NSArray* uniqueKeys = [BGTool isRespondsToSelector:NSSelectorFromString(@"bg_uniqueKeys") forClass:[object class]];
    if(uniqueKeys.count) {
        NSString* uniqueKey = uniqueKeys.firstObject;
        id value = [object valueForKey:uniqueKey];
        NSString* where;
        if([value isKindOfClass:[NSString class]]){
            where = [NSString stringWithFormat:@"where %@='%@'",uniqueKey,value];
        }else{
            where = [NSString stringWithFormat:@"where %@=%@",uniqueKey,value];
        }
        NSArray* querys = [self queryWithClass:[object class] where:where];
        if(querys.count){
            return [self updateObj:object ignoredKeys:ignoredKeys where:where];
        }else{
            return [self insert:object ignoredKeys:ignoredKeys];
        }
    }else{
        return [self insert:object ignoredKeys:ignoredKeys];
    }
}

+(BOOL)inserts:(NSArray* const)array{
    NSAssert(array||array.count,@"数据不能为空!");
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    __block BOOL result = YES;
    @autoreleasepool {
    if([self createTableifNotExist:[array.lastObject class]]){
         [self ifIvarChangeForClass:[array.firstObject class] ignoredKeys:nil];//自动判断更新数据库.
        Begin_Transcation
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                result = [self insertToDB:obj];
                //NSLog(@"开始执行第%@条",@(idx));
                if (!result){
                    *stop = YES;
                }
            }];
        Commit_Transcation
    }else{
            result = NO;
        }
    }
    [self close];
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}

+(BOOL)inserts:(NSArray* const)array ignoredKeys:(NSArray* const)ignoredKeys{
    NSAssert(array||array.count,@"数据不能为空!");
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    __block BOOL result = YES;
    @autoreleasepool {
        if([self createTableifNotExist:[array.lastObject class] ignoredKeys:ignoredKeys]){
            [self ifIvarChangeForClass:[array.firstObject class] ignoredKeys:ignoredKeys];//自动判断更新数据库.
            Begin_Transcation
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                result = [self insertToDB:obj ignoredKeys:ignoredKeys];
                //NSLog(@"开始执行第%@条",@(idx));
                if (!result){
                    *stop = YES;
                }
            }];
            Commit_Transcation
        }else{
            result = NO;
        }
        [self close];
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}

+(NSArray*)queryWith:(Class)model_class Sql:(NSString*)sql{
    NSArray<BGPropertyInfo*>* properInfos = [BGTool getClassIvarList:model_class];
    NSArray* array = nil;
    sqlite3_stmt * pp_stmt = nil;
    BGDebug(sql)
    if (sqlite3_prepare_v2(BG_Database, [sql UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        int colum_count = sqlite3_column_count(pp_stmt);
        NSMutableArray* tempArr = [NSMutableArray array];
        while (sqlite3_step(pp_stmt) == SQLITE_ROW) {
            NSMutableDictionary* sqlKeyValues = [NSMutableDictionary dictionary];
             for (int column = 0; column < colum_count; column++) {
                 //获取字段名称.
                 NSString * field_name = [NSString stringWithCString:sqlite3_column_name(pp_stmt, column) encoding:NSUTF8StringEncoding];
                 //NSLog(@"field_name = %@",field_name);
                 [properInfos enumerateObjectsUsingBlock:^(BGPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([field_name isEqualToString:obj.sqlColumnName]) {
                         
                         if ([obj.sqlColumnType containsString:SqlInteger]) {//为了兼容主键所以用了containsString
                             sqlite3_int64 value = sqlite3_column_int64(pp_stmt, column);
                             sqlKeyValues[obj.name]  = @(value);
                         }else if ([obj.sqlColumnType isEqualToString:SqlReal]){
                             double value = sqlite3_column_double(pp_stmt, column);
                             sqlKeyValues[obj.name]  = @(value);
                         }else if ([obj.sqlColumnType containsString:SqlText]){//为了兼容主键约束.
                             const unsigned char * text = sqlite3_column_text(pp_stmt, column);
                             if (text != NULL) {
                                 NSString * value = [NSString stringWithCString:(const char *)text encoding:NSUTF8StringEncoding];
                                 sqlKeyValues[obj.name]  = value;
                             }
                         }else{
                             //二进制类型.
                             int length = sqlite3_column_bytes(pp_stmt, column);
                             const void * blob = sqlite3_column_blob(pp_stmt, column);
                             NSData * value = [NSData dataWithBytes:blob length:length];
                             sqlKeyValues[obj.name]  = value;
                         }
                         
                         *stop = YES;
                     }
                 }];
             }
            [tempArr addObject:sqlKeyValues];
        }
        array = tempArr.count?tempArr:nil;
    }else {
        BGDebug(@"查询语句异常,请检查Sql语句语法是否正确")
    }
    sqlite3_finalize(pp_stmt);
    return array;
}
+(NSArray*)queryWithClass:(Class)model_class where:(NSString*)where{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    NSArray* array = nil;
    @autoreleasepool {
        if([self isExistSqliteWithClass:model_class] && [self openTable:model_class]){
            NSString* tableName = [BGTool getTableNameWithCalss:model_class];
            NSMutableString* SQL = [NSMutableString stringWithFormat:@"select * from %@",tableName];
            if (where) {
                if ([where containsString:@"."]) {
                   where = [where stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
                }
                [SQL appendFormat:@" %@",where];
            }
            array = [self queryWith:model_class Sql:SQL];
            array = array?[BGTool tansformDataFromSqlDataWithClassName:NSStringFromClass(model_class) array:array]:nil;
        }
        [self close];
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return array;
}

+(BOOL)updateToDB:(id)object where:(NSString*)where{
    NSArray<BGModelInfo*>* modelInfos = [BGModelInfo modelInfoWithObject:object property:nil];
    //合成插入语句.
    NSMutableString* TempSql1 = [NSMutableString stringWithFormat:@"update %@ set ",[BGTool getTableNameWithCalss:[object class]]];
    [modelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [TempSql1 appendFormat:@"%@=?,",obj.sqlColumnName];
    }];
    TempSql1 = [NSMutableString stringWithString:[TempSql1 substringToIndex:TempSql1.length-1]];
    NSString* updateSql = where?[NSString stringWithFormat:@"%@ %@",TempSql1,where]:TempSql1;
    BGDebug(updateSql)
    sqlite3_stmt * pp_stmt = nil;
    if (sqlite3_prepare_v2(BG_Database, [updateSql UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        [modelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int index = (int)idx+1;
            if ([obj.sqlColumnType isEqualToString:SqlInteger]) {
                sqlite3_bind_int64(pp_stmt, index, (sqlite3_int64)[obj.sqlColumnValue longLongValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlReal]){
                sqlite3_bind_double(pp_stmt, index, [obj.sqlColumnValue doubleValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlText]){
                sqlite3_bind_text(pp_stmt, index, [obj.sqlColumnValue UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                //二进制类型.
                sqlite3_bind_blob(pp_stmt, index, [obj.sqlColumnValue bytes], (int)[obj.sqlColumnValue length], SQLITE_TRANSIENT);
            }
        }];
        if (sqlite3_step(pp_stmt) != SQLITE_DONE) {
            sqlite3_finalize(pp_stmt);
        }
    }else{
        BGDebug(@"更新执行失败!")
        return NO;
    }
    return YES;
}

+(BOOL)updateObj:(id)object where:(NSString*)where{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = NO;
    @autoreleasepool {
    if([self isExistSqliteWithClass:[object class]]){
            if([self openTable:[object class]]){
                [self ifIvarChangeForClass:[object class] ignoredKeys:nil];//自动判断更新数据库.
                if (where && [where containsString:@"."]) {
                    where = [where stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
                }
                Begin_Transcation
                result = [self updateToDB:object where:where];
                Commit_Transcation
            }
            [self close];
        }else{
            BGDebug(@"符合条件的数据不存在,请先存入数据再进行更新!")
        }
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}

+(BOOL)updateToDB:(id)object ignoredKeys:(NSArray* const)ignoredKeys where:(NSString*)where{
    //忽略掉不要的key.
    NSArray<BGModelInfo*>* modelInfos = [BGModelInfo modelInfoWithObject:object property:nil];
    NSMutableArray* newIgnoredKeys = [NSMutableArray arrayWithArray:ignoredKeys];
    NSMutableArray<BGModelInfo*>* newModelInfos = [NSMutableArray array];
    for(int i=0;i<modelInfos.count;i++){
        NSString* key = modelInfos[i].sqlColumnName;
        if ([key containsString:BG_PropertySeparator]) {
            key = [key stringByReplacingOccurrencesOfString:BG_PropertySeparator withString:@"."];
        }
        if (![newIgnoredKeys containsObject:key]) {
            [newModelInfos addObject:modelInfos[i]];
            continue;
        }
        [newIgnoredKeys removeObject:key];
    }
    //合成更新语句.
    NSMutableString* TempSql1 = [NSMutableString stringWithFormat:@"update %@ set ",[BGTool getTableNameWithCalss:[object class]]];
    [newModelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [TempSql1 appendFormat:@"%@=?,",obj.sqlColumnName];
    }];
    TempSql1 = [NSMutableString stringWithString:[TempSql1 substringToIndex:TempSql1.length-1]];
    NSString* updateSql = where?[NSString stringWithFormat:@"%@ %@",TempSql1,where]:TempSql1;
    BGDebug(updateSql)
    sqlite3_stmt * pp_stmt = nil;
    if (sqlite3_prepare_v2(BG_Database, [updateSql UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        [newModelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int index = (int)idx+1;
            if ([obj.sqlColumnType isEqualToString:SqlInteger]) {
                sqlite3_bind_int64(pp_stmt, index, (sqlite3_int64)[obj.sqlColumnValue longLongValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlReal]){
                sqlite3_bind_double(pp_stmt, index, [obj.sqlColumnValue doubleValue]);
            }else if ([obj.sqlColumnType isEqualToString:SqlText]){
                sqlite3_bind_text(pp_stmt, index, [obj.sqlColumnValue UTF8String], -1, SQLITE_TRANSIENT);
            }else{
                //二进制类型.
                sqlite3_bind_blob(pp_stmt, index, [obj.sqlColumnValue bytes], (int)[obj.sqlColumnValue length], SQLITE_TRANSIENT);
            }
        }];
        if (sqlite3_step(pp_stmt) != SQLITE_DONE) {
            sqlite3_finalize(pp_stmt);
        }
    }else{
        BGDebug(@"更新执行失败!")
        return NO;
    }
    return YES;
}

+(BOOL)updateObj:(id)object ignoredKeys:(NSArray* const)ignoredKeys where:(NSString*)where{
    NSAssert(ignoredKeys,@"数组不能为空!");
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = NO;
    @autoreleasepool {
        if([self isExistSqliteWithClass:[object class]]){
            if([self openTable:[object class]]){
                //[self ifIvarChangeForClass:[object class] ignoredKeys:ignoredKeys];//自动判断更新数据库.
                if (where && [where containsString:@"."]) {
                    where = [where stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
                }
                Begin_Transcation
                result = [self updateToDB:object ignoredKeys:ignoredKeys where:where];
                Commit_Transcation
            }
            [self close];
        }else{
            BGDebug(@"符合条件的数据不存在,请先存入数据再进行更新!")
        }
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}


+(BOOL)updateSet:(Class)model_class sql:(NSString*)sql{
    NSAssert(sql,@"sql语句不能为空!");
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = NO;
    @autoreleasepool {
        if([self isExistSqliteWithClass:model_class]){
            if([self openTable:model_class]){
                //静态的更新不需要更新数据库检查.
                NSMutableString* SQL = [NSMutableString stringWithFormat:@"update %@ ",[BGTool getTableNameWithCalss:model_class]];
                    if ([sql containsString:@"."]) {
                        sql = [sql stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
                    }
                [SQL appendString:sql];
                Begin_Transcation
                result = [self execSql:SQL];
                Commit_Transcation
            }
            [self close];
        }else{
            BGDebug(@"符合条件的数据不存在,请先存入数据再进行更新!")
        }
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;

}

+(BOOL)deleteWithClass:(Class)model_class where:(NSString*)where{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = NO;
    @autoreleasepool {
        if([self isExistSqliteWithClass:model_class]){
            if([self openTable:model_class]){
                NSMutableString* SQL = [NSMutableString stringWithFormat:@"delete from %@",[BGTool getTableNameWithCalss:model_class]];
                if (where) {
                    if ([where containsString:@"."]) {
                        where = [where stringByReplacingOccurrencesOfString:@"." withString:BG_PropertySeparator];
                    }
                    [SQL appendFormat:@" %@",where];
                }
                Begin_Transcation
                result = [self execSql:SQL];
                Commit_Transcation
            }
            [self close];
        }else{
            BGDebug(@"符合条件的数据不存在,删除失败!")
        }
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}

+(BOOL)dropWithClass:(Class)model_class{
    dispatch_semaphore_wait([BGSqlite shareInstance].BG_Semaphore, DISPATCH_TIME_FOREVER);
    BOOL result = NO;
    @autoreleasepool {
        if([self isExistSqliteWithClass:model_class]){
               result = [self deleteSqliteWithClass:model_class];
        }else{
           BGDebug(@"类数据库不存在,删除类数据库失败!")
        }
    }
    dispatch_semaphore_signal([BGSqlite shareInstance].BG_Semaphore);
    return result;
}


+(NSArray *)columnNames:(Class)model_class{
    NSString* tableName = [BGTool getTableNameWithCalss:model_class];
    NSString* SQL = [NSString stringWithFormat:@"select * from %@ limit 0,1;",tableName];
    NSMutableArray* tempArrayM = [NSMutableArray array];
    sqlite3_stmt * pp_stmt = nil;
    if (sqlite3_prepare_v2(BG_Database, [SQL UTF8String], -1, &pp_stmt, nil) == SQLITE_OK) {
        int columnCount = sqlite3_column_count(pp_stmt);
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++){
            [tempArrayM addObject:[NSString stringWithUTF8String:sqlite3_column_name(pp_stmt, columnIdx)]];
        }
        if (sqlite3_step(pp_stmt) != SQLITE_DONE) {
            sqlite3_finalize(pp_stmt);
        }
    }
    return tempArrayM.count?tempArrayM:nil;
}

+(void)refresh:(Class)cla ignoredKeys:(NSArray*)ignoredKeys{
    @autoreleasepool {
        NSString* tableName = [BGTool getTableNameWithCalss:cla];
        NSString* querySQL = [NSString stringWithFormat:@"select * from %@;",tableName];
        //将就数据全部查询出来
        NSArray* objects = [self queryWith:cla Sql:querySQL];
        
        if (objects.count) {
            objects = objects?[BGTool tansformDataFromSqlDataWithClassName:tableName array:objects]:nil;
            [self deleteSqliteWithClass:cla];//删除旧的数据库
            ignoredKeys?[self createTableifNotExist:cla ignoredKeys:ignoredKeys]:[self createTableifNotExist:cla];
            Begin_Transcation
            if(ignoredKeys){
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    *stop = ![self insertToDB:obj ignoredKeys:ignoredKeys];
                }];
            }else{
                [objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    *stop = ![self insertToDB:obj];
                }];
            }
            Commit_Transcation
        }
    }
}

/**
 判断类属性是否有改变,智能刷新.
 */
+(void)ifIvarChangeForClass:(Class)cla ignoredKeys:(NSArray*)ignoredKeys{
    @autoreleasepool {
        NSMutableArray* newKeys = [NSMutableArray array];
        NSMutableArray* sqlKeys = [NSMutableArray array];
        NSArray* columNames = [self columnNames:cla];
        NSArray* propertyInfos = [BGTool getClassIvarList:cla];
        if (!columNames.count || !propertyInfos.count)return;
        
        NSMutableArray* propertyNames = [NSMutableArray array];
        for(BGPropertyInfo* propertyInfo in propertyInfos){
            if (ignoredKeys){
                NSString* tempKey = propertyInfo.sqlColumnName;
                if([tempKey containsString:BG_PropertySeparator]){
                    tempKey = [tempKey stringByReplacingOccurrencesOfString:BG_PropertySeparator withString:@"."];
                }
                if([ignoredKeys containsObject:tempKey])continue;
            }
            
            if (![columNames containsObject:propertyInfo.sqlColumnName]) {
                [newKeys addObject:propertyInfo.sqlColumnName];
            }
            [propertyNames addObject:propertyInfo.sqlColumnName];
        }
        
        [columNames enumerateObjectsUsingBlock:^(NSString* _Nonnull columName, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* propertyName = [columName stringByReplacingOccurrencesOfString:BG withString:@""];
            if(![propertyNames containsObject:propertyName]){
                [sqlKeys addObject:columName];
            }
        }];
        
        NSString* tableName = NSStringFromClass(cla);
        if((sqlKeys.count==0) && (newKeys.count>0)){NSLog(@"添加新字段...");
            //此处只是增加了新的列.
            for(NSString* key in newKeys){
                //添加新字段
                NSString* SQL = [NSString stringWithFormat:@"alter table %@ add %@;",tableName,key];
                [self execSql:SQL];
            }
        }else if (sqlKeys.count>0){NSLog(@"数据库刷新....");
            //字段发生改变,减少或名称变化,实行刷新数据库.
            [self refresh:cla ignoredKeys:ignoredKeys];//进行刷新处理.
        }else;
    }
}

@end

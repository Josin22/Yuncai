//
//  YBLDBManage.m
//  YC168
//
//  Created by 乔同新 on 2017/6/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLDBManage.h"
#import "YBLGoodModel.h"
#import <FMDB/FMDB.h>

static NSString *const records_good_sqlite_name = @"ycxxx.sqlite";


static YBLDBManage *shareDB = nil;

@interface YBLDBManage ()
{
//    WCTDatabase *_recordsDB;
}
@end

@implementation YBLDBManage

+ (YBLDBManage *)shareDB{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDB = [YBLDBManage new];
        FMDatabaseQueue *queue = [self getSharedDatabaseQueue];
        [queue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                [shareDB createTable:db];
            }else {
                NSLog(@"打开数据库失败");
            }
        }];
    });
    return shareDB;
}

+(FMDatabaseQueue *)getSharedDatabaseQueue {
    static FMDatabaseQueue *my_FMDatabaseQueue = nil;
    if (!my_FMDatabaseQueue) {
        NSString *path     = [self dbPath];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return my_FMDatabaseQueue;
}

+ (NSString*)dbPath {
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    NSString *path = [doc stringByAppendingPathComponent:records_good_sqlite_name];;
    return path;
}

- (void)createTable:(FMDatabase *)db{
    
    NSString *sql6 = @"create table if not exists footPrint(id integer PRIMARY KEY AUTOINCREMENT NOT NULL, gid text ,title text,price double,thumb text,sale_order_count integer, comments_total integer)";
    if (![db executeUpdate:sql6]) {
        NSLog(@"创建足迹表失败");
    }
}

- (void)saveRecordsGoodDetailModel:(YBLGoodModel *)good{

    dispatch_async(dispatch_queue_create("com.save", DISPATCH_QUEUE_SERIAL), ^{
        FMDatabaseQueue *queue = [YBLDBManage getSharedDatabaseQueue];
        [queue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                NSString *sql = @"insert into footPrint(gid,title,price,thumb,sale_order_count,comments_total) values(?,?,?,?,?,?)";
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    BOOL success =  [db executeUpdate:@"DELETE  FROM footPrint where gid = ?",good.id];
                    //                    [db executeUpdate:@"delete from footPrint order by id desc limit 9,-1"];
                    if (success) {
                        if (![db executeUpdate:sql,good.id,good.title,good.price,good.thumb,good.sale_order_count,good.comments_total]) {
                            NSLog(@"插入失败1");
                        }
                    }
                }
                @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                }
                @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
                [db close];
            }else {
                NSLog(@"打开数据库失败");
            }
        }];
    });
}

- (void)deleRecordsGoodModelByGoodID:(NSString *)goodID{
    
    dispatch_async(dispatch_queue_create("com.save", DISPATCH_QUEUE_SERIAL), ^{
        FMDatabaseQueue *queue = [YBLDBManage getSharedDatabaseQueue];
        [queue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    BOOL success =  [db executeUpdate:@"DELETE  FROM footPrint where gid = ?",goodID];
                    if (!success) {
                        NSLog(@"取消收藏失败");
                    }
                }
                @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                }
                @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
                [db close];
            }else {
                NSLog(@"打开数据库失败");
            }
        }];
    });
}

- (NSMutableArray *)getTenRecordsGoodDataArray{
    NSString *sql = @"select * from footPrint order by id desc limit 1, 100";
    return [self getRecordsGoodDataArrayWithSql:sql];
}

- (NSMutableArray *)getRecordsGoodDataArray{
    NSString *sql = @"select * from footPrint order by id desc";
    return [self getRecordsGoodDataArrayWithSql:sql];
}

- (NSMutableArray *)getRecordsGoodDataArrayWithSql:(NSString *)sql{
    NSMutableArray *array = [NSMutableArray array];
    FMDatabaseQueue *queue = [YBLDBManage getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            FMResultSet *resultSet = [db executeQuery:sql];
            while (resultSet.next) {
                YBLGoodModel *good = [[YBLGoodModel alloc] init];
                good.id = [resultSet stringForColumn:@"gid"];
                good.title = [resultSet stringForColumn:@"title"];
                good.price = @([resultSet doubleForColumn:@"price"]);
                good.thumb = [resultSet stringForColumn:@"thumb"];
                good.sale_order_count = @([resultSet intForColumn:@"sale_order_count"]);
                good.comments_total = @([resultSet intForColumn:@"comments_total"]);
                [array addObject:good];
            }
            [db close];
            [resultSet close];
        }else {
            NSLog(@"打开数据库失败");
        }
    }];
    return array;
}

- (void)cleanAllRecordsGood{
    dispatch_async(dispatch_queue_create("com.save", DISPATCH_QUEUE_SERIAL), ^{
        FMDatabaseQueue *queue = [YBLDBManage getSharedDatabaseQueue];
        [queue inDatabase:^(FMDatabase *db) {
            if ([db open]) {
                [db beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    BOOL success =  [db executeUpdate:@"DELETE  FROM footPrint "];
                    if (!success) {
                        NSLog(@"取消足迹失败");
                    }
                }
                @catch (NSException *exception) {
                    isRollBack = YES;
                    [db rollback];
                }
                @finally {
                    if (!isRollBack) {
                        [db commit];
                    }
                }
                [db close];
            }else {
                NSLog(@"打开数据库失败");
            }
        }];
    });
}

- (NSInteger)getRecordsCount{
    __block NSInteger number = 0;
    FMDatabaseQueue *queue = [YBLDBManage getSharedDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql = @"select * from footPrint";
            FMResultSet *resultSet = [db executeQuery:sql];
            while (resultSet.next) {
                number++;
            }
            [db close];
            [resultSet close];
        }else {
            NSLog(@"打开数据库失败");
        }
    }];
    return number;
}

@end

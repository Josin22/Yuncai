//
//  BGModelInfo.m
//  BGFMDB
//
//  Created by huangzhibiao on 17/2/22.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import "BGModelInfo.h"
#import "BGTool.h"

@implementation BGModelInfo

-(instancetype)initWithProperName:(NSString*)properName properType:(BGPropertyType)properType propertyValue:(id)propertyValue sqlColumnName:(NSString*)sqlColumnName sqlColumnType:(NSString*)sqlColumnType sqlColumnValue:(id)sqlColumnValue{
    self = [super init];
    if (self) {
        _propertyName = properName;
        _propertyType = properType;
        _propertyValue = propertyValue;
        _sqlColumnName = [sqlColumnName containsString:BG_PropertySeparator]?sqlColumnName:[NSString stringWithFormat:@"%@%@",BG,sqlColumnName];
        _sqlColumnType = sqlColumnType;
        _sqlColumnValue = sqlColumnValue;
    }
    return self;
}


+(NSArray<BGModelInfo*>*)modelInfoWithObject:(id)object property:(NSString*)property{
    NSMutableArray* modelInfos = [NSMutableArray array];
    [BGTool bg_enumerateClasses:[object class] complete:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int numIvars; //成员变量个数
        Ivar *vars = class_copyIvarList(c, &numIvars);
        for(int i = 0; i < numIvars; i++) {
            Ivar thisIvar = vars[i];
            NSString* key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
            if ([key containsString:@"_"]) {
                key = [key substringFromIndex:1];
            }
            NSString* properType = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
            BGPropertyInfo* propertyInfo = [BGTool getProperInfoForCla:[object class] Name:key type:properType];
            //属性名
            NSString* propertyName = propertyInfo.name;
            //存入数据库的字段名
            NSString* sqlColumnName = property?[NSString stringWithFormat:@"%@%@%@",property,BG_PropertySeparator,propertyName]:propertyName;
            //属性类型
            BGPropertyType propertyType = propertyInfo.type;
            //数据库列属性
            NSString* sqlColumnType = [BGTool getSqlType:propertyType];
            id propertyValue = [object valueForKey:propertyName];
            if(propertyValue){
                id sqlValue = [BGTool getSqlValue:propertyValue properInfo:propertyInfo encode:YES];
                if ([sqlValue isKindOfClass:[NSString class]]&&[sqlValue isEqualToString:BG_Model]) {
                    [modelInfos addObjectsFromArray:[self getClassProperInfo:propertyValue property:sqlColumnName]];
                    continue;
                }
                //初始化模型信息
                BGModelInfo* modelInfo = [[BGModelInfo alloc] initWithProperName:propertyName properType:propertyType propertyValue:propertyValue sqlColumnName:sqlColumnName sqlColumnType:sqlColumnType sqlColumnValue:sqlValue];
                [modelInfos addObject:modelInfo];
            }
        }
        free(vars);//释放资源
    } finally:nil];
    
    NSAssert(modelInfos.count,@"对象变量数据为空,不能存储!");
    return modelInfos;
}


+(NSArray<BGModelInfo*>*)modelInfoWithObject:(id)object sqlOption:(BG_sqlOption)sqlOption inOutObj:(id *)obj{
    NSMutableArray<BGModelInfo*>* modelInfos = [NSMutableArray array];
    [BGTool bg_enumerateClasses:[object class] complete:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int numIvars; //成员变量个数
        Ivar *vars = class_copyIvarList(c, &numIvars);
        for(int i = 0; i < numIvars; i++) {
            Ivar thisIvar = vars[i];
            NSString* key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
            if ([key containsString:@"_"]) {
                key = [key substringFromIndex:1];
            }
            NSString* properType = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
            BGPropertyInfo* propertyInfo = [BGTool getProperInfoForCla:[object class] Name:key type:properType];
            //属性名
            NSString* propertyName = propertyInfo.name;
            //属性类型
            BGPropertyType propertyType = propertyInfo.type;
            //数据库列属性
            NSString* sqlColumnType = [BGTool getSqlType:propertyType];
            //获取属性值.
            id propertyValue = [object valueForKey:propertyName];
            if(propertyValue){
               id sqlValue = [BGTool getSqlValue:propertyValue properInfo:propertyInfo encode:YES];
                if ([sqlValue isKindOfClass:[NSString class]]&&[sqlValue isEqualToString:BG_Model]) {
                    [modelInfos addObjectsFromArray:[self getClassProperInfo:propertyValue property:propertyName]];
                    continue;
                }
                //初始化模型信息
                BGModelInfo* modelInfo = [[BGModelInfo alloc] initWithProperName:propertyName properType:propertyType propertyValue:propertyValue sqlColumnName:propertyName sqlColumnType:sqlColumnType sqlColumnValue:sqlValue];
                [modelInfos addObject:modelInfo];
            }
            }
        free(vars);//释放资源
    } finally:^{//最后执行
        NSMutableString* TempSql1;
        NSMutableString* TempSql2;
        switch (sqlOption) {
            case BG_Insert://插入.
                TempSql1 = [NSMutableString stringWithFormat:@"insert into %@(",[BGTool getTableNameWithCalss:[object class]]];
                TempSql2 = [NSMutableString stringWithString:@") values("];
                break;
                
            default:
                break;
        }
        [modelInfos enumerateObjectsUsingBlock:^(BGModelInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [TempSql1 appendFormat:@"%@,",obj.sqlColumnName];
            [TempSql2 appendString:@"?,"];
        }];
        //crateTime和updateTime两个额外字段单独处理.(放在此处是为了优化循环效率)
//        NSString* TimeValue = [BGTool stringWithDate:[NSDate new]];
//        BGModelInfo* CreateTimeInfo = [[BGModelInfo alloc] initWithProperName:BGCreateTime properType:BG_String propertyValue:TimeValue sqlColumnName:BGCreateTime sqlColumnType:SqlText sqlColumnValue:TimeValue];
//        BGModelInfo* UpdateTimeInfo = [[BGModelInfo alloc] initWithProperName:BGUpdateTime properType:BG_String propertyValue:TimeValue sqlColumnName:BGUpdateTime sqlColumnType:SqlText sqlColumnValue:TimeValue];
//        [modelInfos addObject:CreateTimeInfo];
//        [modelInfos addObject:UpdateTimeInfo];
//        [TempSql1 appendFormat:@"%@%@,",BG,BGCreateTime];
//        [TempSql1 appendFormat:@"%@%@,",BG,BGUpdateTime];
//        [TempSql2 appendString:@"?,?,"];
        //合并语句.
        TempSql1 = [NSMutableString stringWithString:[TempSql1 substringToIndex:TempSql1.length-1]];
        TempSql2 = [NSMutableString stringWithFormat:@"%@);",[TempSql2 substringToIndex:TempSql2.length-1]];
        NSString* Sql = [NSString stringWithFormat:@"%@%@",TempSql1,TempSql2];
        *obj = Sql;//通过指针传给外面
        //NSLog(@"重构后sql = %@",insertSql);
    }];
    
    NSAssert(modelInfos.count,@"对象变量数据为空,不能存储!");
    return modelInfos;
}

+(NSArray<BGModelInfo*>*)getClassProperInfo:(id)object property:(NSString*)property{//处理自定义类的属性
    return [self modelInfoWithObject:object property:property];
}

@end

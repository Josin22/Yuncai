//
//  BGTool.m
//  BGFMDB
//
//  Created by huangzhibiao on 17/2/16.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BGTool.h"
#import "BGSqlite.h"

//100M大小限制.
#define MaxData @(838860800)

static NSSet *foundationClasses_;

@implementation BGTool
/**
 json字符转json格式数据 .
 */
+(id)jsonWithString:(NSString*)jsonString {
    NSAssert(jsonString,@"数据不能为空!");
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    
    NSAssert(!err,@"json解析失败");
    return dic;
}
/**
 字典转json字符 .
 */
+(NSString*)dataToJson:(id)data{
    NSAssert(data,@"数据不能为空!");
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSSet *)foundationClasses{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}

+(void)bg_enumerateClasses:(__unsafe_unretained Class)srcCla complete:(BGClassesEnumeration)enumeration
                    finally:(void(^)())block{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    // 2.停止遍历的标记
    BOOL stop = NO;
    // 3.当前正在遍历的类
    Class c = srcCla;
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        // 4.2.获得父类
        c = class_getSuperclass(c);
        if ([self isClassFromFoundation:c]){
            !block?:block();
            break;
        }
    }
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    if (c == [NSObject class] || c == [NSManagedObject class]) return YES;
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}
+ (id)exceSelector:(SEL)selector modelClass:(Class)model_class{
    id obj = nil;
    if([model_class respondsToSelector:selector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    obj = [model_class performSelector:selector];
#pragma clang diagnostic pop
    }
    return obj;
}
/**
 根据类名获取表格名称.
 */
+(NSString*)getTableNameWithCalss:(Class)model_class{
    return [NSString stringWithFormat:@"%@%@",BG,NSStringFromClass(model_class)];
}
+(BGPropertyType)getProperType:(NSString*)properType sqlColumnType:(NSString**)sqlColumnType{
    BGPropertyType typeValue = BG_Integer;
    properType = [properType lowercaseString];//转为小写
    const char type = *[properType UTF8String];
    switch (type) {
        case 'i':
        case 's':
        case 'q':
        case 'b':
        case 'c':
        case 'l':
            typeValue = BG_Integer;
            *sqlColumnType = SqlInteger;
            break;
        case 'f':
        case 'd':
            typeValue = BG_Real;
            *sqlColumnType = SqlReal;
            break;
        default:
            break;
    }
    return typeValue;
}
+(BGPropertyInfo*)getProperInfoForCla:(__unsafe_unretained Class)cla Name:(NSString*)name type:(NSString*)type{
    BGPropertyType valueType;
    NSString* sqlColumnType = SqlText;
    NSString* className = nil;
    if(type.length == 1){
        valueType = [self getProperType:type sqlColumnType:&sqlColumnType];
    }else if([type containsString:@"String"]){
        valueType = BG_String;
        sqlColumnType = SqlText;
    }else if([type containsString:@"Number"]){
        valueType = BG_Number;
        sqlColumnType = SqlText;
    }else if([type containsString:@"Array"]){
        valueType = BG_Array;
        sqlColumnType = SqlText;
    }else if([type containsString:@"Dictionary"]){
        valueType = BG_Dictionary;
        sqlColumnType = SqlText;
    }else if([type containsString:@"Set"]){
        valueType = BG_Set;
        sqlColumnType = SqlText;
    }else if([type containsString:@"Data"]){
        valueType = BG_Data;
        sqlColumnType = SqlBlob;
    }else if([type containsString:@"NSMapTable"]){
        valueType = BG_MapTable;
        sqlColumnType = SqlText;
    }else if ([type containsString:@"NSHashTable"]){
        valueType = BG_NSHashTable;
        sqlColumnType = SqlText;
    }else if ([type containsString:@"NSDate"]){
        valueType = BG_Date;
        sqlColumnType = SqlText;
    }else if ([type containsString:@"NSURL"]){
        valueType = BG_URL;
        sqlColumnType = SqlText;
    }else if ([type containsString:@"UIImage"]){
        valueType = BG_UIImage;
        sqlColumnType = SqlBlob;
    }else if ([type containsString:@"NSRange"]){
        valueType = BG_NSRange;
        sqlColumnType = SqlText;
    }else if ([type containsString:@"CGRect"]&&[type containsString:@"CGPoint"]&&[type containsString:@"CGSize"]){
        valueType = BG_CGRect;
        sqlColumnType = SqlText;
    }else if (![type containsString:@"CGRect"]&&[type containsString:@"CGPoint"]&&![type containsString:@"CGSize"]){
        valueType = BG_CGPoint;
        sqlColumnType = SqlText;
    }else if (![type containsString:@"CGRect"]&&![type containsString:@"CGPoint"]&&[type containsString:@"CGSize"]){
        valueType = BG_CGSize;
        sqlColumnType = SqlText;
    }else{
        valueType = BG_ModelTpye;
        sqlColumnType = SqlText;
        className = [type substringWithRange:NSMakeRange(2,type.length-3)];
    }
    if(!className){
        //判断是否实现了"唯一约束"函数
        NSArray * uniqueKeys = [self exceSelector:NSSelectorFromString(@"bg_uniqueKeys") modelClass:cla];
        if (uniqueKeys) {
            for(NSString* uniqueKey in uniqueKeys){
                NSString* key = name;
                if([name containsString:BG_PropertySeparator]){
                    key = [name componentsSeparatedByString:BG_PropertySeparator].lastObject;
                }
                if ([uniqueKey isEqualToString:key]) {
                    sqlColumnType = [sqlColumnType stringByAppendingString:@" unique"];
                }
            }
        }
    }
    return [BGPropertyInfo properInfoWithName:name type:valueType className:className sqlColumnType:sqlColumnType];
}
//获得自定义类变量的属性.
+(NSArray<BGPropertyInfo*>*)getPropertyClassIvarList:(__unsafe_unretained Class)cla property:(NSString*)property{
    NSMutableArray* ivarProperList = [NSMutableArray array];
    [self bg_enumerateClasses:cla complete:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int numIvars; //成员变量个数
        Ivar *vars = class_copyIvarList(c, &numIvars);
        for(int i = 0; i < numIvars; i++) {
            Ivar thisIvar = vars[i];
            NSString* key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
            if ([key containsString:@"_"]) {
                key = [key substringFromIndex:1];
            }
            NSString* properType = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
            key = [NSString stringWithFormat:@"%@%@%@",property,BG_PropertySeparator,key];
            BGPropertyInfo* properInfo = [self getProperInfoForCla:c Name:key type:properType];
            if (properInfo.className) {
                [ivarProperList addObjectsFromArray: [self getPropertyClassIvarList:NSClassFromString(properInfo.className) property:key]];
            }else{
                [ivarProperList addObject:properInfo];
            }

        }
        free(vars);//释放资源
    } finally:nil];
    return ivarProperList;
}

/**
 根据类获取变量名列表
 @onlyKey YES:紧紧返回key,NO:在key后面添加type.
 */
+(NSArray<BGPropertyInfo*>*)getClassIvarList:(__unsafe_unretained Class)cla{
    NSMutableArray* ivarProperList = [NSMutableArray array];
    [ivarProperList addObject:[BGPropertyInfo properInfoWithName:BGPrimaryKey type:BG_Integer className:nil sqlColumnType:@"integer primary key autoincrement"]];//主键专门处理.
//创建时间和更新时间这两个库自带字段先不要,后期有需要再增加.
//    [ivarProperList addObject:[BGPropertyInfo properInfoWithName:BGCreateTime type:BG_String className:nil sqlColumnType:SqlText]];
//    [ivarProperList addObject:[BGPropertyInfo properInfoWithName:BGUpdateTime type:BG_String className:nil sqlColumnType:SqlText]];
    [self bg_enumerateClasses:cla complete:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int numIvars; //成员变量个数
        Ivar *vars = class_copyIvarList(c, &numIvars);
        for(int i = 0; i < numIvars; i++) {
            Ivar thisIvar = vars[i];
            NSString* key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
            if ([key containsString:@"_"]) {
                key = [key substringFromIndex:1];
            }
            NSString* properType = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
            BGPropertyInfo* properInfo = [self getProperInfoForCla:c Name:key type:properType];
            if(properInfo.className){
                //获取自定义类变量的属性.
                [ivarProperList addObjectsFromArray: [self getPropertyClassIvarList:NSClassFromString(properInfo.className) property:key]];
            }else{
            [ivarProperList addObject:properInfo];
            }
        }
        free(vars);//释放资源
    } finally:nil];
    return ivarProperList;
}

+(id)getObjectWithClass:(__unsafe_unretained _Nonnull Class)cla{
    id superObject = [cla new];
    [self bg_enumerateClasses:cla complete:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int numIvars; //成员变量个数
        Ivar *vars = class_copyIvarList(c, &numIvars);
        for(int i = 0; i < numIvars; i++) {
            Ivar thisIvar = vars[i];
            NSString* key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];//获取成员变量的名
            if ([key containsString:@"_"]) {
                key = [key substringFromIndex:1];
            }
            NSString* properType = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
            BGPropertyInfo* properInfo = [self getProperInfoForCla:c Name:key type:properType];
            if(properInfo.className){
               id value =  [self getObjectWithClass:NSClassFromString(properInfo.className)];
               [superObject setValue:value forKey:key];
            }
        }
        free(vars);//释放资源
    } finally:nil];
    return superObject;
}

//对象转json字符
+(NSString *)jsonStringWithObject:(id)object{
    NSMutableDictionary* keyValueDict = [NSMutableDictionary dictionary];
    NSArray* keyAndTypes = [BGTool getClassIvarList:[object class]];
    for(BGPropertyInfo* properInfo in keyAndTypes){
        NSString* propertyName = properInfo.name;
        if(![propertyName isEqualToString:BGPrimaryKey]){
            id propertyValue = [object valueForKey:propertyName];
            if (propertyValue){
                id Value = [self getSqlValue:propertyValue properInfo:properInfo encode:YES];
                //特殊处理数组自定义类中的二进制数据类型.
                if((properInfo.type==BG_Data) || (properInfo.type==BG_UIImage)){
                    Value = [Value base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                }
                keyValueDict[propertyName] = Value;
            }
        }
    }
    return [self dataToJson:keyValueDict];
}
//根据value类型返回用于数组插入数据库的NSDictionary
+(NSDictionary*)dictionaryForArrayInsert:(id)value{
    if ([value isKindOfClass:[NSArray class]]){
        return @{BGArray:[self jsonStringWithArray:value]};
    }else if ([value isKindOfClass:[NSSet class]]){
        return @{BGSet:[self jsonStringWithArray:value]};
    }else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]){
        return @{BGValue:value};
    }else if([value isKindOfClass:[NSData class]]){
        NSData* data = value;
        NSNumber* maxLength = MaxData;
        NSAssert(data.length<maxLength.integerValue,@"最大存储限制为100M");
        return @{BGData:[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    }else if ([value isKindOfClass:[UIImage class]]){
        NSData* data = UIImageJPEGRepresentation(value, 1);
        NSNumber* maxLength = MaxData;
        NSAssert(data.length<maxLength.integerValue,@"最大存储限制为100M");
        return @{BGImage:[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    }else if ([value isKindOfClass:[NSDictionary class]]){
        return @{BGDictionary:[self jsonStringWithDictionary:value]};
    }else if ([value isKindOfClass:[NSMapTable class]]){
        return @{BGMapTable:[self jsonStringWithMapTable:value]};
    }else if([value isKindOfClass:[NSHashTable class]]){
        return @{BGHashTable:[self jsonStringWithNSHashTable:value]};
    }else{
        NSString* modelKey = [NSString stringWithFormat:@"%@*%@",BG_Model,NSStringFromClass([value class])];
        return @{modelKey:[self jsonStringWithObject:value]};
    }
    
}
//NSArray,NSSet转json字符
+(NSString*)jsonStringWithArray:(id)array{
    if ([NSJSONSerialization isValidJSONObject:array]) {
        return [self dataToJson:array];
    }else{
        NSMutableArray* arrM = [NSMutableArray array];
        for(id value in array){
            [arrM addObject:[self dictionaryForArrayInsert:value]];
        }
        return [self dataToJson:arrM];
    }
}

//根据value类型返回用于字典插入数据库的NSDictionary
+(NSDictionary*)dictionaryForDictionaryInsert:(id)value{
    if ([value isKindOfClass:[NSArray class]]){
        return @{BGArray:[self jsonStringWithArray:value]};
    }else if ([value isKindOfClass:[NSSet class]]){
        return @{BGSet:[self jsonStringWithArray:value]};
    }else if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]){
        return @{BGValue:value};
    }else if([value isKindOfClass:[NSData class]]){
        NSData* data = value;
        NSNumber* maxLength = MaxData;
        NSAssert(data.length<maxLength.integerValue,@"最大存储限制为100M");
        return @{BGData:[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    }else if ([value isKindOfClass:[UIImage class]]){
        NSData* data = UIImageJPEGRepresentation(value, 1);
        NSNumber* maxLength = MaxData;
        NSAssert(data.length<maxLength.integerValue,@"最大存储限制为100M");
        return @{BGImage:[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]};
    }else if ([value isKindOfClass:[NSDictionary class]]){
        return @{BGDictionary:[self jsonStringWithDictionary:value]};
    }else if ([value isKindOfClass:[NSMapTable class]]){
        return @{BGMapTable:[self jsonStringWithMapTable:value]};
    }else if ([value isKindOfClass:[NSHashTable class]]){
        return @{BGHashTable:[self jsonStringWithNSHashTable:value]};
    }else{
        NSString* modelKey = [NSString stringWithFormat:@"%@*%@",BG_Model,NSStringFromClass([value class])];
        return @{modelKey:[self jsonStringWithObject:value]};
    }
}
//字典转json字符串.
+(NSString*)jsonStringWithDictionary:(NSDictionary*)dictionary{
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        return [self dataToJson:dictionary];
    }else{
        NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
        for(NSString* key in dictionary.allKeys){
            dictM[key] = [self dictionaryForDictionaryInsert:dictionary[key]];
        }
        return [self dataToJson:dictM];
    }

}
//NSMapTable转json字符串.
+(NSString*)jsonStringWithMapTable:(NSMapTable*)mapTable{
    NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
    NSArray* objects = mapTable.keyEnumerator.allObjects;
    NSArray* keys = mapTable.objectEnumerator.allObjects;
    for(int i=0;i<objects.count;i++){
        dictM[keys[i]] = [self dictionaryForDictionaryInsert:objects[i]];
    }
    return [self dataToJson:dictM];
}
//NSHashTable转json字符串.
+(NSString*)jsonStringWithNSHashTable:(NSHashTable*)hashTable{
    NSMutableArray* arrM = [NSMutableArray array];
    NSArray* values = hashTable.objectEnumerator.allObjects;
    for(id value in values){
        [arrM addObject:[self dictionaryForArrayInsert:value]];
    }
    return  [self dataToJson:arrM];
}
//NSDate转字符串,格式: yyyy-MM-dd HH:mm:ss
+(NSString*)stringWithDate:(NSDate*)date{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [formatter stringFromDate:date];
}
/**
 获取插入数据库数据的类型
 */
+(NSString*)getSqlType:(BGPropertyType)propertyType{
    NSString* valueType;
    switch (propertyType) {
        case BG_Integer:
            valueType = SqlInteger;
            break;
        case BG_Real:
            valueType = SqlReal;
            break;
        case BG_Data:
        case BG_UIImage:
            valueType = SqlBlob;
            break;
        default:
            valueType = SqlText;
            break;
    }
    return valueType;
}
//跟value和数据类型type 和编解码标志 返回编码插入数据库的值,或解码数据库的值.
+(id)getSqlValue:(id)value properInfo:(BGPropertyInfo* _Nonnull)properInfo encode:(BOOL)encode{
    if(!value || [value isKindOfClass:[NSNull class]])return nil;
    BGPropertyType type = properInfo.type;
    switch (type) {
        case BG_Integer:
        case BG_Real:
        case BG_String:
        case BG_Data:{
            return value;
            break;
        }
        case BG_Number:{
            if(encode) {
                return [NSString stringWithFormat:@"%@",value];
            }else{
                return [[NSNumberFormatter new] numberFromString:value];
            }
            break;
        }
        case BG_Array:{
            if(encode){
                return [self jsonStringWithArray:value];
            }else{
                return [self arrayFromJsonString:value];
            }
            break;
        }
        case BG_Dictionary:{
            if(encode){
                return [self jsonStringWithDictionary:value];
            }else{
                return [self dictionaryFromJsonString:value];
            }
            break;
        }
        case BG_ModelTpye:{
            if(encode){
                return BG_Model;
            }else{
                return value;
            }
            break;
        }
        case BG_Set:{
            if(encode){
                return [self jsonStringWithArray:value];
            }else{
                return [self arrayFromJsonString:value];
            }
            break;
        }
        case BG_MapTable:{
            if(encode){
                return [self jsonStringWithMapTable:value];
            }else{
                return [self mapTableFromJsonString:value];
            }
            break;
        }
        case BG_NSHashTable:{
            if(encode){
                return [self jsonStringWithNSHashTable:value];
            }else{
                return [self hashTableFromJsonString:value];
            }
            break;
        }
        case BG_Date:{
            if(encode){
                return [self stringWithDate:value];
            }else{
                return [self dateFromString:value];
            }
            break;
        }
        case BG_URL:{
            if(encode){
                return [value absoluteString];
            }else{
                return [NSURL URLWithString:value];
            }
            break;
        }
        case BG_UIImage:{
            if(encode){
                NSData* data = UIImageJPEGRepresentation(value, 1);
                NSNumber* maxLength = MaxData;
                NSAssert(data.length<maxLength.integerValue,@"最大存储限制为100M");
                return data;
            }else{
                return [UIImage imageWithData:value];
            }
            break;
        }
        case BG_UIColor:{
            if(encode){
                CGFloat r, g, b, a;
                [value getRed:&r green:&g blue:&b alpha:&a];
                return [NSString stringWithFormat:@"%.3f,%.3f,%.3f,%.3f", r, g, b, a];
            }else{
                NSArray<NSString*>* arr = [value componentsSeparatedByString:@","];
                return [UIColor colorWithRed:arr[0].floatValue green:arr[1].floatValue blue:arr[2].floatValue alpha:arr[3].floatValue];
            }
            break;
        }
        case BG_NSRange:{
            if(encode){
                return NSStringFromRange([value rangeValue]);
            }else{
                return [NSValue valueWithRange:NSRangeFromString(value)];
            }
            break;
        }
        case BG_CGRect:{
            if(encode){
                return NSStringFromCGRect([value CGRectValue]);
            }else{
                return [NSValue valueWithCGRect:CGRectFromString(value)];
            }
            break;
        }
        case BG_CGPoint:{
            if(encode){
                return NSStringFromCGPoint([value CGPointValue]);
            }else{
                return [NSValue valueWithCGPoint:CGPointFromString(value)];
            }
            break;
        }
        case BG_CGSize:{
            if(encode){
                return NSStringFromCGSize([value CGSizeValue]);
            }else{
                return [NSValue valueWithCGSize:CGSizeFromString(value)];
            }
            break;
        }
        default:
            break;
    }
    NSAssert(NO,@"您存储了不支持的类型!");
    return nil;
}
/**
 存储转换用的字典转化成对象处理函数.
 */
+(id)objectFromJsonStringWithClassName:(NSString*)claName valueDict:(NSDictionary*)valueDict{
    Class cla = NSClassFromString(claName);
    id object = [BGTool getObjectWithClass:cla];
    NSArray* keyAndTypes = [self getClassIvarList:cla];
    [valueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop1) {
        [keyAndTypes enumerateObjectsUsingBlock:^(BGPropertyInfo* _Nonnull properInfo, NSUInteger idx, BOOL * _Nonnull stop2) {
            if ([key isEqualToString:properInfo.name]){
                id ivarValue = [self getSqlValue:value properInfo:properInfo encode:NO];
                if([key containsString:BG_PropertySeparator]){
                    NSString* keyPath = [properInfo.name stringByReplacingOccurrencesOfString:BG_PropertySeparator withString:@"."];
                    [object setValue:ivarValue forKeyPath:keyPath];
                }else{
                    [object setValue:ivarValue forKey:properInfo.name];
                }
                *stop2 = YES;;//匹配处理完后跳出内循环.
            }
        }];
    }];
    
    return object;
}

/**
 处理组数嵌套类中二进制类型.
 */
+(id)objectFromArrayJsonStringWithClassName:(NSString*)claName valueDict:(NSDictionary*)valueDict{
    Class cla = NSClassFromString(claName);
    id object = [BGTool getObjectWithClass:cla];
    NSArray* keyAndTypes = [self getClassIvarList:cla];
    [valueDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id _Nonnull value, BOOL * _Nonnull stop1){
        id __block tempValue = value;
        [keyAndTypes enumerateObjectsUsingBlock:^(BGPropertyInfo* _Nonnull properInfo, NSUInteger idx, BOOL * _Nonnull stop2) {
            if ([key isEqualToString:properInfo.name]){
                id ivarValue;
                //特殊处理数组自定义类中的二进制数据类型.
                if((properInfo.type==BG_Data) || (properInfo.type==BG_UIImage)){
                   tempValue = [[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters];
                }
                ivarValue = [self getSqlValue:tempValue properInfo:properInfo encode:NO];
                if([key containsString:BG_PropertySeparator]){
                    NSString* keyPath = [properInfo.name stringByReplacingOccurrencesOfString:BG_PropertySeparator withString:@"."];
                    [object setValue:ivarValue forKeyPath:keyPath];
                }else{
                    [object setValue:ivarValue forKey:properInfo.name];
                }
                *stop2 = YES;;//匹配处理完后跳出内循环.
            }
        }];
    }];
    
    return object;

}

/**
 字典或json格式字符转模型用的处理函数.
 */
+(id)bg_objectWithClass:(__unsafe_unretained _Nonnull Class)cla value:(id)value{
    if(value == nil)return nil;
    
    NSMutableDictionary* dataDict;
    id object = [cla new];
    if ([value isKindOfClass:[NSString class]]){
        NSAssert([NSJSONSerialization isValidJSONObject:value],@"json数据格式错误!");
        dataDict = [[NSMutableDictionary alloc] initWithDictionary:[self jsonWithString:value] copyItems:YES];
    }else if ([value isKindOfClass:[NSDictionary class]]){
        dataDict = [[NSMutableDictionary alloc] initWithDictionary:value copyItems:YES];
    }else{
        NSAssert(NO,@"数据格式错误!, 只能转换字典或json格式数据.");
    }
    NSDictionary* const objectClaInArr = [BGTool isRespondsToSelector:NSSelectorFromString(@"bg_objectClassInArray") forClass:[object class]];//[self getClassInArrayType:object];
    NSDictionary* const objectClaForCustom = [BGTool isRespondsToSelector:NSSelectorFromString(@"bg_objectClassForCustom") forClass:[object class]];
    NSArray* const claKeys = [self getClassIvarList:cla];
    //遍历自定义变量集合信息.
    !objectClaForCustom?:[objectClaForCustom enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull customKey, id  _Nonnull customObj, BOOL * _Nonnull stop) {
        if ([customKey containsString:@"."]){
            NSArray* keyPaths = [customKey componentsSeparatedByString:@"."];
            id value = [dataDict valueForKeyPath:customKey];
            dataDict[keyPaths.lastObject] = value;
            if(![objectClaForCustom.allKeys containsObject:keyPaths.firstObject]){
                [dataDict removeObjectForKey:keyPaths.firstObject];
            }
        }
    }];
    [dataDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull dataDictObj, BOOL * _Nonnull stop) {
        for(NSString* claKey in claKeys){
            if ([key isEqualToString:claKey]){
                __block id ArrObject = dataDictObj;
                //遍历自定义变量数组集合信息.
                !objectClaInArr?:[objectClaInArr enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull Arrkey, id  _Nonnull ArrObjCla, BOOL * _Nonnull stop){
                    if([key isEqualToString:Arrkey]){
                        NSMutableArray* ArrObjects = [NSMutableArray array];
                        for(NSDictionary* ArrObj in dataDictObj){
                            id obj = [self bg_objectWithClass:ArrObjCla value:ArrObj];
                            [ArrObjects addObject:obj];
                        }
                        ArrObject = ArrObjects;
                        *stop = YES;
                    }
                }];
                
                //遍历自定义变量集合信息.
                !objectClaForCustom?:[objectClaForCustom enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull customKey, id  _Nonnull customObj, BOOL * _Nonnull stop) {
                    NSString* tempKey = customKey;
                    if ([customKey containsString:@"."]){
                        tempKey = [customKey componentsSeparatedByString:@"."].lastObject;
                    }
                    
                    if([key isEqualToString:tempKey]){
                        ArrObject = [self bg_objectWithClass:customObj value:[dataDict valueForKey:tempKey]];
                        *stop = YES;
                    }
                }];
                
                [object setValue:ArrObject forKey:key];
                break;//匹配到了就跳出循环.
            }
        }
    }];
    
    return object;
}

/**
 模型转字典.
 */
+(NSMutableDictionary*)bg_keyValuesWithObject:(id)object ignoredKeys:(NSArray*)ignoredKeys{
    NSMutableArray<NSString*>* keys = [[NSMutableArray alloc] initWithArray:[self getClassIvarList:[object class]]];
    if (ignoredKeys) {
        [keys removeObjectsInArray:ignoredKeys];
    }
    NSDictionary* const objectClaInArr = [BGTool isRespondsToSelector:NSSelectorFromString(@"bg_objectClassInArray") forClass:[object class]];
    NSDictionary* const objectClaForCustom = [BGTool isRespondsToSelector:NSSelectorFromString(@"bg_dictForCustomClass") forClass:[object class]];
    NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
    
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        __block id value = [object valueForKey:key];
        //遍历自定义变量数组集合信息.
        !objectClaInArr?:[objectClaInArr enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull Arrkey, id  _Nonnull ArrObjCla, BOOL * _Nonnull stop){
            if([key isEqualToString:Arrkey]){
                NSMutableArray* ArrObjects = [NSMutableArray array];
                for(id arrObj in value){
                    id dictObj = [self bg_keyValuesWithObject:arrObj ignoredKeys:nil];
                    [ArrObjects addObject:dictObj];
                }
                value = ArrObjects;
                *stop = YES;
            }
        }];
        
        //遍历自定义变量集合信息.
        !objectClaForCustom?:[objectClaForCustom enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull customKey, id  _Nonnull customObj, BOOL * _Nonnull stop) {
            if([key isEqualToString:customKey]){
                value = [self bg_keyValuesWithObject:[object valueForKey:customKey] ignoredKeys:nil];
                *stop = YES;
            }
        }];
        
        //存到集合里.
        !value?:[dictM setValue:value forKey:key];
    }];
    
    
    return dictM;
}


//根据NSDictionary转换从数据库读取回来的数组数据
+(id)valueForArrayRead:(NSDictionary*)dictionary{
    
    NSString* key = dictionary.allKeys.firstObject;
    if ([key isEqualToString:BGValue]) {
        return dictionary[key];
    }else if ([key isEqualToString:BGData]){
       return [[NSData alloc] initWithBase64EncodedString:dictionary[key] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }else if ([key isEqualToString:BGImage]){
        NSData* data = [[NSData alloc] initWithBase64EncodedString:dictionary[key] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    }else if([key isEqualToString:BGSet]){
        return [self arrayFromJsonString:dictionary[key]];
    }else if([key isEqualToString:BGArray]){
        return [self arrayFromJsonString:dictionary[key]];
    }else if ([key isEqualToString:BGDictionary]){
       return [self dictionaryFromJsonString:dictionary[key]];
    }else if ([key containsString:BG_Model]){
        NSString* claName = [key componentsSeparatedByString:@"*"].lastObject;
        NSDictionary* valueDict = [self jsonWithString:dictionary[key]];
        id object = [self objectFromArrayJsonStringWithClassName:claName valueDict:valueDict];
        return object;
    }else{
        NSAssert(NO,@"没有找到匹配的解析类型");
        return nil;
    }

}
//json字符串转NSArray
+(NSArray*)arrayFromJsonString:(NSString*)jsonString{
    if(!jsonString || [jsonString isKindOfClass:[NSNull class]])return nil;
    
    if([jsonString containsString:BG_Model] ||
       [jsonString containsString:BGData] ||
       [jsonString containsString:BGImage]){
        NSMutableArray* arrM = [NSMutableArray array];
        NSArray* array = [self jsonWithString:jsonString];
        for(NSDictionary* dict in array){
            [arrM addObject:[self valueForArrayRead:dict]];
        }
        return arrM;
    }else{
        return [self jsonWithString:jsonString];
    }
}

//根据NSDictionary转换从数据库读取回来的字典数据
+(id)valueForDictionaryRead:(NSDictionary*)dictDest{
    
    NSString* keyDest = dictDest.allKeys.firstObject;
    if([keyDest isEqualToString:BGValue]){
        return dictDest[keyDest];
    }else if ([keyDest isEqualToString:BGData]){
        return [[NSData alloc] initWithBase64EncodedString:dictDest[keyDest] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }else if ([keyDest isEqualToString:BGImage]){
        NSData* data = [[NSData alloc] initWithBase64EncodedString:dictDest[keyDest] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        return [UIImage imageWithData:data];
    }else if([keyDest isEqualToString:BGSet]){
        return [self arrayFromJsonString:dictDest[keyDest]];
    }else if([keyDest isEqualToString:BGArray]){
        return [self arrayFromJsonString:dictDest[keyDest]];
    }else if([keyDest isEqualToString:BGDictionary]){
        return [self dictionaryFromJsonString:dictDest[keyDest]];
    }else if([keyDest containsString:BG_Model]){
        NSString* claName = [keyDest componentsSeparatedByString:@"*"].lastObject;
        NSDictionary* valueDict = [self jsonWithString:dictDest[keyDest]];
        return [self objectFromJsonStringWithClassName:claName valueDict:valueDict];
    }else{
        NSAssert(NO,@"没有找到匹配的解析类型");
        return nil;
    }

}
//json字符串转NSDictionary
+(NSDictionary*)dictionaryFromJsonString:(NSString*)jsonString{
    if(!jsonString || [jsonString isKindOfClass:[NSNull class]])return nil;
    
    if([jsonString containsString:BG_Model] ||
       [jsonString containsString:BGData] ||
       [jsonString containsString:BGImage]){
        NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
        NSDictionary* dictSrc = [self jsonWithString:jsonString];
        for(NSString* keySrc in dictSrc.allKeys){
            NSDictionary* dictDest = dictSrc[keySrc];
            dictM[keySrc]= [self valueForDictionaryRead:dictDest];
        }
        return dictM;
    }else{
        return [self jsonWithString:jsonString];
    }
}
//json字符串转NSMapTable
+(NSMapTable*)mapTableFromJsonString:(NSString*)jsonString{
    if(!jsonString || [jsonString isKindOfClass:[NSNull class]])return nil;
    
    NSDictionary* dict = [self jsonWithString:jsonString];
    NSMapTable* mapTable = [NSMapTable new];
    for(NSString* key in dict.allKeys){
        id value = [self valueForDictionaryRead:dict[key]];
        [mapTable setObject:value forKey:key];
    }
    return mapTable;
}
//json字符串转NSHashTable
+(NSHashTable*)hashTableFromJsonString:(NSString*)jsonString{
    if(!jsonString || [jsonString isKindOfClass:[NSNull class]])return nil;
    
    NSArray* arr = [self jsonWithString:jsonString];
    NSHashTable* hashTable = [NSHashTable new];
    for (id obj in arr) {
        id value = [self valueForArrayRead:obj];
        [hashTable addObject:value];
    }
    return hashTable;
}
//json字符串转NSDate
+(NSDate*)dateFromString:(NSString*)jsonString{
    if(!jsonString || [jsonString isKindOfClass:[NSNull class]])return nil;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSDate *date = [formatter dateFromString:jsonString];
    return date;
}
//转换从数据库中读取出来的数据.
+(NSArray*)tansformDataFromSqlDataWithClassName:(NSString*)className array:(NSArray*)array{
    NSMutableArray* arrM = [NSMutableArray array];
    for(NSDictionary* dict in array){
        id object = [BGTool objectFromJsonStringWithClassName:className valueDict:dict];
        [arrM addObject:object];
    }
    return arrM;
}
/**
 获取字典转模型部分的数组数据类型
 */
+(NSDictionary*)getClassInArrayType:(id)object{
    NSDictionary* dict = nil;
    SEL objectClassInArraySeltor = NSSelectorFromString(@"objectClassInArray");
    if([object respondsToSelector:objectClassInArraySeltor]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        dict = [object performSelector:objectClassInArraySeltor];
#pragma clang diagnostic pop
    }
    return dict;
}
/**
 判断类是否实现了某个类方法.
 */
+(id)isRespondsToSelector:(SEL)selector forClass:(Class)cla{
    id obj = nil;
    if([cla respondsToSelector:selector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        obj = [cla performSelector:selector];
#pragma clang diagnostic pop
    }
    return obj;
}

+(BOOL)getBoolWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}
+(void)setBoolWithKey:(NSString*)key value:(BOOL)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
+(NSString*)getStringWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:key];
}
+(void)setStringWithKey:(NSString*)key value:(NSString*)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}
+(NSInteger)getIntegerWithKey:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}
+(void)setIntegerWithKey:(NSString*)key value:(NSInteger)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

@end

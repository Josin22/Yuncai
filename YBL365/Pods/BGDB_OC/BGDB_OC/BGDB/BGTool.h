//
//  BGTool.h
//  BGFMDB
//
//  Created by huangzhibiao on 17/2/16.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BGModelInfo.h"
#import "BGPropertyInfo.h"

// 过期
#define BGFMDBDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#define SqlText @"text" //数据库的字符类型
#define SqlReal @"real" //数据库的浮点类型
#define SqlInteger @"integer" //数据库的整数类型
#define SqlBlob @"blob" //数据库的二进制类型

#define BG @""
#define BGPrimaryKey @"ID"
//#define BGCreateTime @"createTime"
//#define BGUpdateTime @"updateTime"

#define BGValue @"BGValue"
#define BGData @"BGData"
#define BGImage @"BGImage"
#define BGArray @"BGArray"
#define BGSet @"BGSet"
#define BGDictionary @"BGDictionary"
#define BG_Model @"BG_Model"
#define BGMapTable @"BGMapTable"
#define BGHashTable @"BGHashTable"

//存入数据库的字段,自定义类变量分隔符
#define BG_PropertySeparator @"$"

/**
 *  遍历所有类的block（父类）
 */
typedef void (^BGClassesEnumeration)(Class c, BOOL *stop);

@interface BGTool : NSObject
/**
 json字符转json格式数据 .
 */
+(id )jsonWithString:(NSString*)jsonString;
/**
 字典转json字符 .
 */
+(NSString* )dataToJson:(id)data;
/**
 根据类获取变量名列表
 @onlyKey YES:紧紧返回key,NO:在key后面添加type.
 */
+(NSArray<BGPropertyInfo*>*)getClassIvarList:(__unsafe_unretained Class)cla;
+(id)getObjectWithClass:(__unsafe_unretained Class)cla;
/**
 NSDate转字符串,格式: yyyy-MM-dd HH:mm:ss
 */
+(NSString*)stringWithDate:(NSDate*)date;
/**
 获取插入数据库数据的类型
 */
+(NSString*)getSqlType:(BGPropertyType)propertyType;
/**
 根据类名获取表格名称.
 */
+(NSString*)getTableNameWithCalss:(Class __unsafe_unretained)model_class;
/**
 根据类属性值和属性类型返回数据库存储的值.
 @value 数值.
 @type 数组value的类型.
 @ encode YES:编码 , NO:解码.
 */
+(id)getSqlValue:(id)value properInfo:(BGPropertyInfo*)properInfo encode:(BOOL)encode;
/**
 转换从数据库中读取出来的数据.
 @tableName 表名(即类名).
 @array 传入要转换的数组数据.
 */
+(NSArray*)tansformDataFromSqlDataWithClassName:(NSString*)className array:(NSArray*)array;
/**
 转换从数据库中读取出来的数据.
 @claName 类名.
 @valueDict 传入要转换的字典数据.
 */
+(id)objectFromJsonStringWithClassName:(NSString*)claName valueDict:(NSDictionary*)valueDict;
/**
 字典或json格式字符转模型用的处理函数.
 */
+(id)bg_objectWithClass:(__unsafe_unretained Class)cla value:(id)value;
/**
 模型转字典.
 */
+(NSMutableDictionary*)bg_keyValuesWithObject:(id)object ignoredKeys:(NSArray*)ignoredKeys;
+(void)bg_enumerateClasses:(__unsafe_unretained Class)srcCla complete:(BGClassesEnumeration)enumeration
                   finally:(void(^)())block;
+(BGPropertyInfo*)getProperInfoForCla:(__unsafe_unretained Class)cla Name:(NSString*)name type:(NSString*)type;
/**
 判断类是否实现了某个类方法.
 */
+(id)isRespondsToSelector:(SEL)selector forClass:(Class)cla;
/**
 NSUserDefaults封装使用函数.
 */
+(BOOL)getBoolWithKey:(NSString*)key;
+(void)setBoolWithKey:(NSString*)key value:(BOOL)value;
+(NSString*)getStringWithKey:(NSString*)key;
+(void)setStringWithKey:(NSString*)key value:(NSString*)value;
+(NSInteger)getIntegerWithKey:(NSString*)key;
+(void)setIntegerWithKey:(NSString*)key value:(NSInteger)value;
@end

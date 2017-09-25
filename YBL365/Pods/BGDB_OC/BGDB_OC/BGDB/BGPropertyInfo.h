//
//  BGPropertyInfo.h
//  BGDB_OC
//
//  Created by huangzhibiao on 17/3/25.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,BGPropertyType){//数据改变状态
    BG_Integer,//包含了所有整形和布尔类型.
    BG_Real,//包含了所有浮点类型
    BG_String,
    BG_Number,
    BG_Data,
    BG_Date,
    BG_Array,
    BG_Dictionary,
    BG_Set,
    BG_MapTable,
    BG_NSHashTable,
    BG_URL,
    BG_UIImage,
    BG_UIColor,
    BG_NSRange,
    BG_CGRect,
    BG_CGPoint,
    BG_CGSize,
    BG_ModelTpye
};

@interface BGPropertyInfo : NSObject
//属性名
@property (nonatomic, copy, readonly) NSString * name;
//保存到数据库的列名
@property (nonatomic, copy, readonly) NSString *sqlColumnName;
//保存到数据库的类型
@property (nonatomic, copy, readonly) NSString *sqlColumnType;

//属性类型
@property (nonatomic, assign, readonly) BGPropertyType type;
//属性类名
@property (nonatomic, copy, readonly) NSString* className;

+(instancetype)properInfoWithName:(NSString*)name type:(BGPropertyType)type className:(NSString*)className sqlColumnType:(NSString*)sqlColumnType;

@end

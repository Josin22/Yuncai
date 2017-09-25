//
//  BGModelInfo.h
//  BGFMDB
//
//  Created by huangzhibiao on 17/2/22.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGPropertyInfo.h"

typedef NS_ENUM(NSInteger,BG_sqlOption){//数据改变状态
    BG_Insert,
    BG_Query,
    BG_Update,
    BG_Delete,
    BG_Drop
};


@interface BGModelInfo : NSObject

//属性名
@property (nonatomic, copy, readonly) NSString *propertyName;
//属性的类型
@property (nonatomic, assign, readonly) BGPropertyType propertyType;
//属性值
@property (nonatomic, copy, readonly) id propertyValue;

//保存到数据库的列名
@property (nonatomic, copy, readonly) NSString *sqlColumnName;
//保存到数据库的类型
@property (nonatomic, copy, readonly) NSString *sqlColumnType;
//保存到数据库的值
@property (nonatomic, copy, readonly) id sqlColumnValue;

//获取对象相关信息
+(NSArray<BGModelInfo*>*)modelInfoWithObject:(id)object property:(NSString*)property;
//获取对象相关信息
+(NSArray<BGModelInfo*>*)modelInfoWithObject:(id)object sqlOption:(BG_sqlOption)sqlOption inOutObj:(id *)obj;
@end


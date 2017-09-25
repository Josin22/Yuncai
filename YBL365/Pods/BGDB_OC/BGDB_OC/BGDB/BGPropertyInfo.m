//
//  BGPropertyInfo.m
//  BGDB_OC
//
//  Created by huangzhibiao on 17/3/25.
//  Copyright © 2017年 Biao. All rights reserved.
//

#import "BGPropertyInfo.h"
#import "BGTool.h"


@implementation BGPropertyInfo

-(instancetype)initWithName:(NSString*)name type:(BGPropertyType)type className:(NSString*)className sqlColumnType:(NSString*)sqlColumnType{
    self = [super init];
    if (self) {
        _name = name;
        _sqlColumnName = [name containsString:BG_PropertySeparator]?name:[NSString stringWithFormat:@"%@%@",BG,name];
        _type = type;
        _className = !className?nil:className;
        _sqlColumnType = sqlColumnType;
    }
    return self;
}

+(instancetype)properInfoWithName:(NSString *)name type:(BGPropertyType)type className:(NSString*)className sqlColumnType:(NSString*)sqlColumnType{
    BGPropertyInfo* properInfo = [[BGPropertyInfo alloc] initWithName:name type:type className:className sqlColumnType:sqlColumnType];
    return properInfo;
}

@end

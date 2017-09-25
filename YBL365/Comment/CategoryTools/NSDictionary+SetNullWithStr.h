//
//  NSDictionary+SetNullWithStr.h
//  Buyers
//
//  Created by 陈小明 on 2017/1/3.
//  Copyright © 2017年 wanshenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SetNullWithStr)

/*
 *把服务器返回的<null> 替换为“”
 *json表示获取到的带有NULL对象的json数据
 *NSDictionary *newDict = [NSDictionary changeType:json];
 */
+(id)changeType:(id)myObj;


@end

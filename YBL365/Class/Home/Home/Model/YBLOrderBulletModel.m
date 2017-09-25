//
//  YBLOrderBulletModel.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderBulletModel.h"

@implementation YBLOrderBulletModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }
@end

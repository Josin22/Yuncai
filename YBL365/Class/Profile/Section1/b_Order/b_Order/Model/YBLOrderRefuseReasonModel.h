//
//  YBLOrderRefuseReasonModel.h
//  YC168
//
//  Created by 乔同新 on 2017/5/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLOrderRefuseReasonModel : NSObject

@property (nonatomic, strong) NSString       *id;
@property (nonatomic, strong) NSString       *code;
@property (nonatomic, strong) NSMutableArray *name;
@property (nonatomic, strong) NSString       *desc;
@property (nonatomic, strong) NSString       *type;
@property (nonatomic, strong) NSString       *subtype;

@end

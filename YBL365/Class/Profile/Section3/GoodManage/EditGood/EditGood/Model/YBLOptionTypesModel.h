//
//  YBLOptionTypesModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLOptionTypesModel : NSObject

@property (nonatomic, copy  ) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *required;
@property (nonatomic, strong) NSNumber *position;

@property (nonatomic, copy  ) NSString *category_id;
@property (nonatomic, strong) NSArray  *values;

@end

//
//  YBLCompanyTypesItemModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCompanyTypesItemModel : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *companytypeinfo;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isAllSelect;

@end

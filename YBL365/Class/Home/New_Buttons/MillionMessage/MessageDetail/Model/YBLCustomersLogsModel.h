//
//  YBLCustomersLogsModel.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLCustomersLogsModel : NSObject

@property (nonatomic, copy  ) NSString *id;

@property (nonatomic, copy  ) NSString *first_name;

@property (nonatomic, strong) UIColor *name_bg_color;

@property (nonatomic, copy  ) NSString *content;

@property (nonatomic, copy  ) NSString *creator_name;

@property (nonatomic, copy  ) NSString *created_at;

@property (nonatomic, assign) CGFloat content_height;

@property (nonatomic, assign) CGFloat time_width;

@end

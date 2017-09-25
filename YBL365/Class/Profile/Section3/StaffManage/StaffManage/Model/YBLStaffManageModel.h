//
//  YBLStaffManageModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBLStaffManageModel :NSObject

@property (nonatomic , copy  ) NSString * avatar;
@property (nonatomic , copy  ) NSString * mobile;
@property (nonatomic , copy  ) NSString * id;
@property (nonatomic , copy  ) NSString * authentication_token;
@property (nonatomic , copy  ) NSString * shop_name;
@property (nonatomic , copy  ) NSString * shop_id;
@property (nonatomic , copy  ) NSString * name;
@property (nonatomic , strong) NSArray  * role_names;
@property (nonatomic , copy  ) NSString * created_at;

@end

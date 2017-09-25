//
//  YBLUserModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//
#import "CoreArchive.h"
#import <Foundation/Foundation.h>


@interface YBLUserModel :NSObject

CoreArchiver_MODEL_H

@property (nonatomic , copy) NSString              * user_type;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * aasm_state;
@property (nonatomic , copy) NSString              * audit_desc;
@property (nonatomic , copy) NSString              * wx_headimgurl;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * email;
@property (nonatomic , copy) NSString              * avatar_url;
@property (nonatomic , copy) NSString              * authentication_token;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * shop_name;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * openid;
@property (nonatomic , copy) NSString              * userinfo_id;


@end



//
//  WXUserModel.h
//  YC168
//
//  Created by 乔同新 on 2017/4/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//
#import "CoreArchive.h"
#import <Foundation/Foundation.h>

@interface WXUserModel : NSObject

CoreArchiver_MODEL_H

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *wx_headimgurl;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *privilege;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *unionid;
@property (nonatomic, copy) NSString *tmpcode;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *platform;

@end

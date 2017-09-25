//
//  YBLLoginViewModel.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSDKUser;

@interface YBLLoginViewModel : NSObject

///微信登录
+ (RACSignal *)singalForWXLogin:(SSDKUser *)wxModel
                         mobile:(NSString *)mobile
                       password:(NSString *)password;
///新增注册手机号绑定微信
+ (RACSignal *)singalForWXLogin:(SSDKUser *)wxModel
                         mobile:(NSString *)mobile
                       tempCode:(NSString *)tempCode;
///登录
+ (RACSignal *)singalForLogin:(WXUserModel *)model;
///注销
+ (RACSignal *)singalForLogout;
///搜索用户
+ (RACSignal *)singalForUserSearchWith:(NSString *)phoneNummber;
///搜索用户是否绑定wx_id
+ (RACSignal *)singalForUserCheckHasWXIDSearchWith:(NSString *)phoneNummber;
///微信用户搜索
+ (RACSignal *)singalForWXSearchWith:(NSString *)openid;
///发送验证码
+ (RACSignal *)singalForVerifyCodeWith:(NSString *)phoneNummber;
///重置密码
+ (RACSignal *)singalForResetPasswardWith:(NSString *)phoneNummber passward:(NSString *)passward tmpcode:(NSString *)tmpcode;
///用户详细信息
+ (RACSignal *)siganlForGetUserInfos;
///店铺信息
+ (RACSignal *)siganlForGetStoreInfoWithID:(NSString *)ID;
///上传头像
+ (RACSignal *)siganlForUpdateUserIconWithImage:(UIImage *)iconImage;
///更新信息
+ (RACSignal *)siganlForUpdateUserInfoWithKey:(NSString *)key value:(NSString *)value;
+ (RACSignal *)siganlForGetUserInfoIds;

@end


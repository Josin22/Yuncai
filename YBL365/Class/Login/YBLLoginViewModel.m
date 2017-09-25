//
//  YBLLoginViewModel.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLoginViewModel.h"
#import <ShareSDK/SSDKUser.h>
#import "WXUserModel.h"

@implementation YBLLoginViewModel

+ (RACSignal *)singalForWXLogin:(SSDKUser *)wxModel
                         mobile:(NSString *)mobile
                       password:(NSString *)password{
    
    return [self singalForWXLogin:wxModel
                           mobile:mobile
                         password:password
                         tempCode:nil];
}

+ (RACSignal *)singalForWXLogin:(SSDKUser *)wxModel
                         mobile:(NSString *)mobile
                       tempCode:(NSString *)tempCode{
    return [self singalForWXLogin:wxModel
                           mobile:mobile
                         password:nil
                         tempCode:tempCode];
}

+ (RACSignal *)singalForWXLogin:(SSDKUser *)wxModel
                         mobile:(NSString *)mobile
                       password:(NSString *)password
                       tempCode:(NSString *)tempCode{
    
    WXUserModel *model = [WXUserModel yy_modelWithJSON:wxModel.rawData];
    if (!model) {
        model = [WXUserModel new];
    }
    BOOL isCreate = NO;
    if (mobile||password) {
        isCreate = YES;
    }
    model.mobile = mobile;
    model.password = password;
    model.tmpcode = tempCode;
    return [self singalForLogin:model isCreate:isCreate];
}

+ (RACSignal *)singalForLogin:(WXUserModel *)model{
    
    return [self singalForLogin:model isCreate:NO];
}

+ (RACSignal *)singalForLogin:(WXUserModel *)model isCreate:(BOOL)isCreate{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    NSString *url = nil;
    if (isCreate) {
        url = url_user_create;
        paraDict[@"mobile"] = model.mobile;
        paraDict[@"tmpcode"] = model.tmpcode;
        paraDict[@"password"] = model.password;
        paraDict[@"password_confirmation"] = model.password;
        paraDict[@"openid"] = model.openid;
        paraDict[@"nickname"] = model.nickname;
        paraDict[@"sex"] = model.sex;
        paraDict[@"wx_province"] = model.province;
        paraDict[@"wx_city"] = model.city;
        paraDict[@"wx_country"] = model.country;
        paraDict[@"wx_headimgurl"] = model.headimgurl;
    } else {
        url = url_login_new;
        if (model.openid) {
            paraDict[@"openid"] = model.openid;
        }
        if (model.mobile) {
            paraDict[@"mobile"] = model.mobile;
            paraDict[@"password"] = model.password;
        }

    }
    paraDict[@"platform"] = @"ios";
    NSString *registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    paraDict[@"registration_id"] = registrationID;

    [YBLRequstTools HTTPPostWithUrl:url
                            Parames:paraDict
                          commplete:^(id result,NSInteger statusCode) {
                              if (statusCode == 200||statusCode == 201) {
                                  [SVProgressHUD showSuccessWithStatus:@"登录成功~"];
                                  if (isCreate) {
                                      
                                      YBLUserModel *user = [YBLUserModel yy_modelWithJSON:result];
                                      [YBLUserManageCenter shareInstance].userModel = user;
                                      
                                      YBLUserInfoModel *userInfo = [YBLUserInfoModel yy_modelWithJSON:result];
                                      [YBLUserManageCenter shareInstance].userInfoModel = userInfo;
                                      
                                  } else {
                                      
                                      YBLUserModel *user = [YBLUserModel yy_modelWithJSON:result[@"user"]];
                                      //
                                      YBLUserInfoModel *userInfo = [YBLUserInfoModel yy_modelWithJSON:result[@"userinfo"]];
                                      //
                                      WXUserModel *wxuserModel = [WXUserModel yy_modelWithJSON:result[@"weixin"]];
                                      /**
                                       *  处理判断
                                       */
                                      if (kStringIsEmpty(userInfo.nickname)) {
                                          userInfo.nickname = wxuserModel.nickname;
                                      }
                                      if (kStringIsEmpty(userInfo.sex)) {
                                          if (wxuserModel.sex.integerValue == 0) {
                                              userInfo.sex = @"女";
                                          } else if (wxuserModel.sex.integerValue == 1) {
                                              userInfo.sex = @"男";
                                          } else {
                                              userInfo.sex = @"保密";
                                          }
                                      }
                                      if ([userInfo.head_img rangeOfString:@"miss.png"].location != NSNotFound) {
                                          userInfo.head_img = wxuserModel.wx_headimgurl;
                                      }
                                    
                                      [YBLUserManageCenter shareInstance].wxUserModel = wxuserModel;
                                      [YBLUserManageCenter shareInstance].userModel = user;
                                      [YBLUserManageCenter shareInstance].userInfoModel = userInfo;
                                  }
                                  //
                                  [subject sendNext:@YES];
                                  
                              } else {
                                  [SVProgressHUD showErrorWithStatus:@"用户名或密码错误!"];
                                  [subject sendNext:@NO];
                              }
                              [subject sendCompleted];
                        
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
//                                YBLUserModel *user = [YBLUserModel new];
//                                user.authentication_token = @"NTNEKxxNCspNwKePHGCd";
//                                user.usertype = @(2);
//                                [YBLUserManageCenter shareInstance].YBLUserModel = user;
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)singalForWXSearchWith:(NSString *)openid{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"openid"] = openid;
    [YBLRequstTools HTTPGetDataWithUrl:url_users_wxsearch
                               Parames:para
                             commplete:^(id result,NSInteger statusCode) {
                                 NSDictionary *resultDict = (NSDictionary *)result;
                                 id user = resultDict[@"user"];
                                 BOOL isExistUser = [self getBooleanValueWith:user];
                                 [subject sendNext:@(isExistUser)];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)singalForVerifyCodeWith:(NSString *)phoneNummber{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"mobile"] = phoneNummber;
    para[@"type"] = @"sms";
    
    [YBLRequstTools HTTPPostWithUrl:url_users_verifycode
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              [subject sendNext:result];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)singalForLogout{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"注销中..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSString *registrationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    para[@"registration_id"] = registrationID;
    
    [YBLRequstTools HTTPPostWithUrl:url_logout_new
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"注销成功~"];
                              [YBLUserManageCenter logout];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (RACSignal *)singalForUserSearchWith:(NSString *)phoneNummber{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self searchUserWithMobile:phoneNummber] subscribeNext:^(id  _Nullable x) {
        NSDictionary *resultDict = (NSDictionary *)x;
        id user = resultDict[@"user"];
        BOOL isExistUser = [self getBooleanValueWith:user];
        [subject sendNext:@(isExistUser)];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}


+ (RACSignal *)singalForUserCheckHasWXIDSearchWith:(NSString *)phoneNummber{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self searchUserWithMobile:phoneNummber] subscribeNext:^(id  _Nullable x) {
        NSDictionary *resultDict = (NSDictionary *)x;
        NSString *open_id = resultDict[@"openid"];
        BOOL isEmpty = kStringIsEmpty(open_id);
        [subject sendNext:@(isEmpty)];
        [subject sendCompleted];
        
    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
    
    return subject;
}

+ (RACSignal *)searchUserWithMobile:(NSString *)mobile{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"mobile"] = mobile;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_users_search
                               Parames:para
                             commplete:^(id result,NSInteger statusCode) {
                                 [subject sendNext:result];
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    
    return subject;
}

+ (RACSignal *)singalForResetPasswardWith:(NSString *)phoneNummber passward:(NSString *)passward tmpcode:(NSString *)tmpcode{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"password"] = passward;
    para[@"password_confirmation"] = passward;
    para[@"tmpcode"] = tmpcode;
    
    [YBLRequstTools HTTPPostWithUrl:url_users_phone_password_reset([@"/" stringByAppendingString:phoneNummber])
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              [subject sendNext:@YES];
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

+ (BOOL)getBooleanValueWith:(id)user{
    
    BOOL isExistUser = NO;
    
    if ([user isKindOfClass:[NSArray class]]) {
        if ([user count]==0) {
            isExistUser = NO;
        }
        
    } else if([user isKindOfClass:[NSDictionary class]]){
        if (user !=nil) {

            isExistUser = YES;
        } else {
            isExistUser = NO;
        }
        
    }
    return isExistUser;
}

+ (RACSignal *)siganlForGetStoreInfoWithID:(NSString *)ID{
    
    return [self siganlForGetUserInfosID:ID IsSelf:NO];
}

+ (RACSignal *)siganlForGetUserInfos{
    
    YBLUserModel *user = [YBLUserManageCenter shareInstance].userModel;
    NSString *userinfo_id = user.userinfo_id;
    return [self siganlForGetUserInfosID:userinfo_id IsSelf:YES];
}

+ (RACSignal *)siganlForGetUserInfosID:(NSString *)ID IsSelf:(BOOL)isSelf{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = ID;
    
    [YBLRequstTools HTTPGetDataWithUrl:url_userinfos
                               Parames:para
                             commplete:^(id result, NSInteger statusCode) {
                                 
                                 YBLUserInfoModel *userInfo = [YBLUserInfoModel yy_modelWithJSON:result];
                                 if (kStringIsEmpty(userInfo.nickname)) {
                                     userInfo.nickname = userInfo.weixin.nickname;
                                 }
                                 if (kStringIsEmpty(userInfo.sex)) {
                                     userInfo.sex = userInfo.weixin.sex;
                                 }
                                 if ([userInfo.head_img rangeOfString:@"miss.png"].location != NSNotFound) {
                                     userInfo.head_img = userInfo.weixin.wx_headimgurl;
                                 }
                                 if (isSelf) {
                                     
                                     NSString *selectedValue = userInfo.sex;
                                     NSString *value = nil;
                                     if ([selectedValue isEqualToString:@"man"]) {
                                         value = @"男性";
                                     } else if ([selectedValue isEqualToString:@"woman"]) {
                                         value = @"女性";
                                     } else if ([selectedValue isEqualToString:@"secret"]) {
                                         value = @"保密";
                                     }
                                     userInfo.sex = value;
                                     
                                     [YBLUserManageCenter shareInstance].userInfoModel = userInfo;
                                     
                                 } else {
                                     
                                     [subject sendNext:userInfo];
                                 }
                                 [subject sendCompleted];
                             }
                               failure:^(NSError *error, NSInteger errorCode) {
                                   [subject sendError:error];
                               }];
    
    return subject;
}

+ (RACSignal *)siganlForGetUserInfoIds{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[self searchUserWithMobile:[YBLUserManageCenter shareInstance].userModel.mobile] subscribeNext:^(id  _Nullable x) {
        NSString *infoid = x[@"user"][@"userinfo_id"];;
        if (infoid.length!=0) {
            YBLUserModel *user = [YBLUserManageCenter shareInstance].userModel;
            user.userinfo_id = infoid;
            [YBLUserManageCenter shareInstance].userModel = user;
            [subject sendCompleted];
        }

    } error:^(NSError * _Nullable error) {
        [subject sendError:error];
    }];
 
    return subject;
}



+ (RACSignal *)siganlForUpdateUserIconWithImage:(UIImage *)iconImage
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    NSData *thumbImageData = UIImageJPEGRepresentation(iconImage, .8);
    YBLFileConfig *fileConfig = [YBLFileConfig
                                 fileConfigWithfileData:thumbImageData
                                 name:@"head_img"
                                 fileName:@"head_img"
                                 mimeType:@"image/png"];
    [SVProgressHUD showWithStatus:@"上传中..."];
    [YBLRequstTools updateRequest:url_userinfo_center
                           params:nil
                  fileConfigArray:[@[fileConfig] mutableCopy]
                          success:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"上传成功~"];
                              YBLUserInfoModel *userInfo = [YBLUserInfoModel yy_modelWithJSON:result];
                              [YBLUserManageCenter shareInstance].userInfoModel = userInfo;
                              [subject sendCompleted];
                          }
                          failure:^(NSError *error,NSInteger errorCode) {
                              [subject sendError:error];
                          }];
    
    return subject;
}

+ (RACSignal *)siganlForUpdateUserInfoWithKey:(NSString *)key value:(NSString *)value{
    
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [SVProgressHUD showWithStatus:@"保存中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"key"] = key;
    para[@"value"] = value;
    
    [YBLRequstTools HTTPPostWithUrl:url_userinfo_center
                            Parames:para
                          commplete:^(id result, NSInteger statusCode) {
                              
                              [SVProgressHUD showSuccessWithStatus:@"保存成功~"];
                              
                              YBLUserInfoModel *userInfo = [YBLUserInfoModel yy_modelWithJSON:result];
                              if ([value isEqualToString:@"man"]) {
                                    userInfo.sex = @"男性";
                                } else if ([value isEqualToString:@"woman"]) {
                                    userInfo.sex = @"女性";
                                }  else if ([value isEqualToString:@"secret"]) {
                                    userInfo.sex = @"保密";
                                }
                              [YBLUserManageCenter shareInstance].userInfoModel = userInfo;
                              
                              [subject sendCompleted];
                          }
                            failure:^(NSError *error, NSInteger errorCode) {
                                [subject sendError:error];
                            }];
    
    return subject;
}

@end

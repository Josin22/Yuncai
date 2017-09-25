//
//  YBLUserManageCenter.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLUserModel.h"
#import "YBLUserInfoModel.h"
#import "CoreArchiveHeader.h"
#import "WXUserModel.h"

@interface YBLUserManageCenter : NSObject

+ (instancetype)shareInstance;

////是否已经登录
@property (nonatomic, assign) BOOL             isLoginStatus;
///当前账号类型
@property (nonatomic, assign) UserType         userType;
///认证类型
@property (nonatomic, assign) StoreAuthenType  storeAuthenType;
///审核状态
@property (nonatomic, assign) AasmState        aasmState;
///user
@property (nonatomic, strong) YBLUserModel     *userModel;
///userinfo
@property (nonatomic, strong) YBLUserInfoModel *userInfoModel;
///购物车数量
@property (nonatomic, assign) NSInteger        cartsCount;
///wxuser
@property (nonatomic, strong) WXUserModel      *wxUserModel;
///NetWork Status
@property (nonatomic, assign) BOOL             isNoActiveNetStatus;
///开通类型
@property (nonatomic, assign) OpenCreditType   openCreditType;
///当前用户的开通服务
@property (nonatomic, assign) UserOpenedCreditType userOpenedCreditType;

///注销
+ (void)logout;

@end

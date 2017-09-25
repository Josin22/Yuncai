//
//  YBLUserManageCenter.m
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLUserManageCenter.h"

static NSString *const kUserInfoModel = @"kUserInfoModel";
static NSString *const kUserModel     = @"kUserModel";
static NSString *const kWXUserModel   = @"kWXUserModel";

@implementation YBLUserManageCenter

+ (instancetype)shareInstance {
    static YBLUserManageCenter *YBLUserModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        YBLUserModel = [[YBLUserManageCenter alloc] init];
    });
    return YBLUserModel;
}

- (BOOL)isLoginStatus{
    
    return self.userModel.authentication_token!=nil;
}

- (UserOpenedCreditType)userOpenedCreditType{
   
    UserOpenedCreditType uotp = UserOpenedCreditTypeNone;
    if ([self.userInfoModel.credit isEqualToString:@"china"]) {
        uotp = UserOpenedCreditTypeCredit;
    } else if ([self.userInfoModel.credit isEqualToString:@"member"]){
        uotp = UserOpenedCreditTypeMember;
    }
    return uotp;
}

- (OpenCreditType)openCreditType{
    
    OpenCreditType type_ = OpenCreditTypeCredit;
    if (self.userType == UserTypeSeller) {
        type_ = OpenCreditTypeCredit;
    } else {
        type_ = OpenCreditTypeMember;
    }
    return type_;
}

- (AasmState)aasmState{
    YBLUserInfoModel *userInfoModel = [YBLUserInfoModel readSingleModelForKey:kUserInfoModel];
    AasmState state = AasmStateUnknown;
    if ([userInfoModel.aasm_state isEqualToString:@"initial"]) {
        state = AasmStateInitial;
    } else if ([userInfoModel.aasm_state isEqualToString:@"wait_approve"]) {
        state = AasmStateWaiteApproved;
    } else if ([userInfoModel.aasm_state isEqualToString:@"approved"]) {
        state = AasmStateApproved;
    } else if ([userInfoModel.aasm_state isEqualToString:@"rejected"]) {
        state = AasmStateRejected;
    }
    return state;
}

- (UserType)userType{
    
    YBLUserInfoModel *userInfoModel = [YBLUserInfoModel readSingleModelForKey:kUserInfoModel];
    UserType usertype = UserTypeGuest;
    if ([userInfoModel.user_type isEqualToString:user_type_guest_key]) {
        usertype = UserTypeGuest;
    } else if ([userInfoModel.user_type isEqualToString:user_type_buyer_key]) {
        usertype = UserTypeBuyer;
    } else if ([userInfoModel.user_type isEqualToString:user_type_seller_key]) {
        usertype = UserTypeSeller;
    }
    return usertype;
}

- (void)setWxUserModel:(WXUserModel *)wxUserModel{
    
    [WXUserModel saveSingleModel:wxUserModel forKey:kWXUserModel];
}

- (WXUserModel *)wxUserModel{
    
    WXUserModel *wxuserModel = [WXUserModel readSingleModelForKey:kWXUserModel];
    
    return wxuserModel;
}

- (void)setUserModel:(YBLUserModel *)userModel{
    
    [YBLUserModel saveSingleModel:userModel forKey:kUserModel];
}

- (YBLUserModel *)userModel{
    
    YBLUserModel *userModel = [YBLUserModel readSingleModelForKey:kUserModel];
//    userModel.authentication_token = TToken;
    return userModel;
}
- (void)setUserInfoModel:(YBLUserInfoModel *)userInfoModel{
    
    [YBLUserInfoModel saveSingleModel:userInfoModel forKey:kUserInfoModel];
}

- (YBLUserInfoModel *)userInfoModel{
    
    YBLUserInfoModel *userInfo = [YBLUserInfoModel readSingleModelForKey:kUserInfoModel];
    return userInfo;
    
}
+ (void)logout{

    [YBLUserManageCenter shareInstance].userModel = nil;
    [YBLUserManageCenter shareInstance].userInfoModel = nil;
    [YBLUserManageCenter shareInstance].wxUserModel = nil;
    [YBLUserManageCenter shareInstance].cartsCount = 0;
}

@end

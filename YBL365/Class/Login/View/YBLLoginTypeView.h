//
//  YBLLoginTypeView.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,loginType){
    loginTypeDefault = 0,//默认登陆页面
    loginTypePhoneLost//找回密码页面
};

typedef NS_ENUM(NSInteger,EventType) {
    EventTypeFound = 0,//找回密码点击事件
    EventTypeLogin,//登陆点击事件
    EventTypeCommit,//提交点击事件
    EventTypeBack,//返回事件
    EventTypeSendCode//发送验证码
};

typedef void(^LoginTypeViewBlock)(loginType type,EventType eventType);

@interface YBLLoginTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame Type:(loginType)type;

@property (nonatomic, copy) LoginTypeViewBlock loginTypeViewBlock;

@end

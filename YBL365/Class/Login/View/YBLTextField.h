//
//  YBLTextField.h
//  YBL365
//
//  Created by 乔同新 on 2016/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger,textFieldType) {
    textFieldTypeDefault = 0,//默认普通文本
    textFieldTypeFoundPWD,//文本+找回密码
    textFieldTypeSendCode,//文本+发送验证码
    textFieldTypePhone//特殊手机号
};

typedef void(^TextFieldBlock)(textFieldType type);

@interface YBLTextField : UIView

@property (nonatomic, copy) NSString *currentValue;

@property (nonatomic, copy) NSString *placeholderValue;

@property (nonatomic, copy) TextFieldBlock textFieldBlock;

@property (nonatomic, assign) textFieldType currentType;

@end

//
//  XXTextField.h
//  XXKeyboardAutoPop
//
//  Created by tomxiang on 02/11/2016.
//  Copyright © 2016 tomxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XXTextFieldType){
    XXTextFieldTypeAny = 0,        //没有限制
    XXTextFieldTypeOnlyUnsignInt,  //只允许非负整型
    XXTextFieldTypeOnlyInt,        //只允许整型输入
    XXTextFieldTypeForbidEmoj,     //禁止Emoj表情输入
};

typedef NS_ENUM(NSUInteger, XXTextFieldEvent){
    XXTextFieldEventBegin,         //准备输入文字
    XXTextFieldEventInputChar,     //准备输入字符
    XXTextFieldEventFinish         //输入完成
};

@interface XXTextField : UITextField

/**
 *  如果按了return需要让键盘收起
 */
@property(nonatomic,assign) BOOL isResignKeyboardWhenTapReturn;
/**
 *  输入类型
 */
@property(nonatomic,assign) XXTextFieldType inputType;

/**
 *  最大字符数
 */
@property(nonatomic,assign) NSInteger maxLength;

/**
 *  最大字节数
 */
@property(nonatomic,assign) NSInteger maxBytesLength;
/**
 *  左间距
 */
@property (nonatomic, assign) BOOL isAutoSpaceInLeft;
/**
 *  中文联想，字符改变的整个字符串回调
 */
@property (nonatomic,copy) void (^textFieldChange)(XXTextField *textField, NSString *string);
/**
 *  成功输入一个字符的回调
 */
@property (nonatomic,copy) void (^inputCharacter)(XXTextField *textField, NSString *string);

/**
 *  控件状态变化的事件回调
 */
@property (nonatomic,copy) void (^notifyEvent)(XXTextField *textField, XXTextFieldEvent event);

@end

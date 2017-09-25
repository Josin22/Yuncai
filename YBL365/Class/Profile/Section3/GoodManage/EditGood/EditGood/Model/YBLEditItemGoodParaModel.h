//
//  YBLEditItemGoodParaModel.h
//  YC168
//
//  Created by 乔同新 on 2017/3/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,EditTypeCell) {
    ///只可写
    EditTypeCellOnlyWrite = 0,
    ///只可点击
    EditTypeCellOnlyClick,
    ///可点可击
    EditTypeCellWriteAndClick,
    ///带switch
    EditTypeCellOnlySwith,
    ///带switch可输入
    EditTypeCellSwithWrite,
    ///不可以点击不可以输入
    EditTypeCellNoWriteClick
};

@interface YBLEditItemGoodParaModel : NSObject

@property (nonatomic, copy  ) NSString       *id;
@property (nonatomic, strong) NSString       *name;
/**
 *  首字母
 */
@property (nonatomic, strong) NSString       *initial_text;
@property (nonatomic, strong) NSNumber       *required;
@property (nonatomic, strong) NSNumber       *position;
///custome
//key
@property (nonatomic, copy  ) NSString       *paraString;
//value
@property (nonatomic, copy  ) NSString       *paraValueString;
@property (nonatomic, copy  ) NSString       *title;
@property (nonatomic, copy  ) NSString       *value;
@property (nonatomic, assign) EditTypeCell   editTypeCell;
@property (nonatomic, assign) BOOL           isRequired;
@property (nonatomic, copy  ) NSString       *palachoce;
@property (nonatomic, copy  ) NSString       *placeholder;
@property (nonatomic, copy  ) NSString       *arrow_image;
@property (nonatomic, assign) BOOL           isSwitchOn;
@property (nonatomic, assign) BOOL           isUnsureValue;
@property (nonatomic, strong) id             itemModel;
@property (nonatomic, strong) id             undefineValue;
@property (nonatomic, assign) UIKeyboardType keyboardType;

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                           paraValueString:(NSString *)paraValueString;

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                              keyboardType:(UIKeyboardType)keyboardType;

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                           paraValueString:(NSString *)paraValueString;

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                           paraValueString:(NSString *)paraValueString
                               unfineValue:(id)unfineValue;

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                      type:(EditTypeCell)type
                              keyboardType:(UIKeyboardType)keyboardType
                               placeholder:(NSString *)placeholder;
@end

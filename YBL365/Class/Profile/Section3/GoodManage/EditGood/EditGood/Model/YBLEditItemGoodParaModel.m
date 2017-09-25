//
//  YBLEditItemGoodParaModel.m
//  YC168
//
//  Created by 乔同新 on 2017/3/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditItemGoodParaModel.h"

@implementation YBLEditItemGoodParaModel

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                           paraValueString:(NSString *)paraValueString{
    
    return [self getModelWith:title
                        value:value
                   isRequired:YES
                         type:EditTypeCellOnlyClick
                   paraString:nil
              paraValueString:paraValueString
                 keyboardType:UIKeyboardTypeDefault
                  unfineValue:nil
                  placeholder:nil];
}

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                           paraValueString:(NSString *)paraValueString
                               unfineValue:(id)unfineValue{
    return [self getModelWith:title
                        value:value
                   isRequired:YES
                         type:type
                   paraString:paraString
              paraValueString:paraValueString
                 keyboardType:UIKeyboardTypeDefault
                  unfineValue:unfineValue
                  placeholder:nil];
}

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                           paraValueString:(NSString *)paraValueString{
    return [self getModelWith:title
                        value:value
                   isRequired:YES
                         type:type
                   paraString:paraString
              paraValueString:nil
                 keyboardType:UIKeyboardTypeDefault
                  unfineValue:nil
                  placeholder:nil];
}

+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                      type:(EditTypeCell)type
                              keyboardType:(UIKeyboardType)keyboardType
                               placeholder:(NSString *)placeholder{
    return [self getModelWith:title
                        value:nil
                   isRequired:NO
                         type:type
                   paraString:nil
              paraValueString:nil
                 keyboardType:keyboardType
                  unfineValue:nil
                  placeholder:placeholder];
}


+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                              keyboardType:(UIKeyboardType)keyboardType{
    
    return [self getModelWith:title
                        value:value
                   isRequired:isRequired
                         type:type
                   paraString:paraString
              paraValueString:nil
                 keyboardType:keyboardType
                  unfineValue:nil
                  placeholder:nil];
}


+ (YBLEditItemGoodParaModel *)getModelWith:(NSString *)title
                                     value:(NSString *)value
                                isRequired:(BOOL)isRequired
                                      type:(EditTypeCell)type
                                paraString:(NSString *)paraString
                           paraValueString:(NSString *)paraValueString
                              keyboardType:(UIKeyboardType)keyboardType
                               unfineValue:(id)unfineValue
                               placeholder:(NSString *)placeholder{
    YBLEditItemGoodParaModel *model = [YBLEditItemGoodParaModel new];
    model.title = title;
    model.value = value;
    model.editTypeCell = type;
    model.isRequired = isRequired;
    model.paraString = paraString;
    model.paraValueString = paraValueString;
    model.keyboardType = keyboardType;
    model.undefineValue = unfineValue;
    model.placeholder = placeholder;
    return model;
}



@end

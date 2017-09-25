//
//  ZJSelectedTextField.h
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSinglePickerView.h"
#import "ZJMultiplePickerView.h"
#import "ZJMultipleAssociatedPickerView.h"
#import "ZJDatePickerView.h"
#import "ZJToolBar.h"



typedef void(^CancelHandler)();
typedef void(^SingleDoneBlock)(UITextField *textField,  NSInteger selectedIndex, NSString *selectedValue);
typedef void(^MultipleDoneBlock)(UITextField *textField, NSArray *selectedIndexs, NSArray *selectedValues);
typedef void(^MultipleAssoCiatedDoneBlock)(UITextField *textField, NSArray *selectedValues);
typedef void(^DateDoneBlock)(UITextField *textField, NSDate *selectedDate);

@interface ZJSelectedTextField : UITextField

/** 是否自动设置选中的内容到textField中 -- 默认为NO */
@property (assign, nonatomic)BOOL autoSetSelectedText;

/** 弹出的选择框的高度 -- 默认为260 */
@property (assign, nonatomic)CGFloat pickerViewHeight;

/** 自定义设置toolBar的属性 */
- (void)setupToolBarWithHandler:(void(^)(ZJToolBar *toolBar)) handler;
/**
 *  弹出显示单列数据的pickerView
 *
 *  @param toolBarText   提示文字
 *  @param data          数据 -- 数组(字符串)
 *  @param defaultIndex  默认选中index
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
- (void)showSingleColPickerWithToolBarText:(NSString *)toolBarText withData:(NSArray<NSString *> *)data withDefaultIndex:(NSInteger)defaultIndex withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(SingleDoneBlock)doneHandler;
/**
 *  弹出显示多列不关联数据的pickerView
 *
 *  @param toolBarText   提示文字
 *  @param data          数据 -- 数组 注意格式  @[ @[@"1",...], @[], ... ]
 *  @param defaultIndexs  默认选中indexs
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */

- (void)showMultipleColPickerWithToolBarText:(NSString *)toolBarText withDefaultIndexs: (NSArray *)defaultIndexs withData:(NSArray<NSArray<NSString *> *> *)data withCancelHandler:(CancelHandler)cancelHandler withDoneHandler: (MultipleDoneBlock)doneHandler;
/**
 *  弹出显示多列关联数据的pickerView -- 联动
 *
 *  @param toolBarText   提示文字
 *  @param defaultValues 默认选中的每一列的值-- 注意是相关联的
 *  @param data          数据--- 注意格式
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
- (void)showMultipleAssociatedColPickerWithToolBarText:(NSString *)toolBarText withDefaultValues: (NSArray *)defaultValues withData:(NSArray *)data withCancelHandler:(CancelHandler)cancelHandler withDoneHandler: (MultipleAssoCiatedDoneBlock)doneHandler;

/**
 *  弹出日期选中器
 *
 *  @param toolBarText   提示文字
 *  @param style         定制日期的样式
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
- (void)showDatePickerWithToolBarText:(NSString *)toolBarText withStyle:(ZJDatePickerStyle *)style withCancelHandler:(CancelHandler)cancelHandler withDoneHandler: (DateDoneBlock)doneHandler;

/**
 *  弹出城市选择器-- 数据来自本地的plist 可修改
 *
 *  @param toolBarText           提示文字
 *  @param defaultSelectedValues 默认选中的每一列的值-- 注意是相关联的
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
- (void)showCitiesPickerWithToolBarText:(NSString *)toolBarText withDefaultSelectedValues:(NSArray *)defaultSelectedValues withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(MultipleAssoCiatedDoneBlock)doneHandler;
@end

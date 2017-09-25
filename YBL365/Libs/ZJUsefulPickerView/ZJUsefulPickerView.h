//
//  ZJUsefulPickerView.h
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJSelectedTextField.h"

@interface ZJUsefulPickerView : UIView
@property (nonatomic, copy  ) CancelHandler cancelHandler;
typedef void(^SingleDoneHandler)(NSInteger selectedIndex, NSString *selectedValue);
typedef void(^MultipleDoneHandler)(NSArray *selectedIndexs, NSArray *selectedValues);
typedef void(^MultipleAssoCiatedDoneHandler)(NSArray *selectedValues);
typedef void(^DateDoneHandler)(NSDate *selectedDate);
/** toolBar 可利用下面的方法返回的ZJUsefulPickerView来自定义样式 */
@property (strong, nonatomic, readonly)ZJToolBar *toolBar;
/**
 *  弹出显示单列数据的pickerView
 *
 *  @param toolBarText   提示文字
 *  @param data          数据 -- 数组(字符串)
 *  @param defaultIndex  默认选中index
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
+ (ZJUsefulPickerView *)showSingleColPickerWithToolBarText:(NSString *)toolBarText withData:(NSArray<NSString *> *)data withDefaultIndex:(NSInteger)defaultIndex withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(SingleDoneHandler)doneHandler;

/**
 *  弹出显示多列不关联数据的pickerView
 *
 *  @param toolBarText   提示文字
 *  @param data          数据 -- 数组 注意格式  @[ @[@"1",...], @[], ... ]
 *  @param defaultIndexs  默认选中indexs
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
+ (ZJUsefulPickerView *)showMultipleColPickerWithToolBarText:(NSString *)toolBarText withDefaultIndexs: (NSArray *)defaultIndexs withData:(NSArray<NSArray<NSString *> *> *)data withCancelHandler:(CancelHandler)cancelHandler withDoneHandler: (MultipleDoneHandler)doneHandler;
/**
 *  弹出显示多列关联数据的pickerView -- 联动
 *
 *  @param toolBarText   提示文字
 *  @param defaultValues 默认选中的每一列的值-- 注意是相关联的
 *  @param data          数据--- 注意格式
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
+ (ZJUsefulPickerView *)showMultipleAssociatedColPickerWithToolBarText:(NSString *)toolBarText withDefaultValues: (NSArray *)defaultValues withData:(NSArray *)data withCancelHandler:(CancelHandler)cancelHandler withDoneHandler: (MultipleAssoCiatedDoneHandler)doneHandler;
/**
 *  弹出日期选中器
 *
 *  @param toolBarText   提示文字
 *  @param style         定制日期的样式
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
+ (ZJUsefulPickerView *)showDatePickerWithToolBarText:(NSString *)toolBarText withStyle:(ZJDatePickerStyle *)style withCancelHandler:(CancelHandler)cancelHandler withDoneHandler: (DateDoneHandler)doneHandler;
/**
 *  弹出城市选择器-- 数据来自本地的plist 可修改
 *
 *  @param toolBarText           提示文字
 *  @param defaultSelectedValues 默认选中的每一列的值-- 注意是相关联的
 *  @param cancelHandler 取消操作
 *  @param doneHandler   完成操作
 */
+ (ZJUsefulPickerView *)showCitiesPickerWithToolBarText:(NSString *)toolBarText withDefaultSelectedValues:(NSArray *)defaultSelectedValues withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(MultipleAssoCiatedDoneHandler)doneHandler;
@end

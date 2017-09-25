//
//  ZJSinglePickerView.h
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJToolBar;


@interface ZJSinglePickerView : UIView
typedef void(^SingleDoneHandler)(NSInteger selectedIndex, NSString *selectedValue);
typedef void(^SingleSelectedHandler)(NSString *selectedValue);

typedef void(^BtnAction)();
@property (strong, nonatomic, readonly) ZJToolBar *toolBar;

- (instancetype)initWithToolBarText:(NSString *)toolBarText withDefaultIndex: (NSInteger)defaultIndex withData:(NSArray<NSString *> *)data withValueDidChangedHandler:(SingleSelectedHandler)valueDidChangedHandler cancelAction:(BtnAction)cancelAction doneAction: (SingleDoneHandler)doneAction;
@end

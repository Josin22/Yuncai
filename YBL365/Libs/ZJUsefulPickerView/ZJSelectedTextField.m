//
//  ZJSelectedTextField.m
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJSelectedTextField.h"
typedef UIView *(^SetupPickerViewBlock)();

@interface ZJSelectedTextField ()
@property (copy, nonatomic) SetupPickerViewBlock setupPickerViewBlock;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (copy, nonatomic) void(^setupToolBarBlock)(ZJToolBar *toolBar);
@end

@implementation ZJSelectedTextField
#pragma mark - public use methods
- (void)showSingleColPickerWithToolBarText:(NSString *)toolBarText withData:(NSArray<NSString *> *)data withDefaultIndex:(NSInteger)defaultIndex withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(SingleDoneBlock)doneHandler {
    __weak typeof(self) weakSelf = self;
    self.setupPickerViewBlock = ^UIView * {
        ZJSinglePickerView *single = [[ZJSinglePickerView alloc] initWithToolBarText:toolBarText withDefaultIndex:defaultIndex withData:data withValueDidChangedHandler:^(NSString *selectedValue){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.text = selectedValue;
            }
            
        } cancelAction:^ {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (cancelHandler) {
                    cancelHandler();
                }
                
            }
        } doneAction:^(NSInteger selectedIndex, NSString *selectedValue) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (doneHandler) {
                    doneHandler(strongSelf, selectedIndex, selectedValue);
                }
                
            }
        }] ;
        
        return single;
    };
}

- (void)showMultipleColPickerWithToolBarText:(NSString *)toolBarText withDefaultIndexs:(NSArray *)defaultIndexs withData:(NSArray<NSArray<NSString *> *> *)data withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(MultipleDoneBlock)doneHandler {
    __weak typeof(self) weakSelf = self;
    self.setupPickerViewBlock = ^UIView * {
        ZJMultiplePickerView *multiple = [[ZJMultiplePickerView alloc] initWithToolBarText:toolBarText withDefaultIndexs:defaultIndexs withData:data withValueDidChangedHandler:^(NSArray *selectedValues){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                NSString *tempString = @"";
                for (NSString *value in selectedValues) {
                    tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"  %@",value]];
                }
                strongSelf.text = tempString;
            }
        }cancelAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (cancelHandler) {
                    cancelHandler();
                }
                
            }
        }doneAction:^(NSArray *selectedIndexs, NSArray *selectedValues) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (doneHandler) {
                    doneHandler(strongSelf, selectedIndexs, selectedValues);
                }
                
            }
        }];
        return multiple;
    };
    
}

- (void)showMultipleAssociatedColPickerWithToolBarText:(NSString *)toolBarText withDefaultValues:(NSArray *)defaultValues withData:(NSArray *)data withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(MultipleAssoCiatedDoneBlock)doneHandler {
    __weak typeof(self) weakSelf = self;
    
    self.setupPickerViewBlock = ^UIView * {
        ZJMultipleAssociatedPickerView *multipleAsso = [[ZJMultipleAssociatedPickerView alloc] initWithToolBarText:toolBarText withDefaultValues:defaultValues withData:data withValueDidChangedHandler:^(NSArray *selectedValues){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                NSString *tempString = @"";
                for (NSString *value in selectedValues) {
                    tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"  %@",value]];
                }
                strongSelf.text = tempString;
            }
        } cancelAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (cancelHandler) {
                    cancelHandler();
                }
                
            }
        } doneAction:^(NSArray *selectedValues) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (doneHandler) {
                    doneHandler(strongSelf, selectedValues);
                }
                
            }
        }];
        return multipleAsso;
    };
}

- (void)showDatePickerWithToolBarText:(NSString *)toolBarText withStyle:(ZJDatePickerStyle *)style withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(DateDoneBlock)doneHandler {
    __weak typeof(self) weakSelf = self;
    
    self.setupPickerViewBlock = ^UIView * {
        ZJDatePickerView *dataPicker = [[ZJDatePickerView alloc] initWithToolBarText:toolBarText withStyle:style withValueDidChangedHandler:^(NSDate *selectedDate){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.text = [strongSelf.formatter stringFromDate:selectedDate];
            }
            
        } cancelAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (cancelHandler) {
                    cancelHandler();
                }
                
            }
        }doneAction:^(NSDate *selectedDate) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf endEditing:YES];
                if (doneHandler) {
                    doneHandler(strongSelf, selectedDate);
                }
                
            }
        }];
        return dataPicker;
    };
}

- (void)showCitiesPickerWithToolBarText:(NSString *)toolBarText withDefaultSelectedValues:(NSArray *)defaultSelectedValues withCancelHandler:(CancelHandler)cancelHandler withDoneHandler:(MultipleAssoCiatedDoneBlock)doneHandler {
    NSString *provincePath = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"plist"];
    NSString *areaPath = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
    
    NSArray *provinceArray = [NSArray arrayWithContentsOfFile:provincePath];
    NSDictionary *cityDic = [NSDictionary dictionaryWithContentsOfFile:cityPath];
    NSDictionary *areaDic = [NSDictionary dictionaryWithContentsOfFile:areaPath];
    
    NSArray *dataArray = @[provinceArray, cityDic, areaDic];
    [self showMultipleAssociatedColPickerWithToolBarText:toolBarText withDefaultValues:defaultSelectedValues withData:dataArray withCancelHandler:cancelHandler withDoneHandler:doneHandler];
}

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

/// 从xib/storyboard中初始化时调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _autoSetSelectedText = NO;
    _pickerViewHeight = 260.0f;
    //隐藏输入光标
//    self.tintColor = [UIColor clearColor];
    
    // 注意这里的object设置为self  只监听自己的通知
    NSNotificationCenter *noCenter = [NSNotificationCenter defaultCenter];
    [noCenter addObserver:self selector:@selector(selectedTextFieldDidBeginEdit) name:UITextFieldTextDidBeginEditingNotification object:self];
    [noCenter addObserver:self selector:@selector(selectedTextFieldDidEndEdit) name:UITextFieldTextDidEndEditingNotification object:self];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    NSLog(@"ZJSelectedTextField ===== dealloc");
}

#pragma mark - helper
- (void)setupToolBarWithHandler:(void (^)(ZJToolBar *))handler {
    self.setupToolBarBlock = [handler copy];
}

/// 开始编辑时才添加pickerView
- (void)selectedTextFieldDidBeginEdit {
    if (self.setupPickerViewBlock) {
        
        if (self.setupPickerViewBlock) {

            UIView *pickerView  = self.setupPickerViewBlock();
            pickerView.frame = CGRectMake(0, 0, 0, _pickerViewHeight);
            self.inputView = pickerView;
            
            if (self.setupToolBarBlock) {
                ZJToolBar *toolBar = [self getToolBarFromPickerView:pickerView];
                self.setupToolBarBlock(toolBar);
            }

        }
        
    }
}

- (ZJToolBar *)getToolBarFromPickerView:(UIView *)pickerView {
    if ([pickerView isKindOfClass:[ZJSinglePickerView class]]) {
        return ((ZJSinglePickerView *)pickerView).toolBar;
    }
    else if ([pickerView isKindOfClass:[ZJMultiplePickerView class]]) {
        return ((ZJMultiplePickerView *)pickerView).toolBar;
    }
    else if ([pickerView isKindOfClass:[ZJMultipleAssociatedPickerView class]]) {
        return ((ZJMultipleAssociatedPickerView *)pickerView).toolBar;
    }
    else if ([pickerView isKindOfClass:[ZJDatePickerView class]]) {
        return ((ZJDatePickerView *)pickerView).toolBar;
    }
    else {
        return [ZJToolBar new];
    }

}

/// 编辑完成销毁pickerView
- (void)selectedTextFieldDidEndEdit {
    self.inputView = nil;
}

// 不显示输入光标
- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

/// 这是一个耗时操作...
- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}
@end

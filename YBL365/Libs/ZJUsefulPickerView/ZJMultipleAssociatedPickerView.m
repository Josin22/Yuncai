//
//  ZJMultipleAssociatedPickerView.m
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJMultipleAssociatedPickerView.h"
#import "ZJToolBar.h"
@class ZJToolBar;

extern void ifDebug(dispatch_block_t blcok);

@interface ZJMultipleAssociatedPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource> {
    ZJToolBar *_toolBar;
    NSArray *_data;
    NSMutableArray<NSString *> *_selectedValues;
}

@property (strong, nonatomic) UIPickerView *pickerView;
@property (copy, nonatomic) MultipleAssociatedSelectedHandler valueDidChangeHandler;

@end

@implementation ZJMultipleAssociatedPickerView

#pragma mark - life cycle
- (instancetype)initWithToolBarText:(NSString *)toolBarText withDefaultValues: (NSArray *)defaultValues withData:(NSArray *)data withValueDidChangedHandler:(MultipleAssociatedSelectedHandler)valueDidChangeHandler cancelAction:(BtnAction)cancelAction doneAction: (MultipleAssoCiatedDoneHandler)doneAction {
    if (self = [super init]) {
        if ([self checkData:data] == NO) {
            NSAssert(NO, @"设置的data格式不正确, 初始化失败");
            return nil;
        }
        
        _data = data;
        _valueDidChangeHandler = valueDidChangeHandler;
        __weak typeof(self) weakSelf = self;
        /// 解决循环引用问题
        _toolBar = [[ZJToolBar alloc] initWithToolbarText:toolBarText cancelAction:cancelAction doneAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if (doneAction) {
                    doneAction(strongSelf->_selectedValues);
                }
            }
        }];
        
        [self addSubview:self.pickerView];
        [self addSubview:_toolBar];
        self.backgroundColor = [UIColor whiteColor];

        _selectedValues = [defaultValues mutableCopy];
        if (!_selectedValues || _selectedValues.count == 0) {
            _selectedValues = [NSMutableArray array];
        }
        /// 验证设置的默认值
        [self configDefaultValues];
        // 验证和修改完成
        [self setupSelectedValueDidChanged];
        /// 滚动到指定位置
        [self selectTheDefaultValues];
    }
    
    return self;
}

/// 只会验证第一级的格式是否正确, 并未验证字典内的格式是否正确(否则数据多的时候可能比较慢!!)
- (BOOL)checkData:(NSArray *)data {
    if (data && data.count != 0) {
        __block BOOL isRight = NO;
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0) {
                isRight = [obj isKindOfClass:[NSArray class]];
                if (!isRight) {
                    *stop = YES;
                }
            }
            else {
                isRight = [obj isKindOfClass:[NSDictionary class]];
                if (!isRight) {
                    *stop = YES;
                }
            }
        }];
        return isRight;
    }
    return NO;
}

/// 验证设置的默认值
- (void)configDefaultValues {
    if (_selectedValues.count < _data.count) { // 默认值的个数<列的个数时
        
        ifDebug(^{
            NSLog(@"设置的默认值个数不完整, 未设置的将会默认为0");

        });
        while (_selectedValues.count < _data.count) {// 补全默认值为空
            [_selectedValues addObject:@""];
        }
    }
    else if (_selectedValues.count > _data.count) {// 移除多余的
        ifDebug(^{
            NSLog(@"设置的默认值个数太多, 多余的将会被移除");
        });
        
        NSInteger index = _data.count;
        while (_data.count < _selectedValues.count) {
            [_selectedValues removeObjectAtIndex:index];
        }
    }
    
    NSArray *tempDefaultValues = [_selectedValues copy];
    // 个数相同的时候, 判断每一个下标是否合法
    [tempDefaultValues enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger component, BOOL * _Nonnull stop) {
        
        if (component == 0) { // 数组
            NSArray *tempArray = (NSArray *)_data[0];
            if (![tempArray containsObject:obj]) {
                ifDebug(^{
                    NSLog(@"%@", [NSString stringWithFormat:@"设置的第%lu列默认值不合法, 将会被设置为第一个元素", component+1]);
                });
                // 如果这一列设置的默认值不存在
                [_selectedValues replaceObjectAtIndex:0 withObject:tempArray[0]];
                
            }
            
        }
        else { // 字典
            NSDictionary *tempDic = (NSDictionary *)_data[component];
            NSString *key = _selectedValues[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key]; //  上一列选中值对应的这一列的数据
            if (![titlesArray containsObject:obj]) {
                ifDebug(^{
                    NSLog(@"%@", [NSString stringWithFormat:@"设置的第%lu列默认值不合法, 将会被设置为第一个元素", component+1]);
                });

                if (titlesArray && titlesArray.count != 0) {
                    // 如果这一列设置的默认值不存在
                    [_selectedValues replaceObjectAtIndex:component withObject:titlesArray[0]];
                }
                
            }
            
        }
        
    }];
    
    
}

/// 滚动到指定位置
- (void)selectTheDefaultValues {
    [_selectedValues enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger component, BOOL * _Nonnull stop) {
        
        NSInteger row = 0;
        if (component == 0) {
            NSArray *tempArray = (NSArray *)_data[0];
            row = [tempArray indexOfObject:obj];
        }
        else {
            NSDictionary *tempDic = (NSDictionary *)_data[component];
            NSString *key = _selectedValues[component-1];//上一列选中值
            NSArray *titlesArray = tempDic[key];
            if (titlesArray && titlesArray.count != 0) {
                row = [titlesArray indexOfObject:obj];
            }
        }
        [self.pickerView selectRow:row inComponent:component animated:NO];
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat kToolBarHeight = 44.0f;
    
    
    NSLayoutConstraint *toolBarLeft = [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *toolBarRight = [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f];
    
    NSLayoutConstraint *toolBarHeight = [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kToolBarHeight];
    NSLayoutConstraint *toolBarTop = [NSLayoutConstraint constraintWithItem:_toolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f];
    _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[toolBarLeft, toolBarRight, toolBarHeight, toolBarTop]];
    
    NSLayoutConstraint *pickerViewLeft = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *pickerViewRight = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f];
    
    NSLayoutConstraint *pickerViewHeight = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bounds.size.height - kToolBarHeight];
    NSLayoutConstraint *pickerViewBottom = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0f];
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[pickerViewLeft, pickerViewRight, pickerViewHeight, pickerViewBottom]];
}

- (void)dealloc {
//    NSLog(@"ZJMultipleAssociatedPickerView ===== dealloc");
}

- (void)setupSelectedValueDidChanged {
    if (_valueDidChangeHandler) {
        _valueDidChangeHandler(_selectedValues);
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        NSArray *tempArray = (NSArray *)_data[0];
        if (tempArray) {
            return tempArray.count;
        }
        return 0;
    }
    else {
        NSDictionary *tempDic = (NSDictionary *)_data[component];
        NSString *key = _selectedValues[component-1];//上一列选中值
        NSArray *titlesArray = tempDic[key];
        if (titlesArray) {
            return titlesArray.count;
        }
        return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {

        NSArray *tempArray = (NSArray *)_data[0];
        [_selectedValues replaceObjectAtIndex:component withObject:tempArray[row]];
    }
    else {

        NSDictionary *tempDic = (NSDictionary *)_data[component];
        NSString *key = _selectedValues[component-1];//上一列选中值
        NSArray *titlesArray = tempDic[key];
        //修改本列选中值
        if (titlesArray && titlesArray.count != 0) { // 判断是否为0个元素, 是因为递归的时候 row = 0(越界)
            [_selectedValues replaceObjectAtIndex:component withObject:titlesArray[row]];
        }
        else {// 说明当前选中的这一列没有下一列的关联数据, 将之后的全部设置为空
            NSInteger index = component;
            for (; index < _selectedValues.count; index++) {
                [_selectedValues replaceObjectAtIndex:component withObject:@""];

            }
        }

    }
    
    if (component < _data.count-1) {
        [pickerView reloadComponent:component+1];
        // 递归刷新下一列的数据
        [self pickerView:pickerView didSelectRow:0 inComponent:component+1];
        // 设置选中第一个
        [pickerView selectRow:0 inComponent:component+1 animated:YES];
    }
    else {
        // 递归结束, 发布通知
        [self setupSelectedValueDidChanged];
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    NSString *title = @"";
    if (component == 0) {//数组
        NSArray *tempArray = (NSArray *)_data[0];
        title = tempArray[row];
    }
    else {//字典
        NSDictionary *tempDic = (NSDictionary *)_data[component];
        NSString *key = _selectedValues[component-1];//上一列选中值
        NSArray *titlesArray = tempDic[key];
        if (titlesArray && titlesArray.count != 0) {// 如果对应的值存在, 并且不为空
            title = titlesArray[row];
        }

    }
    label.text = title;
    return label;
}


- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
    }
    
    return _pickerView;
}


@end

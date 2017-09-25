//
//  ZJMultiplePickerView.m
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJMultiplePickerView.h"
#import "ZJToolBar.h"
extern void ifDebug(dispatch_block_t blcok);
@interface ZJMultiplePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) ZJToolBar *toolBar;
@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *data;
@property (strong, nonatomic) NSMutableArray *selectedIndexs;
@property (strong, nonatomic) NSArray *selectedValues;
@property (copy, nonatomic) MultipleSelectedHandler valueDidChangeHandler;

@end

@implementation ZJMultiplePickerView

#pragma mark - life cycle
- (instancetype)initWithToolBarText:(NSString *)toolBarText withDefaultIndexs: (NSArray *)defaultIndexs withData:(NSArray<NSArray<NSString *> *> *)data withValueDidChangedHandler:(MultipleSelectedHandler)valueDidChangeHandler cancelAction:(BtnAction)cancelAction doneAction: (MultipleDoneHandler)doneAction {
    if (self = [super init]) {
        
        if ([self checkData:data] == NO) {
            NSAssert(NO, @"设置的数据格式不正确, 初始化失败");
            return nil;
        }
        
        _data = data;
        _valueDidChangeHandler = valueDidChangeHandler;
        __weak typeof(self) weakSelf = self;

        _toolBar = [[ZJToolBar alloc] initWithToolbarText:toolBarText cancelAction:cancelAction doneAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if (doneAction) {
                    doneAction(strongSelf.selectedIndexs, strongSelf.selectedValues);
                }
            }
        }];
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.pickerView];
        [self addSubview:_toolBar];
        
        _selectedIndexs = [defaultIndexs mutableCopy];

        if (_selectedIndexs == nil || _selectedIndexs.count == 0) {
            // 如果没有指定默认值, 就全部设置为0
            _selectedIndexs = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                [_selectedIndexs addObject:@0];
            }
        }
        /// 设置默认值
        [self congifTheDefaultValues];
        
        /// 验证完毕, 默认选中值改变
        [self setupSelectedValueDidChanged];
        /// 滚动到指定位置
        [self selectTheDefaultValues];
    }
    
    return self;
}

- (BOOL)checkData:(NSArray *)data {
    BOOL isRight = NO;
    if (data && [data isKindOfClass:[NSArray class]]) {
        for (id object in data) {
            if ([object isKindOfClass:[NSArray class]]) {
                isRight = YES;
            }
        }
    }
    
    return isRight;
}
/// 设置默认值
- (void)congifTheDefaultValues {
    if (_selectedIndexs.count < _data.count) { // 默认值的个数<列的个数时
        ifDebug(^{
            NSLog(@"设置的默认下标个数不完整, 未设置的将会默认为0");
        });
        while (_selectedIndexs.count < _data.count) {// 补全默认值得个数
            [_selectedIndexs addObject:@0];
        }
    }
    else if (_selectedIndexs.count > _data.count) {// 移除多余的
        ifDebug(^{
            NSLog(@"设置的默认下标个数太多, 多余的将会被移除");
        });
        
        NSInteger index = _data.count;
        while (_data.count < _selectedIndexs.count) {
            [_selectedIndexs removeObjectAtIndex:index];
        }
    }
    
    NSArray *tempDefaultIndexs = [_selectedIndexs copy];
    // 现在个数已经相同, 判断每一个下标是否合法
    [tempDefaultIndexs enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        
        NSInteger defaultIndex = [obj integerValue];
        
        NSArray *values = _data[index];
        
        if (defaultIndex < 0 || defaultIndex >= values.count) {
            // 对应列的下标设置不合法
            //NSAssert(NO, assert);
            ifDebug(^{
                NSLog(@"%@", [NSString stringWithFormat:@"设置的第%ld列下标不合法, 将会被设置为0", (unsigned long)index]);
            });
            
            // 重置为0
            [_selectedIndexs replaceObjectAtIndex:index withObject:@0];
            
        }
        
    }];

}
/// 滚动到指定位置
- (void)selectTheDefaultValues {
    [_selectedIndexs enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger component, BOOL * _Nonnull stop) {
        NSInteger row = [obj integerValue];
        [self.pickerView selectRow:row inComponent:component animated:NO];
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat kToolBarHeight = 44.0f;
    
    
    NSLayoutConstraint *toolBarLeft = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *toolBarRight = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f];
    
    NSLayoutConstraint *toolBarHeight = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kToolBarHeight];
    NSLayoutConstraint *toolBarTop = [NSLayoutConstraint constraintWithItem:self.toolBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[toolBarLeft, toolBarRight, toolBarHeight, toolBarTop]];
    
    NSLayoutConstraint *pickerViewLeft = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *pickerViewRight = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f];
    
    NSLayoutConstraint *pickerViewHeight = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.bounds.size.height - kToolBarHeight];
    NSLayoutConstraint *pickerViewBottom = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0f];
    self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[pickerViewLeft, pickerViewRight, pickerViewHeight, pickerViewBottom]];
}
- (void)dealloc {
//    NSLog(@"ZJMultiplePickerView ===== dealloc");
}

- (void)setupSelectedValueDidChanged {
    if (_valueDidChangeHandler) {
        _valueDidChangeHandler(self.selectedValues);
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _data.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _data[component].count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // 设置选中下标
    [_selectedIndexs replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    [self setupSelectedValueDidChanged];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = _data[component][row];
    return label;
}


- (NSArray *)selectedValues {
    NSMutableArray *array = [NSMutableArray array];
    [_selectedIndexs enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
        
        NSInteger defaultIndex = [obj integerValue];
        NSArray *values = _data[index];
        
        [array addObject:values[defaultIndex]];
        
    }];
    return array;
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

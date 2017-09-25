//
//  ZJSinglePickerView.m
//  ZJUsefulPickerView
//
//  Created by ZeroJ on 16/9/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJSinglePickerView.h"
#import "ZJToolBar.h"
extern void ifDebug(dispatch_block_t blcok);
@interface ZJSinglePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) ZJToolBar *toolBar;
@property (strong, nonatomic) NSArray<NSString *> *data;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) NSString *selectedValue;
@property (copy, nonatomic) SingleSelectedHandler selectedValuedChangeHandler;


@end

@implementation ZJSinglePickerView

#pragma mark - life cycle
- (instancetype)initWithToolBarText:(NSString *)toolBarText withDefaultIndex: (NSInteger)defaultIndex withData:(NSArray<NSString *> *)data withValueDidChangedHandler:(SingleSelectedHandler)valueDidChangedHandler cancelAction:(BtnAction)cancelAction doneAction: (SingleDoneHandler)doneAction {
    if (self = [super init]) {
        
        if (!data || ![data isKindOfClass:[NSArray class]]) {
            ifDebug(^{
                NSAssert(NO, @"设置的数据格式不正确, 初始化失败");
            });

            return nil;
        }
        
        _data = data;
        _selectedValuedChangeHandler = [valueDidChangedHandler copy];

        if (defaultIndex < 0 || defaultIndex >= data.count) {
            ifDebug(^{
                NSLog(@"设置的默认下标不合法, 将被设置为0");
            });
            defaultIndex = 0;
        }
        _selectedIndex = defaultIndex;

        /// 验证完毕, 选择值改变
        [self setupSelectedValueDidChanged];
        
        __weak typeof(self) weakSelf = self;
        
        _toolBar = [[ZJToolBar alloc] initWithToolbarText:toolBarText cancelAction:cancelAction doneAction:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if (doneAction) {
                    doneAction(strongSelf.selectedIndex, strongSelf.selectedValue);
                }
            }
        }];
        /// 滚动到默认的位置
        [self.pickerView selectRow:_selectedIndex inComponent:0 animated:NO];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pickerView];
        [self addSubview:_toolBar];
    }
    
    return self;
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
//    NSLog(@"ZJSinglePickerView ===== dealloc");
}



- (void)setupSelectedValueDidChanged {
    if (_selectedValuedChangeHandler) {
        _selectedValuedChangeHandler(self.selectedValue);
    }
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedIndex = row;
    [self setupSelectedValueDidChanged];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = self.data[row];
    return label;
}

#pragma mark - setter getter
- (NSString *)selectedValue {
    if (_selectedIndex >= 0 && _selectedIndex < self.data.count) {
        _selectedValue = self.data[_selectedIndex];
    }
    return _selectedValue;
}

- (NSArray<NSString *> *)data {
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
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

//
//  YBLAddSubtractView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddSubtractView.h"

@interface YBLAddSubtractView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *subtractButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UITextField *numberTT;

@property (nonatomic, assign) IntegerOrFloatType integerOrFloatType;

@end

@implementation YBLAddSubtractView

- (instancetype)initWithFrame:(CGRect)frame integerOrFloatType:(IntegerOrFloatType)integerOrFloatType{

    self = [super initWithFrame:frame];
    if (self) {
        
        _integerOrFloatType = integerOrFloatType;
        
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame integerOrFloatType:IntegerOrFloatTypeInteger];
}

- (void)createUI{
    
    WEAK
    CGRect newFrame = [self frame];
    CGFloat selfHei =newFrame.size.height;
    CGFloat selfWi =newFrame.size.width;
    newFrame.size.height = selfHei<=27?27:selfHei;
    newFrame.size.width = selfWi<=87?87:selfWi;
    self.frame = newFrame;
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nononon)];
    [bgView addGestureRecognizer:tap];
    
    self.subtractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subtractButton.frame = CGRectMake(0, 0, self.height+3, self.height);
    [self.subtractButton setImage:[UIImage imageNamed:@"jdm_btn_reduceCount"] forState:UIControlStateNormal];
    [bgView addSubview:self.subtractButton];

    self.numberTT = [[UITextField alloc]init];
    self.numberTT.frame = CGRectMake(self.subtractButton.right, self.subtractButton.top, self.width-self.subtractButton.width*2, self.height);
    self.numberTT.textColor = BlackTextColor;
    self.numberTT.delegate = self;
    self.numberTT.borderStyle = UITextBorderStyleNone;
    self.numberTT.textAlignment=NSTextAlignmentCenter;
    self.numberTT.layer.borderColor = YBLColor(200, 200, 200, 1.0).CGColor;
    self.numberTT.layer.borderWidth = 0.5;
    self.numberTT.font= YBLFont(13);
    [bgView addSubview:self.numberTT];
    if (_integerOrFloatType == IntegerOrFloatTypeFloat) {
        self.numberTT.text = [NSString stringWithFormat:@"%.2f",_currentFloat];
        self.numberTT.keyboardType=UIKeyboardTypeDecimalPad;
    } else {
        self.numberTT.text = [NSString stringWithFormat:@"%ld",(long)_currentCount];
        self.numberTT.keyboardType=UIKeyboardTypeNumberPad;
    }
   
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.frame = CGRectMake(self.numberTT.right, self.numberTT.top, self.subtractButton.width, self.height);
    [self.addButton setImage:[UIImage imageNamed:@"jdm_btn_addCount"] forState:UIControlStateNormal];
    [bgView addSubview:self.addButton];
    /*加*/
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        if (_integerOrFloatType == IntegerOrFloatTypeFloat) {
            self.currentFloat += 0.1;
        } else {
            self.currentCount++;
        }
        [self handleCurrentCount:YES];
//      BLOCK_EXEC(self.currentCountChangeBlock,self.currentCount);
    }];
    
    /*减*/
    [[self.subtractButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        if (_integerOrFloatType == IntegerOrFloatTypeFloat) {
            self.currentFloat -= 0.1;
        } else {
            self.currentCount--;
        }
        [self handleCurrentCount:YES];
    }];

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numberTT] subscribeNext:^(NSNotification *x) {
        STRONG
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        if (_integerOrFloatType == IntegerOrFloatTypeFloat) {
            
            if (text.floatValue<self.minFloat) {
                self.currentFloat = 0;
            } else {
                self.currentFloat = text.floatValue;
            }
            self.numberTT.text = [NSString stringWithFormat:@"%.2f",self.currentFloat];
            
        } else {
//            NSInteger count = 0;
            if (text.integerValue>self.maxCount&&self.maxCount!=0) {
                NSLog(@"_____________超拉!");
                self.currentCount = self.maxCount;
                self.numberTT.text = [NSString stringWithFormat:@"%ld",(long)self.maxCount];
//                count = self.maxCount;
            } else if (text.integerValue<self.minCount){
                self.numberTT.text = [NSString stringWithFormat:@"%ld",(long)self.minCount];
//                count = self.minCount;
//                self.currentCount = count;
            } else {
                self.currentCount = text.integerValue;
//                count = text.integerValue;
            }
            
        }
        [self handleCurrentCount:NO];
//        BLOCK_EXEC(self.currentCountChangeBlock,count);
    }];
    
    /* 捆绑加减的enable */
   
    if (_integerOrFloatType == IntegerOrFloatTypeFloat) {
        
        RACSignal *currenValueSignal = RACObserve(self, currentFloat);
        
        RAC(self.subtractButton,enabled)  = [RACSignal combineLatest:@[currenValueSignal]
                                                              reduce:^id (NSNumber *num){
                                                                  return @(num.floatValue>self.minFloat);
                                                              }];
        RAC(self.addButton,enabled)  = [RACSignal combineLatest:@[currenValueSignal]
                                                         reduce:^id (NSNumber *num){
                                                             return @(num.floatValue<self.maxFloat);
                                                         }];
        
    } else {
        
        RACSignal *currenCountSignal = RACObserve(self, currentCount);
        
        RAC(self.subtractButton,enabled)  = [RACSignal combineLatest:@[currenCountSignal]
                                                              reduce:^id (NSNumber *num){
                                                                  return @(num.integerValue>self.minCount);
                                                              }];

        RAC(self.addButton,enabled)  = [RACSignal combineLatest:@[currenCountSignal]
                                                         reduce:^id (NSNumber *num){
                                                             return @(num.integerValue<self.maxCount);
                                                         }];
    }
}

- (void)handleCurrentCount:(BOOL)isClickButton{
    
    if (_integerOrFloatType == IntegerOrFloatTypeFloat) {
        BLOCK_EXEC(self.currentFloatChangeBlock,self.currentFloat,self,isClickButton);
    } else {
        self.isEnableButton = NO;
        BLOCK_EXEC(self.currentCountChangeBlock,self.currentCount,self,isClickButton);
    }
}

- (void)nononon{
    
}

#pragma mark -  setting count

- (void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    if (_maxCount <= 0) {
        self.numberTT.textColor = YBLThemeColor;
    } else {
        self.numberTT.textColor = BlackTextColor;
    }
}

- (void)setCurrentCount:(NSInteger)currentCount{
    _currentCount = currentCount;
    self.numberTT.text = [NSString stringWithFormat:@"%ld",(long)_currentCount];
}

- (void)setIsEnableButton:(BOOL)isEnableButton{
    _isEnableButton = isEnableButton;
    self.subtractButton.userInteractionEnabled = _isEnableButton;
    self.addButton.userInteractionEnabled = _isEnableButton;
}

#pragma mark -  setting float

- (void)setMaxFloat:(float)maxFloat{
    _maxFloat = maxFloat;
    if (_maxFloat <= 0) {
        self.numberTT.textColor = YBLThemeColor;
    } else {
        self.numberTT.textColor = BlackTextColor;
    }
}

- (void)setCurrentFloat:(float)currentFloat{
    _currentFloat = currentFloat;
    self.numberTT.text = [NSString stringWithFormat:@"%.2f",_currentFloat];
}


@end

//
//  YBLOrderMMFilterContentView.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMFilterContentView.h"

static NSInteger button_tag = 97979;

static YBLOrderMMFilterContentView *contentView = nil;

@interface YBLOrderMMFilterContentView ()
{
    CGFloat valueHi;
}
@property (nonatomic, weak  ) UIViewController *vc;
@property (nonatomic, copy  ) ContentSelectblock block;
@property (nonatomic, assign) ContentType type;
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) UIView *valueView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *resetButton;

@end

@implementation YBLOrderMMFilterContentView


+ (void)showOrderMMFilterContentViewInVC:(UIViewController *)vc
                              valueArray:(NSArray *)array
                             ContentType:(ContentType)type
                             compeletion:(ContentSelectblock)block{
    if (!contentView) {
        contentView = [[YBLOrderMMFilterContentView alloc] initWithFrame:CGRectMake(0, 64+40, YBLWindowWidth, YBLWindowHeight-64-40) InVC:vc valueArray:array Type:type compeletion:block];
    }
    contentView.backgroundColor = [UIColor clearColor];
    [vc.view addSubview:contentView];
    
    [contentView addSubviewsFromArray:array Type:type];
    
    [contentView showValueView];
}


- (instancetype)initWithFrame:(CGRect)frame InVC:(UIViewController *)vc valueArray:(NSArray *)array Type:(ContentType)type compeletion:(ContentSelectblock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _vc = vc;
        _array = array;
        _type = type;
        _block = block;
        
        [self createFilterUI];
    }
    return self;
}

- (void)addSubviewsFromArray:(NSArray *)array Type:(ContentType)type{
    
    NSInteger lie = 4;
    CGFloat itemWi = self.width/lie;
    CGFloat xp = 3;
    
    if (type == ContentTypeSequence) {
        lie = 1;
        itemWi = self.width;
        xp = 1;
    }
    
    NSInteger count = array.count;
    CGFloat maigin = 10;
    CGFloat itemHi = 20;
    
    CGFloat buttonW = 40;
    
    NSInteger row = count/lie;
    
    valueHi = (row+1)*(maigin+itemHi)+maigin*xp+buttonW;
    
    self.valueView.frame = CGRectMake(0, -valueHi, self.width, valueHi);
    
    NSInteger index=  0;
    
    for (int i = 0; i < _array.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:button_tag+i];
        [button removeFromSuperview];
    }
    
    for (NSString *value in array) {
        
        NSInteger row = index/lie;
        NSInteger col = index%lie;
        
        CGRect frame = CGRectMake(col*(itemWi), row*(itemHi+maigin)+maigin*2, itemWi, itemHi);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [button setTitle:value forState:UIControlStateNormal];
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:YBLThemeColor forState:UIControlStateSelected];
        button.titleLabel.font = YBLFont(15);
        button.tag = button_tag+index;
        [self.valueView addSubview:button];
        
        index++;
    }

    self.lineView.frame = CGRectMake(0, self.valueView.height-buttonW, self.width, 0.5);
    self.resetButton.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.lineView.width/2, buttonW);
    self.sureButton.frame = CGRectMake(CGRectGetMaxX(self.resetButton.frame), CGRectGetMaxY(self.lineView.frame)-0.5, self.lineView.width/2, buttonW);
}

- (void)createFilterUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = BlackTextColor;
    bgView.alpha = 0;
    [self addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContentView)];
    [bgView addGestureRecognizer:tap];
    
    self.bgView = bgView;
    
   
    UIView *valueView = [[UIView alloc] init];
    valueView.backgroundColor = [UIColor whiteColor];
    [self addSubview:valueView];
    self.valueView = valueView;
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YBLLineColor;
    [self.valueView addSubview:lineView];
    self.lineView = lineView;
    
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
    resetButton.titleLabel.font = YBLFont(16);
    [resetButton addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.valueView addSubview:resetButton];
    self.resetButton = resetButton;
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.titleLabel.font = YBLFont(16);
    [sureButton setBackgroundColor:YBLThemeColor];
    [sureButton addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.valueView addSubview:sureButton];
    self.sureButton = sureButton;
    
}

- (void)resetClick:(UIButton *)btn{
    [self dismissContentView];
}

- (void)sureClick:(UIButton *)btn{
    [self dismissContentView];
}

- (void)showValueView{
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bgView.alpha = 0.6;
                         self.valueView.top = 0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

    
}

- (void)dismissContentView{
    
    [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bgView.alpha = 0;
                         self.valueView.top = -valueHi-40;
                     }
                     completion:^(BOOL finished) {
                         
                         [contentView removeFromSuperview];
                     }];
}

@end

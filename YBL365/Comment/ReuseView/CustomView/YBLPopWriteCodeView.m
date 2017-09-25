//
//  YBLPopWriteCodeView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPopWriteCodeView.h"
#import "YBLPasswordView.h"

static YBLPopWriteCodeView *popWriteCodeView = nil;

@interface YBLPopWriteCodeView()

@property (nonatomic, strong) NSString *currentText;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *submitBUtton;

@property (nonatomic, copy  ) PopWriteCodeViewSureBlock popWriteCodeViewSureBlock;

@end

@implementation YBLPopWriteCodeView

+ (void)showPopWriteCodeViewWithPopWriteCodeViewSureBlock:(PopWriteCodeViewSureBlock)block{
 
    if (!popWriteCodeView) {
        popWriteCodeView = [[YBLPopWriteCodeView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) PopWriteCodeViewSureBlock:block];
        
        popWriteCodeView.contentView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:.75 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            popWriteCodeView.contentView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            popWriteCodeView.backgroundColor = YBLColor(0, 0, 0, 0.5);
        } completion:nil];
        
        [[UIApplication sharedApplication].keyWindow addSubview:popWriteCodeView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame PopWriteCodeViewSureBlock:(PopWriteCodeViewSureBlock)block{
    
    self = [super initWithFrame:frame];
    if (self) {

        _popWriteCodeViewSureBlock = block;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.backgroundColor = YBLColor(0, 0, 0, 0);
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width-60, (self.width-60)*0.5)];
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    contentView.center = self.center;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    CGFloat buttonHi = buttonHeight;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, 30)];
    label.text = @"请输入提货码";
    label.font =YBLFont(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = YBLColor(70, 70, 70, 1.0);
    [contentView addSubview:label];
    
    CGFloat lessHi = contentView.height-buttonHi-label.bottom;
    
    YBLPasswordView *passwordOne = [[YBLPasswordView alloc]initWithFrame:CGRectMake(space, 0, contentView.width-2*space, buttonHi)];
    passwordOne.centerY = label.bottom+lessHi/2;
    passwordOne.passwordViewTextChangeBlock = ^(NSString *text,BOOL isDone){
        [self endEditing:YES];
        self.currentText = text;
        self.submitBUtton.enabled = isDone;
    };
    [contentView addSubview:passwordOne];
    [passwordOne becomFirespone];
    
    UIButton *dimissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dimissButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
    [dimissButton setTitle:@"取消" forState:UIControlStateNormal];
    dimissButton.backgroundColor = [UIColor whiteColor];
    dimissButton.titleLabel.font = YBLFont(17);
    dimissButton.frame = CGRectMake(0, contentView.height - buttonHi, contentView.width/2, buttonHi);
    [contentView addSubview:dimissButton];
    
    [[dimissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.contentView.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            self.backgroundColor = YBLColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            [popWriteCodeView removeFromSuperview];
            popWriteCodeView = nil;

        }];
    }];
    
    
    UIButton *submitBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBUtton setTitleColor:YBLColor(150, 150, 150, 1) forState:UIControlStateDisabled];
    [submitBUtton setBackgroundColor:YBLColor(210, 210, 210, 1) forState:UIControlStateDisabled];
    [submitBUtton setBackgroundColor:YBL_RED forState:UIControlStateNormal];
    [submitBUtton setTitle:@"确定" forState:UIControlStateNormal];
    submitBUtton.titleLabel.font = YBLFont(17);
    submitBUtton.frame = CGRectMake(dimissButton.right, contentView.height - buttonHi, contentView.width/2, buttonHi);
    [contentView addSubview:submitBUtton];
    self.submitBUtton = submitBUtton;
    [[submitBUtton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.contentView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 delay:0.2 usingSpringWithDamping:.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
            self.backgroundColor = YBLColor(0, 0, 0, 0);
        } completion:^(BOOL finished) {
            [popWriteCodeView removeFromSuperview];
            popWriteCodeView = nil;
         
            BLOCK_EXEC(self.popWriteCodeViewSureBlock,self.currentText);
        }];
    }];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.height - buttonHi, self.width, 0.5)];
    lineView.backgroundColor = YBLColor(230, 230, 230, 1.0);
    [contentView addSubview:lineView];
}

@end

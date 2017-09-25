//
//  YBLPasswordView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPasswordView.h"

#define kDotSize CGSizeMake (20, 20) //密码点的大小
#define kDotCount 6  //密码个数

@interface YBLPasswordView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

@property (nonatomic, assign) PasswordSecretShowType passwordSecretShowType;

@end

@implementation YBLPasswordView

- (instancetype)initWithFrame:(CGRect)frame passwordSecretShowType:(PasswordSecretShowType)passwordSecretShowType{
    
    self = [super initWithFrame:frame];
    if (self) {
        _passwordSecretShowType = passwordSecretShowType;
        self.backgroundColor = [UIColor whiteColor];
        [self initPwdTextField];
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame passwordSecretShowType:PasswordSecretShowTypeHidden];
}

- (void)becomFirespone{
    
    [self.textField becomeFirstResponder];
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = self.frame.size.width / kDotCount;
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        //生成分割线
        if (i < (kDotCount-1)) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, 0, 0.5, self.height)];
            lineView.backgroundColor = YBLColor(230, 230, 230, 1);
            [self addSubview:lineView];
        }
        UILabel *dotView = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = BlackTextColor;
        dotView.centerX = i*width+(width/2);
        dotView.centerY = self.height/2;
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
     
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
//    BLOCK_EXEC(self.passwordViewTextChangeBlock,textField.text,NO);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    NSInteger index = textField.text.length;
    for (int i = 0; i < textField.text.length; i++) {
        UILabel *dotView = ((UILabel *)[self.dotArray objectAtIndex:i]);
        dotView.hidden = NO;
    }
    if (index!=0) {
        UILabel *dotView = ((UILabel *)[self.dotArray objectAtIndex:index-1]);
        dotView.transform = CGAffineTransformScale(dotView.transform, 0.001, 0.001);
        [UIView animateWithDuration:.2f
                              delay:0
             usingSpringWithDamping:.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             dotView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    
    }
        if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕");
        BLOCK_EXEC(self.passwordViewTextChangeBlock,textField.text,YES);
    }
}

#pragma mark - init

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.layer.cornerRadius = 3;
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = YBLColor(210, 210, 210, 1).CGColor;
        _textField.layer.borderWidth = 0.8;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return _textField;
}

@end

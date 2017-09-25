//
//  YBLWriteTextView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWriteTextView.h"
#import "YBLlimmitTextView.h"

static YBLWriteTextView *writeView = nil;

@interface YBLWriteTextView()

@property (nonatomic, copy  ) WriteTextViewTextBlock block;

@property (nonatomic, assign) NSInteger limmetLength;

@property (nonatomic, weak  ) UIViewController *vc;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) YBLlimmitTextView  *limmitTextView;

@property (nonatomic, copy  ) NSString *currentText;

@end

@implementation YBLWriteTextView

+ (void)showWriteTextViewOnView:(UIViewController *)vc
                    currentText:(NSString *)currentText
               LimmitTextLength:(NSInteger)limmetLength
                   completetion:(WriteTextViewTextBlock)block{
    if (!writeView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        writeView = [[YBLWriteTextView alloc] initWithFrame:[keyWindow bounds]
                                                     OnView:vc
                                                currentText:currentText
                                           LimmitTextLength:limmetLength
                                               completetion:block];
        [keyWindow addSubview:writeView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                       OnView:(UIViewController *)vc
                  currentText:(NSString *)currentText
             LimmitTextLength:(NSInteger)limmetLength
                 completetion:(WriteTextViewTextBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _vc = vc;
        _limmetLength = limmetLength;
        _currentText = currentText;
        _block = block;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    
    CGFloat contentHi = 80+buttonHeight;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, contentHi)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    [YBLMethodTools addTopShadowToView:self.contentView];
    
    self.limmitTextView = [[YBLlimmitTextView alloc] initWithFrame:CGRectMake(0, 0, contentView.width, contentHi-buttonHeight)];
    self.limmitTextView.limmteTextLength = self.limmetLength;
    self.limmitTextView.text = _currentText;
    self.limmitTextView.layer.borderColor = YBLLineColor.CGColor;
    self.limmitTextView.layer.borderWidth = .5;
    self.limmitTextView.font = YBLFont(15);
    [self.limmitTextView becomeFirstResponder];
    [self.contentView addSubview:self.limmitTextView];
    
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    saveButton.titleLabel.font = YBLFont(15);
    saveButton.frame = CGRectMake(0, self.limmitTextView.bottom, self.contentView.width, buttonHeight);
    [self.contentView addSubview:saveButton];
    [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismiss];
        [self endEditing:YES];
        BLOCK_EXEC(self.block,self.limmitTextView.text);
    }];
    
    /* begain animation */
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
                         self.contentView.top = self.height-contentHi;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         self.contentView.top = self.height;
                     }
                     completion:^(BOOL finished) {
                         [writeView removeFromSuperview];
                         writeView = nil;
                     }];

}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.contentView.top = YBLWindowHeight-height-self.contentView.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    //获取键盘的高度
    self.contentView.top = YBLWindowHeight-self.contentView.height;
}

@end

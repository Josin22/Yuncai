//
//  YBLForgotPswViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLForgotPswViewController.h"
//#import "YBLPicVeriticateView.h"
#import "YBLFastRegisterSetPswViewController.h"
#import "YBLCountDownButton.h"
#import "YBLLoginViewModel.h"
#import <ShareSDK/SSDKUser.h>

@interface YBLForgotPswViewController ()

//@property (nonatomic, strong) NSString *codeString;

@property (nonatomic, strong) UITextField *accountTextField;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) YBLCountDownButton *countDownButton;

@property (nonatomic, strong) NSMutableArray *cacheCodeArray;

@end

@implementation YBLForgotPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.wx_user) {
        self.title = @"绑定手机";
    } else {
        self.title = @"找回密码";
    }
 
    [self createUI];
}

- (NSMutableArray *)cacheCodeArray{
    if (!_cacheCodeArray) {
        _cacheCodeArray  = [NSMutableArray array];
    }
    return _cacheCodeArray;
}


- (void)createUI{
    
    CGFloat upSpace = 50;
    CGFloat viewHi = 40;
    
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(2*space, upSpace, YBLWindowWidth-4*space, viewHi+0.5)];
    accountView.backgroundColor = [UIColor whiteColor];
    accountView.layer.cornerRadius = 3;
    accountView.layer.masksToBounds = YES;
    [self.view addSubview:accountView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 40, viewHi)];
    accountLabel.text = @"账号";
    accountLabel.textColor = YBLColor(70, 70, 70, 1);;
    accountLabel.font = YBLFont(14);
    accountLabel.textAlignment = NSTextAlignmentLeft;
    [accountView addSubview:accountLabel];
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(accountLabel.right, accountLabel.top, accountView.width-accountLabel.right-space, viewHi)];
    accountTextField.borderStyle = UITextBorderStyleNone;
    accountTextField.font = YBLFont(16);
    accountTextField.placeholder = @"手机号";
    accountTextField.keyboardType = UIKeyboardTypePhonePad;
    accountTextField.textColor = YBLColor(40, 40, 40, 1);;
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [accountTextField becomeFirstResponder];
    [accountView addSubview:accountTextField];
    self.accountTextField = accountTextField;
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(accountView.left, accountView.bottom+space, (accountView.width-space)*3/5, viewHi)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    textFieldView.layer.masksToBounds = YES;
    textFieldView.layer.cornerRadius = 3;
    [self.view addSubview:textFieldView];
    UITextField *codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(space, 0, textFieldView.width-2*space, textFieldView.height)];
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.font = YBLFont(16);
    codeTextField.textColor = YBLColor(40, 40, 40, 1);;
    codeTextField.borderStyle = UITextBorderStyleNone;
    [textFieldView addSubview:codeTextField];
    self.codeTextField = codeTextField;
    WEAK
    YBLCountDownButton *countDownButton = [[YBLCountDownButton alloc] initWithFrame:CGRectMake(textFieldView.right+space, textFieldView.top,self.view.width-(textFieldView.right+space)-2*space, textFieldView.height)];
    countDownButton.layer.masksToBounds = YES;
    countDownButton.layer.cornerRadius = 3;
    countDownButton.timeCount = 60;
    [[countDownButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self requsetCode];
    }];
    [self.view addSubview:countDownButton];
    self.countDownButton = countDownButton;
    
    /*
    UIView *veriticateView = [[UIView alloc] initWithFrame:CGRectMake(accountView.left, accountView.bottom+space, accountView.width, accountView.height)];
    veriticateView.backgroundColor = [UIColor whiteColor];
    veriticateView.layer.cornerRadius = 3;
    veriticateView.layer.masksToBounds = YES;
    veriticateView.clipsToBounds = YES;
    [self.view addSubview:veriticateView];
    
    UITextField *veriticateTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(space, 0, veriticateView.width-space*3-80, veriticateView.height)];
    veriticateTextFeild.placeholder = @"请输入验证码";
    veriticateTextFeild.borderStyle = UITextBorderStyleNone;
    veriticateTextFeild.font = YBLFont(16);
    veriticateTextFeild.textColor = YBLColor(40, 40, 40, 1);;
    veriticateTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    [veriticateView addSubview:veriticateTextFeild];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(veriticateTextFeild.width-0.5, 4, 0.5, veriticateTextFeild.height-8)];
    lineView.backgroundColor = YBLLineColor;
    [veriticateTextFeild addSubview:lineView];
    
    self.picVeriticateView = [[YBLPicVeriticateView alloc] initWithFrame:CGRectMake(veriticateTextFeild.right+space, -1, 80, veriticateView.height)];
    [veriticateView addSubview:self.picVeriticateView];
     */
    
    UIButton *nextButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(textFieldView.left, textFieldView.bottom+space*2, self.view.width-textFieldView.left*2, textFieldView.height)];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
//        if (![self.codeTextField.text]) {
        if (![self.cacheCodeArray containsObject:self.codeTextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误~"];
            return ;
        }
        if (self.wx_user) {
            [SVProgressHUD showWithStatus:@"加载中..."];
            //手机号注册绑定微信
            [[YBLLoginViewModel singalForUserCheckHasWXIDSearchWith:self.accountTextField.text] subscribeNext:^(NSNumber*  _Nullable x) {
                if (x.boolValue) {
                    //为空==>>绑定
                    [[YBLLoginViewModel singalForWXLogin:self.wx_user mobile:self.accountTextField.text tempCode:self.codeTextField.text] subscribeNext:^(id  _Nullable x) {
                        
                        [YBLMethodTools dismissViewControllerToRoot:self];
                        
                    } error:^(NSError * _Nullable error) {
                    }];
                    
                } else {
                    //非空===>>该手机号已绑定微信
                    [SVProgressHUD showErrorWithStatus:@"该手机号已绑定微信~"];
                    return ;
                }
            }];

        } else {
            YBLFastRegisterSetPswViewController *SetPswViewController = [[YBLFastRegisterSetPswViewController alloc] initPushPswTypeType:PushPswTypeForgotPsw];
            SetPswViewController.phoneNummber = self.accountTextField.text;
            SetPswViewController.tmpcode = self.codeTextField.text;
            [self.navigationController pushViewController:SetPswViewController animated:YES];
        }

    }];
    [self.view addSubview:nextButton];
    
    /* rac */
    RAC(nextButton,enabled) = [RACSignal combineLatest:@[self.accountTextField.rac_textSignal,
                                                         self.codeTextField.rac_textSignal]
                                                reduce:^(NSString *account,NSString *code){
                                                    return @(account.length>0&&code.length>=4);
                                                }];
}

- (void)requsetCode{
    
    WEAK
    [[YBLLoginViewModel singalForVerifyCodeWith:self.accountTextField.text] subscribeNext:^(NSDictionary *x) {
        STRONG
        NSString *message = x[@"message"];
        NSString *codeString = x[@"code"];
        [self.cacheCodeArray addObject:codeString];
        [self.countDownButton begainCountDown];
        [SVProgressHUD showSuccessWithStatus:message];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    } error:^(NSError *error) {
        
    }];
    
}

@end

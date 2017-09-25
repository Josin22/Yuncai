//
//  YBLFastRegisterMassageValiateViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFastRegisterMassageValiateViewController.h"
#import "YBLCountDownButton.h"
#import "YBLFastRegisterSetPswViewController.h"
#import "YBLLoginViewModel.h"

@interface YBLFastRegisterMassageValiateViewController ()

//@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) PushType type;

@property (nonatomic, strong) YBLCountDownButton *countDownButton;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) NSMutableArray *cacheCodeArray;

@end

@implementation YBLFastRegisterMassageValiateViewController

- (instancetype)initPushType:(PushType)type{
    
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == PushTypeFastRegister) {
        self.title = @"手机快速注册";
    } else {
        self.title = @"找回密码";
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createUI];
    
    [self requsetCode];
//    self.code = 0000;
}

- (NSMutableArray *)cacheCodeArray{
    if (!_cacheCodeArray) {
        _cacheCodeArray  = [NSMutableArray array];
    }
    return _cacheCodeArray;
}

- (void)requsetCode{
    
    WEAK
    [[YBLLoginViewModel singalForVerifyCodeWith:self.phoneNummber] subscribeNext:^(NSDictionary *x) {
        STRONG
        NSString *message = x[@"message"];
        NSString *codeString = x[@"code"];
        [self.countDownButton begainCountDown];
        [self.cacheCodeArray addObject:codeString];
//        self.code = codeString.integerValue;
        [SVProgressHUD showSuccessWithStatus:message];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        
    } error:^(NSError *error) {
        
    }];
    
}

- (void)createUI{
    
    CGFloat upSpace = 50;
    CGFloat viewHi = 40;
    
    UILabel *phoneInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*space, upSpace-20, YBLWindowWidth-4*space, 20)];
    phoneInfoLabel.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码",self.phoneNummber];
    phoneInfoLabel.font = YBLFont(12);
    phoneInfoLabel.textColor = YBLColor(70, 70, 70, 1);;
    [self.view addSubview:phoneInfoLabel];
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(phoneInfoLabel.left, phoneInfoLabel.bottom+space, (phoneInfoLabel.width-space)*3/5, viewHi)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    textFieldView.layer.masksToBounds = YES;
    textFieldView.layer.cornerRadius = 3;
    [self.view addSubview:textFieldView];
    UITextField *codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(space, 0, textFieldView.width-2*space, textFieldView.height)];
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.font = YBLFont(16);
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.textColor = YBLColor(40, 40, 40, 1);;
    [codeTextField becomeFirstResponder];
    codeTextField.borderStyle = UITextBorderStyleNone;
    [textFieldView addSubview:codeTextField];
    self.codeTextField = codeTextField;
    WEAK
    YBLCountDownButton *countDownButton = [[YBLCountDownButton alloc] initWithFrame:CGRectMake(textFieldView.right+space, textFieldView.top,(phoneInfoLabel.width-space)*2/5, textFieldView.height)];
    countDownButton.layer.masksToBounds = YES;
    countDownButton.layer.cornerRadius = 3;
    countDownButton.timeCount = 60;
    [[countDownButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self requsetCode];
    }];
  
    [self.view addSubview:countDownButton];
    self.countDownButton = countDownButton;
    
    UIButton *nextButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(textFieldView.left,textFieldView.bottom+viewHi, phoneInfoLabel.width, viewHi)];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 3;
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self.view endEditing:YES];
//        if (self.codeTextField.text.integerValue!=self.code) {
        if (![self.cacheCodeArray containsObject:self.codeTextField.text]) {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            return ;
        }
        PushPswType pushPswType;
        if (_type == PushTypeFastRegister) {
            pushPswType = PushPswTypeFastRegister;
            
        } else {
            pushPswType = PushPswTypeForgotPsw;
        }
        YBLFastRegisterSetPswViewController *SetPswViewController = [[YBLFastRegisterSetPswViewController alloc] initPushPswTypeType:pushPswType];
        SetPswViewController.phoneNummber = self.phoneNummber;
        SetPswViewController.tmpcode = [NSString stringWithFormat:@"%@",@(self.codeTextField.text.integerValue)];
        [self.navigationController pushViewController:SetPswViewController animated:YES];
    }];
    [self.view addSubview:nextButton];
    
    UIButton *contactButton = [YBLMethodTools getContactKefuButtonWithFrame:CGRectMake(nextButton.left, nextButton.bottom+space, nextButton.width, 15)];
    [[contactButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [YBLMethodTools callWithNumber:Service_PhoneCall];
    }];
    [self.view addSubview:contactButton];
    
    /* rac */
    
    RAC(nextButton,enabled) = [RACSignal combineLatest:@[codeTextField.rac_textSignal]
                                                reduce:^(NSString *code){
                                                    return @(code.length>=4);
                                                }];
    
    
}



@end

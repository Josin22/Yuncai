//
//  YBLLoginViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLoginViewController.h"
#import "YBLForgotPswViewController.h"
#import "YBLFastRegisterViewController.h"
#import "YBLLoginViewModel.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface YBLLoginViewController ()

@property (nonatomic, strong) YBLButton *wxButton;

@end

@implementation YBLLoginViewController

- (YBLButton *)wxButton{
    
    if (!_wxButton) {
        YBLButton *wxButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        wxButton.frame = CGRectMake(0, 0, 100, 100);
        wxButton.centerX = self.view.width/2;
        wxButton.top = YBLWindowHeight;
        [wxButton setImage:[UIImage imageNamed:@"wechat_normal"] forState:UIControlStateNormal];
        [wxButton setImage:[UIImage imageNamed:@"wechat_highlight"] forState:UIControlStateHighlighted];
        [wxButton setTitle:@"微信登录" forState:UIControlStateNormal];
        wxButton.imageRect = CGRectMake((100-50)/2, 20, 50, 50);
        wxButton.titleRect = CGRectMake(0, 70, 100, 30);
        [wxButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        wxButton.titleLabel.font = YBLFont(13);
        wxButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [wxButton addTarget:self action:@selector(wxLogin:) forControlEvents:UIControlEventTouchUpInside];
        _wxButton = wxButton;
    }
    return _wxButton;
}

- (void)wxLogin:(UIButton *)btn{
    WEAK
    [SVProgressHUD showWithStatus:@"加载中..."];
    [ShareSDK authorize:SSDKPlatformTypeWechat
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
             STRONG
             if (state == SSDKResponseStateCancel) {
                 [SVProgressHUD showErrorWithStatus:@"已取消~"];
                 return ;
             }
             ///1.查询微信是否已绑定
             [[YBLLoginViewModel singalForWXSearchWith:user.uid] subscribeNext:^(NSNumber *x) {
                 STRONG
                 if (x.boolValue) {
                     ///已绑定--->登录
                     [[YBLLoginViewModel singalForWXLogin:user
                                                  mobile:nil
                                                password:nil] subscribeNext:^(NSNumber *x) {
                         STRONG
                         if (x.boolValue) {
                             [self goback];
                         }
                         [SVProgressHUD dismiss];
                     } error:^(NSError *error) {}];
                 } else {
                     ///2.若无绑定注册--->去注册
                     [SVProgressHUD dismiss];
                     YBLForgotPswViewController *fastRegisterVC = [YBLForgotPswViewController new];
                     fastRegisterVC.wx_user = user;
                     [self.navigationController pushViewController:fastRegisterVC animated:YES];
                 }
             } error:^(NSError *error) {}];
         }];

}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]){
        [UIView animateWithDuration:.4f
                              delay:0
             usingSpringWithDamping:.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.wxButton.top = YBLWindowHeight-self.wxButton.height*2;
                         }
                         completion:^(BOOL finished) {
                             
                         }];

    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"云采登录";
    
    [self.navigationController.navigationBar hiddenLineView];
    
    self.view.backgroundColor = YBLColor(252, 252, 252, 1);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage newImageWithNamed:@"login_close" size:CGSizeMake(26, 26)] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    backItem.tintColor = YBLTextColor;
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self createUI];
    
    [self.view addSubview:self.wxButton];
}

- (void)goback{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)createUI{
    
    CGFloat upSpace = 50;
    CGFloat viewHi = 40;
    /* 账户 */
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, upSpace, YBLWindowWidth, viewHi+0.5)];
    [self.view addSubview:accountView];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(space*2, 0, 40, viewHi)];
    accountLabel.text = @"账号";
    accountLabel.textColor = YBLColor(70, 70, 70, 1);;
    accountLabel.font = YBLFont(14);
    accountLabel.textAlignment = NSTextAlignmentLeft;
    [accountView addSubview:accountLabel];
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(accountLabel.right, accountLabel.top, accountView.width-accountLabel.right-space, viewHi)];
    accountTextField.borderStyle = UITextBorderStyleNone;
    accountTextField.font = YBLFont(16);
    accountTextField.placeholder = @"请输入手机号";
    accountTextField.keyboardType = UIKeyboardTypePhonePad;
    accountTextField.textColor = YBLColor(40, 40, 40, 1);;
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [accountView addSubview:accountTextField];
    
    UIView *accountLineView = [[UIView alloc] initWithFrame:CGRectMake(accountLabel.left, accountTextField.bottom, YBLWindowWidth-4*space, 0.5)];
    accountLineView.backgroundColor = YBLLineColor;
    [accountView addSubview:accountLineView];
    
    /* 密码 */
    UIView *pswView = [[UIView alloc] initWithFrame:CGRectMake(0, accountView.bottom, YBLWindowWidth, viewHi+0.5)];
    [self.view addSubview:pswView];
    
    UILabel *pswLabel = [[UILabel alloc] initWithFrame:CGRectMake(space*2, 0, 40, viewHi)];
    pswLabel.text = @"密码";
    pswLabel.textColor = YBLColor(70, 70, 70, 1);;
    pswLabel.font = YBLFont(14);
    pswLabel.textAlignment = NSTextAlignmentLeft;
    [pswView addSubview:pswLabel];
    
    UITextField *pswTextField = [[UITextField alloc] initWithFrame:CGRectMake(pswLabel.right, pswLabel.top, pswView.width-pswLabel.right-space, pswView.height)];
    pswTextField.borderStyle = UITextBorderStyleNone;
    pswTextField.font = YBLFont(16);
    pswTextField.placeholder = @"请输入密码";
    pswTextField.secureTextEntry = YES;
    pswTextField.textColor = YBLColor(40, 40, 40, 1);;
    pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [pswView addSubview:pswTextField];
    
    UIView *pswLineView = [[UIView alloc] initWithFrame:CGRectMake(pswLabel.left, pswTextField.bottom, YBLWindowWidth-4*space, 0.5)];
    pswLineView.backgroundColor = YBLLineColor;
    [pswView addSubview:pswLineView];
    
    /* 登录 */
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(2*space, pswView.bottom+2*space, YBLWindowWidth-4*space, viewHi);
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 3;
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateDisabled];
    loginButton.titleLabel.font = YBLFont(16);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:YBLColor(212, 212, 212, 1) forState:UIControlStateDisabled];
    [loginButton setBackgroundColor:YBLThemeColor forState:UIControlStateNormal];
    [loginButton setBackgroundColor:YBLColor(238, 238, 238, 1) forState:UIControlStateDisabled];
    WEAK
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        WXUserModel *wxModel = [WXUserModel new];
        wxModel.mobile = accountTextField.text;
        wxModel.password = pswTextField.text;
        [[YBLLoginViewModel singalForLogin:wxModel] subscribeNext:^(NSNumber *x) {
            STRONG
            if (x.boolValue) {
                [self goback];
            } 
        } error:^(NSError *error) {
            
        }];
    }];
    [self.view addSubview:loginButton];
    
    /* fastRegister / forgot psw */
    UIButton *fastRegisterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fastRegisterButton.frame = CGRectMake(loginButton.left, loginButton.bottom+2*space, loginButton.width/2, 15);
    [fastRegisterButton setTitle:@"手机快速注册" forState:UIControlStateNormal];
    fastRegisterButton.titleLabel.font = YBLFont(12);
    fastRegisterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fastRegisterButton setTitleColor:YBLColor(106, 106, 106, 1) forState:UIControlStateNormal];
    [[fastRegisterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        YBLFastRegisterViewController *fastRegisterVC = [YBLFastRegisterViewController new];
        
        [self.navigationController pushViewController:fastRegisterVC animated:YES];
    }];
    [self.view addSubview:fastRegisterButton];
    
    UIButton *forgotpswButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgotpswButton.frame = CGRectMake(fastRegisterButton.right, fastRegisterButton.top, fastRegisterButton.width, fastRegisterButton.height);
    [forgotpswButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgotpswButton.titleLabel.font = YBLFont(12);
    forgotpswButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgotpswButton setTitleColor:YBLColor(106, 106, 106, 1) forState:UIControlStateNormal];
    [[forgotpswButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        YBLForgotPswViewController *forgotVC = [YBLForgotPswViewController new];
        [self.navigationController pushViewController:forgotVC animated:YES];
    }];
    [self.view addSubview:forgotpswButton];

    
    /* RAC  */
    RAC(loginButton,enabled) = [RACSignal combineLatest:@[accountTextField.rac_textSignal,
                                                          pswTextField.rac_textSignal]
                                                 reduce:^(NSString *username,
                                                          NSString *passwold){
                                                      return @(username.length>=1&&passwold.length>=1);
                                                 }];
}


@end

//
//  YBLFastRegisterSetPswViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFastRegisterSetPswViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "YBLLoginViewModel.h"

@interface YBLFastRegisterSetPswViewController ()

@property (nonatomic, assign) PushPswType type;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) UITextField *firstTetxField;

@end

@implementation YBLFastRegisterSetPswViewController

- (instancetype)initPushPswTypeType:(PushPswType)type{
    
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == PushPswTypeFastRegister) {
        self.title = @"手机快速注册";
    } else {
        self.title = @"找回密码";
    }
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatUI];
}

- (void)creatUI{
    
    CGFloat upSpace = 50;
    CGFloat viewHi = 40;
    
    self.isShow = YES;
    
    UILabel *setpswLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*space, upSpace-20, YBLWindowWidth-4*space, 20)];
    setpswLabel.text = @"请设置登录密码";
    setpswLabel.font = YBLFont(12);
    setpswLabel.textColor = YBLColor(70, 70, 70, 1);
    [self.view addSubview:setpswLabel];
    
    UIView *firstPswTextFieldView = [[UIView alloc] initWithFrame:CGRectMake(setpswLabel.left, setpswLabel.bottom+space, setpswLabel.width, viewHi)];
    firstPswTextFieldView.layer.masksToBounds = YES;
    firstPswTextFieldView.layer.cornerRadius = 3;
    firstPswTextFieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstPswTextFieldView];
    UITextField *firstTetxField = [[UITextField alloc] initWithFrame:CGRectMake(space, 0, firstPswTextFieldView.width-2*space, firstPswTextFieldView.height)];
    firstTetxField.placeholder = @"请输入6-20位密码";
    firstTetxField.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstTetxField.font = YBLFont(16);
    [firstTetxField becomeFirstResponder];
    firstTetxField.textColor = YBLColor(40, 40, 40, 1);
    firstTetxField.borderStyle = UITextBorderStyleNone;
    [firstPswTextFieldView addSubview:firstTetxField];
    self.firstTetxField = firstTetxField;
    
    WEAK
    
    YBLButton *pswShowButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    [pswShowButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [pswShowButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [pswShowButton setTitle:@"密码可见" forState:UIControlStateNormal];
    pswShowButton.titleLabel.font = YBLFont(13);
    pswShowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [pswShowButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
    [pswShowButton setTitleRect:CGRectMake(15+3, 0, 80-15-3, 20)];
    pswShowButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [pswShowButton setImageRect:CGRectMake(0, 2.5, 15, 15)];
    pswShowButton.selected = self.isShow;
    pswShowButton.frame = CGRectMake(firstPswTextFieldView.left, firstPswTextFieldView.bottom+space, 80, 20);
   
    [self.view addSubview:pswShowButton];
    
    
    UILabel *setpswAgainLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*space, pswShowButton.bottom+space, YBLWindowWidth-4*space, 20)];
    setpswAgainLabel.text = @"请再次输入登录密码";
    setpswAgainLabel.font = YBLFont(12);
    setpswAgainLabel.textColor = YBLColor(70, 70, 70, 1);;
    [self.view addSubview:setpswAgainLabel];
    
    UIView *secondPswTextFieldView = [[UIView alloc] initWithFrame:CGRectMake(setpswAgainLabel.left, setpswAgainLabel.bottom+space, setpswAgainLabel.width, viewHi)];
    secondPswTextFieldView.backgroundColor = [UIColor whiteColor];
    secondPswTextFieldView.layer.masksToBounds = YES;
    secondPswTextFieldView.layer.cornerRadius = 3;
    [self.view addSubview:secondPswTextFieldView];
    UITextField *secondTetxField = [[UITextField alloc] initWithFrame:CGRectMake(space, 0, secondPswTextFieldView.width-2*space, secondPswTextFieldView.height)];
    secondTetxField.placeholder = @"请输入6-20位密码";
    secondTetxField.clearButtonMode = UITextFieldViewModeWhileEditing;
    secondTetxField.font = YBLFont(16);
    secondTetxField.textColor = YBLColor(40, 40, 40, 1);
    secondTetxField.borderStyle = UITextBorderStyleNone;
    [secondPswTextFieldView addSubview:secondTetxField];
    
    [[pswShowButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        self.isShow = !self.isShow;
        pswShowButton.selected = self.isShow;
        firstTetxField.secureTextEntry = !self.isShow;
        secondTetxField.secureTextEntry = !self.isShow;
    }];
    
    UIButton *doneButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(secondPswTextFieldView.left, secondPswTextFieldView.bottom+space*2, secondPswTextFieldView.width, secondPswTextFieldView.height)];
    doneButton.layer.masksToBounds = YES;
    doneButton.layer.cornerRadius = 3;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateDisabled];
    [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        if (_type == PushPswTypeFastRegister) {
            [SVProgressHUD showWithStatus:@"加载中..."];
            [[YBLLoginViewModel singalForUserSearchWith:self.phoneNummber] subscribeNext:^(NSNumber*  _Nullable x) {
                STRONG
                if (!x.boolValue) {
                    //可以注册
                    [[YBLLoginViewModel singalForWXLogin:nil mobile:self.phoneNummber password:self.firstTetxField.text] subscribeNext:^(id  _Nullable x) {
                        STRONG
                        [SVProgressHUD showSuccessWithStatus:@"注册成功~"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [YBLMethodTools dismissViewControllerToRoot:self];
                        });
                        
                    } error:^(NSError * _Nullable error) {
                        
                    }];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"该手机号已注册!"];
                }
                
            } error:^(NSError * _Nullable error) {
                
            }];
            /*
            //绑定微信
            [ShareSDK authorize:SSDKPlatformTypeWechat
                       settings:nil
                 onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                     STRONG
                     [SVProgressHUD showWithStatus:@"注册中..."];
                     ///1.查询微信是否已绑定
                     [[YBLLoginViewModel singalForWXSearchWith:user.uid] subscribeNext:^(NSNumber *x) {
                         if (x.boolValue) {
                             [SVProgressHUD showErrorWithStatus:@"此微信号已绑定"];
                             
                         } else {
                             ///2.若无绑定注册
                             [[YBLLoginViewModel singalForWXLogin:user mobile:self.phoneNummber password:self.firstTetxField.text] subscribeNext:^(NSNumber *x) {
                                 if (x.boolValue) {
                                     [SVProgressHUD showSuccessWithStatus:@"注册成功~"];
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         UIViewController *rootVC = self.navigationController.viewControllers[0];
                                         [rootVC dismissViewControllerAnimated:YES completion:nil];
                                     });
                                     
                                 }
                             } error:^(NSError *error) {
                                 
                             }];
                         }
                     } error:^(NSError *error) {
                         
                     }];
                    
                     
                 }];
             */
        } else {
            ///重置密码
            [[YBLLoginViewModel singalForResetPasswardWith:self.phoneNummber
                                                 passward:self.firstTetxField.text
                                                   tmpcode:self.tmpcode] subscribeNext:^(NSNumber *x) {
                if (x.boolValue) {
                    [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });;

                } else {
                   [SVProgressHUD showSuccessWithStatus:@"密码设置失败"];
                }
            } error:^(NSError *error) {
                
            }];
        }
        
    }];
    [self.view addSubview:doneButton];
    
    UIButton *contactButton = [YBLMethodTools getContactKefuButtonWithFrame:CGRectMake(doneButton.left, doneButton.bottom+space, doneButton.width, 20)];
    [[contactButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [YBLMethodTools callWithNumber:Service_PhoneCall];
    }];
    [self.view addSubview:contactButton];
    
    if (_type == PushPswTypeForgotPsw) {
        
        setpswLabel.text = @"请填写新的登录密码";
        firstTetxField.placeholder = @"新密码";
        setpswAgainLabel.text = @"请确认两次填写的登录密码一致";
        secondTetxField.placeholder = @"确认密码";
        setpswAgainLabel.top = firstPswTextFieldView.bottom+space;
        secondPswTextFieldView.top = setpswAgainLabel.bottom+space;
        pswShowButton.top = secondPswTextFieldView.bottom+space;
    }
    
    
    /*rac*/
    RAC(doneButton,enabled) = [RACSignal combineLatest:@[firstTetxField.rac_textSignal,
                                                         secondTetxField.rac_textSignal]
                                                reduce:^(NSString *firstString,NSString *secondString){
//                                                    if (_type == PushPswTypeFastRegister) {
//                                                          return @([firstString isEqualToString:secondString]&&firstString.length>=6&&firstString.length<=20&&secondString.length>=6&&secondString.length<=20);
//                                                    } else {
//                                                          return @(firstString.length>0&&secondString.length>=6);
//                                                    }
                                                  return @([firstString isEqualToString:secondString]&&firstString.length>=6&&firstString.length<=20&&secondString.length>=6&&secondString.length<=20);
                                                }];
}



@end

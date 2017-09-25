//
//  YBLSettingWithdrawalPswViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSettingWithdrawalPswViewController.h"
#import "YBLPasswordView.h"
#import "YBLTheResultViewController.h"
#import "YBLUserInfosParaModel.h"

@interface YBLSettingWithdrawalPswViewController ()
{
    NSString *currentText;
    NSString *finalText;
}
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) YBLPasswordView *passwordOne;
@property (nonatomic, strong) YBLPasswordView *passwordTwo;
@end

@implementation YBLSettingWithdrawalPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置提现密码";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
}

- (void)createUI{
    
    CGFloat itemHi = 60;
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    [self.view addSubview:firstView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space*2, firstView.width-2*space, 20)];
    topLabel.text = @"请设置提现密码,建议与银行卡取款密码相同";
    topLabel.textColor = YBLTextColor;
    topLabel.font = YBLFont(16);
    [firstView addSubview:topLabel];
    
    YBLPasswordView *passwordOne = [[YBLPasswordView alloc]initWithFrame:CGRectMake(space, space*2+topLabel.bottom, firstView.width-2*space, itemHi)];
    passwordOne.passwordViewTextChangeBlock = ^(NSString *text,BOOL isDone){
        currentText = text;
        if (isDone) {
            [self.view endEditing:YES];
            [UIView animateWithDuration:.4f
                             animations:^{
                                 firstView.left = -self.view.width;
                                 self.secondView.left = 0;
                             }
                             completion:^(BOOL finished) {
                                 [self.passwordTwo becomFirespone];
                             }];
        }
    };
    [firstView addSubview:passwordOne];
    [passwordOne becomFirespone];
    self.passwordOne = passwordOne;
    
    
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(firstView.right, 0, firstView.width, firstView.width)];
    [self.view addSubview:secondView];
    self.secondView = secondView;
    
    UILabel *topLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(space, space*2, firstView.width-2*space, 20)];
    topLabel1.text = @"请再次填写已确认";
    topLabel1.textColor = YBLTextColor;
    topLabel1.font = YBLFont(16);
    [secondView addSubview:topLabel1];
    
    YBLPasswordView *passwordTwo = [[YBLPasswordView alloc]initWithFrame:CGRectMake(space, space*2+topLabel1.bottom, secondView.width-2*space, itemHi)];
    passwordTwo.passwordViewTextChangeBlock = ^(NSString *text,BOOL isDone){
        if (isDone) {
            [self.view endEditing:YES];
        }
        finalText = text;
        self.nextButton.hidden = !isDone;
    };
    [secondView addSubview:passwordTwo];
    self.passwordTwo = passwordTwo;
    
    UIButton *nextButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(passwordTwo.left, passwordTwo.bottom+2*space, passwordTwo.width, 45)];
    [secondView addSubview:nextButton];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([currentText isEqualToString:finalText]) {
            
            self.userInfosParModel.pickuppassword = currentText;
            
            [self requestBank];

        } else {
            [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致,请重试"];
            [UIView animateWithDuration:.4f
                             animations:^{
                                 firstView.left = 0;
                                 secondView.left = self.view.width;
                             }
                             completion:^(BOOL finished) {
                                 [self.passwordOne becomFirespone];
                             }];
        }

    }];
    nextButton.hidden = YES;
    self.nextButton = nextButton;
}

- (void)requestBank{
    
    [SVProgressHUD showWithStatus:@"注册申请中..."];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"acct_name"] = self.userInfosParModel.acct_name;
    para[@"acct_pan"] = self.userInfosParModel.acct_pan;
    para[@"bankname"] = self.userInfosParModel.bankname;
    para[@"cert_id"] = self.userInfosParModel.cert_id;
    para[@"phone_num"] = self.userInfosParModel.phone_num;
    para[@"pickuppassword"] = self.userInfosParModel.pickuppassword;
    
    [YBLRequstTools HTTPPostWithUrl:url_setuserinfobank
                            Parames:para
                          commplete:^(id result,NSInteger statusCode) {
                              [SVProgressHUD showSuccessWithStatus:@"注册申请成功~"];
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                  [self.navigationController pushViewController:[YBLTheResultViewController new] animated:YES];
                              });
                              
                          }
                            failure:^(NSError *error,NSInteger errorCode) {
                                
                            }];
    
}

@end

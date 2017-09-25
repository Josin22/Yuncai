//
//  YBLFastRegisterViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFastRegisterViewController.h"
#import "YBLFastRegisterMassageValiateViewController.h"
#import "YBLLoginViewModel.h"


@interface YBLFastRegisterViewController ()

@property (nonatomic, assign) BOOL isAgree;

@end

@implementation YBLFastRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"手机快速注册";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createUI];
    
}

- (void)createUI{
    
    CGFloat upSpace = 50;
    CGFloat viewHi = 40;
    
    self.isAgree = YES;
    
    WEAK
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(2*space, upSpace, YBLWindowWidth-4*space, viewHi)];
    phoneView.backgroundColor = [UIColor whiteColor];
    phoneView.layer.masksToBounds = YES;
    phoneView.layer.cornerRadius = 3;
    [self.view addSubview:phoneView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, phoneView.height)];
    label.text = @"+86";
    label.font = YBLFont(14);
    label.textColor = BlackTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    [phoneView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.width-0.5, 10, 0.5, 20)];
    lineView.backgroundColor = YBLLineColor;
    [label addSubview:lineView];
    
    UITextField *phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(label.right+space, 0, phoneView.width-label.right-space*2, phoneView.height)];
    phoneTextField.borderStyle = UITextBorderStyleNone;
    phoneTextField.font = YBLFont(16);
    phoneTextField.placeholder = @"请输入手机号";
    if (self.phoneNummber.length!=0) {
        phoneTextField.text = self.phoneNummber;
    }
    [phoneTextField becomeFirstResponder];
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.textColor = YBLColor(40, 40, 40, 1);;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneView addSubview:phoneTextField];
    [phoneTextField.rac_textSignal subscribeNext:^(NSString *x) {
        STRONG
        if (x.length==11) {
            [self.view endEditing:YES];
        }
    }];
    
    
    YBLButton *agreeButton = [YBLButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setImage:[UIImage imageNamed:@"iButton_L_02"] forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"iButton_L_01"] forState:UIControlStateSelected];
    [agreeButton setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
    agreeButton.titleLabel.font = YBLFont(10);
    agreeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [agreeButton setTitleColor:YBLColor(70, 70, 70, 1) forState:UIControlStateNormal];
    [agreeButton setTitleRect:CGRectMake(15, 0, phoneView.width-15-3, 20)];
    agreeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [agreeButton setImageRect:CGRectMake(0, 5, 10, 10)];
    agreeButton.selected = self.isAgree;
    agreeButton.frame = CGRectMake(phoneView.left, phoneView.bottom+space, 90, 20);
    [[agreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        self.isAgree = !self.isAgree;
        agreeButton.selected = self.isAgree;
    }];
    [self.view addSubview:agreeButton];
    
    NSString *text1 = @"<云采商城服务协议>";
    CGSize textSize1 = [text1 heightWithFont:YBLFont(10) MaxWidth:200];
    UIButton *xieyiServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiServiceButton.frame = CGRectMake(agreeButton.right, agreeButton.top, textSize1.width, agreeButton.height);
    [xieyiServiceButton setTitle:text1 forState:UIControlStateNormal];
    xieyiServiceButton.titleLabel.font = YBLFont(10);
    [xieyiServiceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[xieyiServiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_YunCaiSmallServiceDelegate title:@"云采商城服务协议"];
    }];
    [self.view addSubview:xieyiServiceButton];
    
    NSString *text2 = @"<法律声明及隐私政策>";
//    CGSize textSize2 = [text2 heightWithFont:YBLFont(10) MaxWidth:200];
    UIButton *xieyiYInsiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    xieyiYInsiButton.frame = CGRectMake(xieyiServiceButton.right, xieyiServiceButton.top, YBLWindowWidth-xieyiServiceButton.right, xieyiServiceButton.height);
    xieyiYInsiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [xieyiYInsiButton setTitle:text2 forState:UIControlStateNormal];
    xieyiYInsiButton.titleLabel.font = YBLFont(10);
    [xieyiYInsiButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [[xieyiYInsiButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_LowyerDelegate title:@"法律声明及隐私权政策"];
    }];
    [self.view addSubview:xieyiYInsiButton];
    
    UIButton *nextButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(agreeButton.left, agreeButton.bottom+2*space, phoneView.width, viewHi)];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 3;
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        BOOL isPhone = [YBLMethodTools checkPhone:phoneTextField.text];
        if (!isPhone) {
            [SVProgressHUD showErrorWithStatus:@"手机号格式不正确!"];
            return ;
        }
        //判断是否是已注册手机号
        //验证手机号
        [[YBLLoginViewModel singalForUserSearchWith:phoneTextField.text] subscribeNext:^(NSNumber *x) {
            STRONG
            if (x.boolValue) {
                [SVProgressHUD showErrorWithStatus:@"手机号已注册~"];
            } else {
                [SVProgressHUD dismiss];
                YBLFastRegisterMassageValiateViewController *MassageValiateVC = [YBLFastRegisterMassageValiateViewController new];
                MassageValiateVC.phoneNummber = phoneTextField.text;
                [self.navigationController pushViewController:MassageValiateVC animated:YES];
            }
        } error:^(NSError *error) {
        }];
        
    }];
    [self.view addSubview:nextButton];
    
    UIButton *contactButton = [YBLMethodTools getContactKefuButtonWithFrame:CGRectMake(nextButton.left, nextButton.bottom+space, nextButton.width, 20)];
    
    [[contactButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [YBLMethodTools callWithNumber:Service_PhoneCall];
    }];
    [self.view addSubview:contactButton];
    
    /* RAC */
    RAC(nextButton,enabled) = [RACSignal combineLatest:@[phoneTextField.rac_textSignal,
                                                         RACObserve(self, isAgree)]
                                                reduce:^(NSString *text,NSNumber *isAgree){
                                                    return @(text.length==11&&isAgree.boolValue);
                                                }];
    
}



@end

//
//  YBLAddBankCardViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddBankCardViewController.h"
#import "YBLSettingWithdrawalPswViewController.h"
#import "YBLUserInfosParaModel.h"

@interface YBLAddBankCardViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) BOOL isVailate;

@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, retain) UILabel *cardInfoLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *cardInfoView;

@property (nonatomic, strong) UITextField *contactTextFeild;
@property (nonatomic, strong) UITextField *cardTextFeild;
@property (nonatomic, strong) UITextField *phoneTextFeild;
@property (nonatomic, strong) UITextField *idsTextFeild;

@end

@implementation YBLAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加银行卡";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
}

- (void)requestIDCardWithCardId{
    [SVProgressHUD showWithStatus:@"努力加载..."];
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"acct_name"] = self.contactTextFeild.text;
    para[@"acct_pan"] = self.cardTextFeild.text;
    para[@"phone_num"] = self.phoneTextFeild.text;
    para[@"cert_id"] = self.idsTextFeild.text;
    [YBLRequstTools HTTPGetDataWithUrl:url_checkbankcard
                               Parames:para
                             commplete:^(id result,NSInteger statusCode) {
                                 NSDictionary *data = result[@"dataresp"];
                                 //if ([data[@"code"] integerValue] == 0&&data) {
                                 if ([data[@"code"] integerValue] == 0) {
                                     
                                     [SVProgressHUD dismiss];
                                     
                                     self.userInfosParModel.acct_name = self.contactTextFeild.text;
                                     self.userInfosParModel.acct_pan = self.cardTextFeild.text;
                                     self.userInfosParModel.cert_id = self.idsTextFeild.text;
                                     self.userInfosParModel.phone_num = self.phoneTextFeild.text;
                                     self.userInfosParModel.bankname = self.bankName;
                                     YBLSettingWithdrawalPswViewController *vc = [YBLSettingWithdrawalPswViewController new];
                                     vc.userInfosParModel = self.userInfosParModel;
                                     [self.navigationController pushViewController:vc animated:YES];
                                     
                                 } else {
                                     NSString *desc = data[@"desc"];
                                     [SVProgressHUD showErrorWithStatus:desc];
                                 }
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   
                               }];
}

- (void)requestCardInfoWithNo:(NSString *)cardNo{
    
    NSDictionary *para = @{@"bankno":cardNo};
    [YBLRequstTools HTTPGetDataWithUrl:url_getbankcardinfo
                               Parames:[para mutableCopy]
                             commplete:^(id result,NSInteger statusCode) {
                                 NSDictionary *resultDict = result[@"dataresp"];
                                 if (!resultDict) {
                                    self.cardInfoLabel.text = @"输入卡号有误";
                                     self.isVailate = NO;
                                 } else {
                                     if ([resultDict[@"resp"][@"code"] integerValue] == 0) {
                                         //成功
                                         NSString *carName = resultDict[@"data"][@"bank_name"];
                                         self.bankName = carName;
                                         self.cardInfoLabel.text = carName;
                                         self.isVailate = YES;
                                     } else {
                                         //失败
                                         self.cardInfoLabel.text = @"输入卡号有误";
                                         self.isVailate = NO;
                                     }

                                 }
                                
                                 self.cardInfoView.hidden = NO;
                                 self.cardInfoView.alpha = 0;
                                 [UIView animateWithDuration:.4f
                                                  animations:^{
                                                      self.cardInfoView.alpha = 1;
                                                      self.bottomView.top = self.cardInfoView.bottom;
                                                  }];
                             }
                               failure:^(NSError *error,NSInteger errorCode) {
                                   
                               }];
    
}

- (void)createUI{
    
    CGFloat itemHi = 45;
    
    UILabel *storeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, self.view.width-2*space, itemHi)];
    storeNameLabel.text = @"请绑定持卡人本人的银行卡";
    storeNameLabel.textColor = YBLTextColor;
    storeNameLabel.font = YBLFont(16);
    [self.view addSubview:storeNameLabel];
    
    [storeNameLabel addSubview:[YBLMethodTools addLineView:CGRectMake(0, storeNameLabel.height-0.5, storeNameLabel.width+space, 0.5)]];;
    
    UIView *contactView = [[UIView alloc] initWithFrame:CGRectMake(0, storeNameLabel.bottom, self.view.width, storeNameLabel.height)];
    [self.view addSubview:contactView];
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, contactView.height)];
    contactLabel.text = @"持卡人 :";
    contactLabel.textColor = BlackTextColor;
    contactLabel.font = YBLFont(16);
    [contactView addSubview:contactLabel];
    
    UITextField *contactTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(contactLabel.right, contactLabel.top, contactView.width-contactLabel.right, contactLabel.height)];
    contactTextFeild.borderStyle = UITextBorderStyleNone;
    contactTextFeild.placeholder = @"请输入持卡人姓名";
    contactTextFeild.textColor = BlackTextColor;
    contactTextFeild.font = YBLFont(16);
    [contactView addSubview:contactTextFeild];
    self.contactTextFeild = contactTextFeild;
    
    [contactView addSubview:[YBLMethodTools addLineView:CGRectMake(space, contactView.height-0.5, contactView.width, 0.5)]];
    
    /*卡号*/
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, contactView.bottom, contactView.width, contactView.height)];
    [self.view addSubview:cardView];
    UILabel *cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, cardView.height)];
    cardLabel.text = @"卡号 :";
    cardLabel.textColor = BlackTextColor;
    cardLabel.font = YBLFont(16);
    [cardView addSubview:cardLabel];
    
    UITextField *cardTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(cardLabel.right, cardLabel.top, cardView.width-cardLabel.right, cardLabel.height)];
    cardTextFeild.borderStyle = UITextBorderStyleNone;
    cardTextFeild.placeholder = @"请输入银行卡号";
    cardTextFeild.keyboardType = UIKeyboardTypePhonePad;
    cardTextFeild.textColor = BlackTextColor;
    cardTextFeild.font = YBLFont(16);
    [cardView addSubview:cardTextFeild];
    self.cardTextFeild = cardTextFeild;
    
    [cardView addSubview:[YBLMethodTools addLineView:CGRectMake(space, cardView.height-0.5, cardView.width, 0.5)]];
    /*卡信息*/
    UIView *cardInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, cardView.bottom, cardView.width, cardView.height)];
    [self.view addSubview:cardInfoView];
    self.cardInfoView = cardInfoView;
    
    UILabel *cardInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, cardView.width-2*space, cardView.height)];
    cardInfoLabel.text = @"银行卡信息";
    cardInfoLabel.textColor = YBLThemeColor;
    cardInfoLabel.font = YBLFont(16);
    [cardInfoView addSubview:cardInfoLabel];
    self.cardInfoLabel = cardInfoLabel;
    
    [cardInfoView addSubview:[YBLMethodTools addLineView:CGRectMake(space, cardInfoView.height-0.5, cardInfoView.width, 0.5)]];
    cardInfoView.hidden = YES;
    
    ///手机号
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, cardView.bottom, cardView.width, itemHi*4)];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, contactView.height)];
    [bottomView addSubview:phoneView];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 70, phoneView.height)];
    phoneLabel.text = @"手机号 :";
    phoneLabel.textColor = BlackTextColor;

    phoneLabel.font = YBLFont(16);
    [phoneView addSubview:phoneLabel];
    
    UITextField *phoneTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(phoneLabel.right, phoneLabel.top, phoneView.width-phoneLabel.right, phoneLabel.height)];
    phoneTextFeild.borderStyle = UITextBorderStyleNone;
    phoneTextFeild.placeholder = @"请输入持卡人手机号";
    phoneTextFeild.textColor = BlackTextColor;
    phoneTextFeild.keyboardType = UIKeyboardTypePhonePad;
    phoneTextFeild.font = YBLFont(16);
    [phoneView addSubview:phoneTextFeild];
    self.phoneTextFeild = phoneTextFeild;
    
    [phoneView addSubview:[YBLMethodTools addLineView:CGRectMake(space, phoneView.height-0.5, phoneView.width, 0.5)]];
    
    ///身份证号
    UIView *idsView = [[UIView alloc] initWithFrame:CGRectMake(0, phoneView.bottom, bottomView.width, contactView.height)];
    [bottomView addSubview:idsView];
    UILabel *idsLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, 80, phoneView.height)];
    idsLabel.text = @"身份证号 :";
    idsLabel.textColor = BlackTextColor;
    idsLabel.font = YBLFont(16);
    [idsView addSubview:idsLabel];
    
    UITextField *idsTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(idsLabel.right, idsLabel.top, idsView.width-idsLabel.right, idsLabel.height)];
    idsTextFeild.borderStyle = UITextBorderStyleNone;
    idsTextFeild.placeholder = @"请输入身份证号";
    idsTextFeild.textColor = BlackTextColor;
    idsTextFeild.font = YBLFont(16);
    [idsView addSubview:idsTextFeild];
    self.idsTextFeild =idsTextFeild;
    
    [idsView addSubview:[YBLMethodTools addLineView:CGRectMake(space, phoneView.height-0.5, phoneView.width, 0.5)]];
    
    ///下一步
    WEAK
    UIButton *nextButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, idsView.bottom+itemHi, bottomView.width-2*space, itemHi)];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       STRONG
        [self requestIDCardWithCardId];
    }];
    [bottomView addSubview:nextButton];
    
    /**/
    RAC(nextButton,enabled) = [RACSignal combineLatest:@[self.contactTextFeild.rac_textSignal,
                                                         self.cardTextFeild.rac_textSignal,
                                                         self.phoneTextFeild.rac_textSignal,
                                                         self.idsTextFeild.rac_textSignal,
                                                         RACObserve(self, isVailate)]
                                                reduce:^(NSString *contact,NSString *card,NSString *phone,NSString *ids,NSNumber *isValiate){
                                                    
                                                    return @(contact.length>1&&card.length>=16&&phone.length==11&&ids.length>=15&&isValiate.boolValue);
                                                }];
    //卡号
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.cardTextFeild] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *x) {
        STRONG
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        if ([text hasPrefix:@" "]) {
            [SVProgressHUD showErrorWithStatus:@"输入有误~"];
            return ;
        }
        [self requestCardInfoWithNo:text];
    }];
    
    [cardTextFeild.rac_textSignal subscribeNext:^(id x) {
        
        if (!self.cardInfoView.isHidden) {
            self.cardInfoView.alpha = 1;
            [UIView animateWithDuration:.4f
                             animations:^{
                                 self.cardInfoView.alpha = 0;
                                 self.bottomView.top = self.cardInfoView.top;
                             } completion:^(BOOL finished) {
                                 self.cardInfoView.hidden = YES;
                             }];
            
        }
        
    }];
}

@end

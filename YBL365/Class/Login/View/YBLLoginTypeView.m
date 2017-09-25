//
//  YBLLoginTypeView.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLLoginTypeView.h"
#import "YBLTextField.h"

static NSInteger textFeildTAG = 101;

@interface YBLLoginTypeView ()
{
    UILabel *massageLabel;
}
@property (nonatomic, assign) loginType type;

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation YBLLoginTypeView

- (instancetype)initWithFrame:(CGRect)frame Type:(loginType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _type = type;
        
        [self createLoginUI];
    }
    return self;
}

- (void)createLoginUI{
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-100)/2, 40, 100, 100)];
//    _headerImageView.backgroundColor = [UIColor redColor];
    _headerImageView.image = [UIImage imageNamed:@"login_icon"];
    [self addSubview:_headerImageView];
    
    NSArray *textFieldArray = nil;
    NSArray *placeholderArray = nil;
    NSString *buttonTitle = nil;
    
    if (_type  == loginTypeDefault) {
        
        textFieldArray =  @[@(textFieldTypeDefault),@(textFieldTypeFoundPWD)];
        placeholderArray = @[@"手机号",@"密码"];
        buttonTitle = @"进入";
        
    } else if (_type  == loginTypePhoneLost) {

        textFieldArray =  @[@(textFieldTypeSendCode),@(textFieldTypeDefault)];
        placeholderArray = @[@"请输入验证码",@"请输入新密码(6-20位英文或数字)"];
        buttonTitle = @"提交";
        
        //back button
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setBackgroundColor:[UIColor redColor]];
        [backButton setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];

    }
    
    for (int i = 0; i<4; i++) {
        
        CGFloat space = 18;
        CGFloat textHeight = 40;
        CGFloat leftSpace = 20;
        CGRect frame = CGRectMake(leftSpace, self.height/2-textHeight*3/2-space+i*(space+textHeight), self.width-2*leftSpace, textHeight);
        if (i<2) {
            
            YBLTextField *textField = [[YBLTextField alloc] initWithFrame:frame];
            textField.currentType = [textFieldArray[i] integerValue];
            textField.tag = textFeildTAG+i;
            textField.placeholderValue = placeholderArray[i];
            textField.textFieldBlock = ^(textFieldType type){
                if (type == textFieldTypeFoundPWD) {
                    BLOCK_EXEC(self.loginTypeViewBlock,_type,EventTypeFound);
                } else if (type == textFieldTypeSendCode){
                    BLOCK_EXEC(self.loginTypeViewBlock,_type,EventTypeSendCode);
                }
            };
            [self addSubview:textField];
            
        } else if(i == 2){
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            loginButton.frame = frame;
            [loginButton addTarget:self action:@selector(loginEventMethod:) forControlEvents:UIControlEventTouchUpInside];
            [loginButton setTitle:buttonTitle forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [loginButton setBackgroundColor:YBLColor(245,90,93,1)];
            loginButton.layer.cornerRadius  = textHeight/2;
            loginButton.layer.masksToBounds = YES;
            loginButton.titleLabel.font = YBLFont(15);
            [self addSubview:loginButton];
            
            massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(loginButton.frame.origin.x, loginButton.frame.origin.y-space, loginButton.frame.size.width, space)];
            massageLabel.text = @"未注册手机号验证后自动登录";
            massageLabel.textColor = YBLColor(153, 153, 153, 1);
            massageLabel.textAlignment = NSTextAlignmentCenter;
            massageLabel.font  = YBLFont(10);
            [self addSubview:massageLabel];
            massageLabel.hidden = YES;
            
            
        } else {
            if (_type  == loginTypeDefault) {
                UIButton *noPSWButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [noPSWButton setTitle:@"免密码登陆" forState:UIControlStateNormal];
                [noPSWButton setTitle:@"账号密码登陆" forState:UIControlStateSelected];
                [noPSWButton setTitleColor:YBLColor(66,102,151,1) forState:UIControlStateNormal];
                [noPSWButton setTitleColor:YBLColor(66,102,151,1) forState:UIControlStateSelected];
                noPSWButton.titleLabel.font = YBLFont(12);
                [noPSWButton addTarget:self action:@selector(changeLoginState:) forControlEvents:UIControlEventTouchUpInside];
                [noPSWButton setFrame:frame];
                [self addSubview:noPSWButton];
            }

        }
        
    }
    
   
}

- (void)changeLoginState:(UIButton *)btn{
    
    btn.selected =  !btn.selected;
    massageLabel.hidden =  !btn.selected;
    
    YBLTextField *t1 = (YBLTextField *)[self viewWithTag:textFeildTAG];
    t1.currentType =  !btn.selected == YES?textFieldTypeDefault:textFieldTypeSendCode;
    YBLTextField *t2 = (YBLTextField *)[self viewWithTag:textFeildTAG+1];
    t2.currentType = !btn.selected == YES?textFieldTypeFoundPWD:textFieldTypeDefault;
    t2.placeholderValue = !btn.selected == YES?@"密码":@"请输入验证码";
}

- (void)loginEventMethod:(UIButton *)btn{
    BLOCK_EXEC(self.loginTypeViewBlock,_type,_type == loginTypeDefault?EventTypeLogin:EventTypeCommit);
}

- (void)backView{

    BLOCK_EXEC(self.loginTypeViewBlock,_type,EventTypeBack);
}

@end

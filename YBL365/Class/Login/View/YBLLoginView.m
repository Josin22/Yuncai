//
//  YBLLoginView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLLoginView.h"
#import "YBLLoginTypeView.h"


static YBLLoginView *loginView = nil;

@interface YBLLoginView ()

//登陆页面
@property (nonatomic, strong) YBLLoginTypeView *loginDefaultTypeView;
//找回手机号页面
@property (nonatomic, strong) YBLLoginTypeView *loginFoundTypeView;

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, copy) LoginSuccessBlcok successblock;
@property (nonatomic, copy) LoginFaileBlock faileBlock;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation YBLLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    UIView *bg = [[UIView alloc] initWithFrame:[self bounds ]];
    bg.backgroundColor = [UIColor clearColor];
    [self addSubview:bg];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLoginView)];
    [bg addGestureRecognizer:tap];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, self.height-60)];
    _bgView.backgroundColor = YBLColor(250, 250, 250, 1);
    _bgView.layer.cornerRadius = 4;
    _bgView.layer.masksToBounds = YES;
    [self addSubview:_bgView];
    
    //登陆
    self.loginDefaultTypeView = [[YBLLoginTypeView alloc] initWithFrame:[_bgView bounds] Type:loginTypeDefault];
    WEAK
    self.loginDefaultTypeView.loginTypeViewBlock = ^(loginType type,EventType eventType){
        STRONG
        switch (eventType) {
            case EventTypeLogin:
            {
                NSLog(@"登陆");
                [YBLUserModel shareInstance].isLogin = YES;
                SVPSHOWSUCCESS(@"登陆成功");
                NOSHOWSVP(1.0);
                [self dismissLoginView];
            }
                break;
            case EventTypeFound:
            {
                NSLog(@"找回密码");
                
                [self moveViewToFirst:NO];
            }
                break;
            case EventTypeSendCode:
            {
                NSLog(@"发送验证码");
            }
                break;
    
            default:
                break;
        }
    };
    [_bgView addSubview:_loginDefaultTypeView];
    
    //找回密码
    _loginFoundTypeView = [[YBLLoginTypeView alloc] initWithFrame:[_bgView bounds] Type:loginTypePhoneLost];
    CGRect foundViewFrame = [_loginFoundTypeView frame];
    foundViewFrame.origin.x = self.width;
    _loginFoundTypeView.frame = foundViewFrame;
    _loginFoundTypeView.loginTypeViewBlock = ^(loginType type,EventType eventType){
        STRONG
        switch (eventType) {
            case EventTypeBack:
            {
                NSLog(@"返回");
                [self moveViewToFirst:YES];
            }
                break;
            case EventTypeCommit:
            {
                NSLog(@"提交");
            }
                break;
            case EventTypeSendCode:
            {
                NSLog(@"发送验证码");
            }
                break;
                
            default:
                break;
        }

    };
    [_bgView addSubview:_loginFoundTypeView];
    
    //dismiss button
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [dismissButton setBackgroundColor:[UIColor redColor]];
    [dismissButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismissLoginView) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:dismissButton];
    [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.top.equalTo(@10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];

}

/**
 *  调用登录 动画弹出登录界面
 *
 *  @param VC           必填 是从哪个控制器弹出
 *  @param successBlock 登录成功回调
 *  @param failBlock    登录失败回调
 */
+ (void)loginWithViewController:(UIViewController *)VC
                   successBlock:(LoginSuccessBlcok)successBlock
                      failBlock:(LoginFaileBlock)failBlock {
    
    
    
    if (!loginView) {

        CGRect startFrame = CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight);
        
        loginView = [[YBLLoginView alloc] initWithFrame:startFrame];
        loginView.vc = VC;
        loginView.backgroundColor = YBLColor(0, 0, 0, 0);
        
        loginView.successblock = successBlock;
        loginView.faileBlock = failBlock;
    }

    [YBLMethodTools transformOpenView:loginView.bgView SuperView:loginView fromeVC:VC Top:60];
    
}

#pragma mark method

- (void)dismissLoginView{
    
    [YBLMethodTools transformCloseView:self.bgView SuperView:loginView fromeVC:_vc Top:YBLWindowHeight completion:^(BOOL finished) {
        if (finished) {
            [loginView removeFromSuperview];
            
            if ([YBLUserModel shareInstance].isLogin) {
                if (self.successblock) {
                    self.successblock();
                }
            }else {
                if (self.faileBlock) {
                    self.faileBlock();
                }
            }

        }
    }];
    
}

- (void)moveViewToFirst:(BOOL)isFirst{
    
    CGRect firstViewFrame = [self.loginDefaultTypeView frame];
    CGRect secondViewFrame = [self.loginFoundTypeView frame];
    firstViewFrame.origin.x =  isFirst == YES ? 0:-self.width;
    secondViewFrame.origin.x = isFirst == YES ? self.width: 0;
    
    [UIView animateWithDuration:.4f
                          delay:0
         usingSpringWithDamping:.8f
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.loginDefaultTypeView.frame = firstViewFrame;
                         self.loginFoundTypeView.frame  = secondViewFrame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];

    
}


@end

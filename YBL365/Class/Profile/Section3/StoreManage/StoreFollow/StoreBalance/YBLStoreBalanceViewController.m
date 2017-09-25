//
//  YBLStoreBalanceViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreBalanceViewController.h"
#import "YBLStoreFollowSettingViewModel.h"

@interface YBLStoreBalanceViewController ()<UIScrollViewDelegate>
{
    NSInteger cureent_index;
    NSString *direction;
    float cureentBalanceMoney;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, strong) UIView *balanceView;

@property (nonatomic, strong) UIView *rechargeView;

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, retain) UILabel *resultLabel;

@property (nonatomic, retain) UILabel *walletsLabel;

@property (nonatomic, retain) UILabel *walletsBalanceMoneyLabel;

@property (nonatomic, retain) UILabel *rechargeInfoLabel;

@property (nonatomic, strong) XXTextField *moneyTextField;

@property (nonatomic, strong) UIButton *tixianButton;

@end

@implementation YBLStoreBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"店铺专项云币";
    
    [self createUI];
}

- (void)goback1{
    if (cureent_index==1) {
        [self turnToIndex:0 isAnimation:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createUI {

    self.contentScrollView = [[UIScrollView alloc] initWithFrame:[self.view bounds]];
    self.contentScrollView.height -= kNavigationbarHeight;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width*3, self.contentScrollView.height);
    [self.view addSubview:self.contentScrollView];
    
    [self turnToIndex:0 isAnimation:YES];
}

- (void)turnToIndex:(NSInteger)index isAnimation:(BOOL)isAnimation{
    
    [self.view endEditing:YES];
    cureent_index = index;
    switch (index) {
        case 0:
        {
            self.balanceView.hidden = NO;
        }
            break;
        case 1:
        {
            self.rechargeView.hidden = NO;
        }
            break;
        case 2:
        {
            self.resultView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.width*index, 0) animated:isAnimation];
}

- (void)changeToRecharge:(BOOL)isRecharge{
    self.rechargeView.hidden = NO;
    self.resultView.hidden = NO;
    if (isRecharge) {
        self.rechargeInfoLabel.text = @"店铺投放";
        self.resultLabel.text = @"投放成功";
        direction = @"inc";
        self.walletsLabel.text = @"钱包余额";
        self.walletsBalanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",self.walletsMoeny];
        cureentBalanceMoney = self.walletsMoeny;
        [self.tixianButton setTitle:@"全部投放关注" forState:UIControlStateNormal];
    } else {
        self.rechargeInfoLabel.text = @"店铺返还";
        self.resultLabel.text = @"返还成功";
        direction = @"dec";
        self.walletsLabel.text = @"收藏余额";
        self.walletsBalanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",self.quotaMoeny];
        cureentBalanceMoney = self.quotaMoeny;
        [self.tixianButton setTitle:@"全部返还钱包" forState:UIControlStateNormal];
    }
}

- (UIView *)balanceView{
    if (!_balanceView) {
        _balanceView = [[UIView alloc] initWithFrame:[self.contentScrollView bounds]];
        [self.contentScrollView addSubview:_balanceView];
        UILabel *followLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, space*3, _balanceView.width, 20)];
        followLabel.text = @"收藏余额";
        followLabel.font = YBLFont(15);
        followLabel.textAlignment = NSTextAlignmentCenter;
        [_balanceView addSubview:followLabel];
        
        UILabel *followBalanceMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, followLabel.bottom+space, _balanceView.width, 30)];
        followBalanceMoneyLabel.font = YBLBFont(25);
        followBalanceMoneyLabel.textAlignment = NSTextAlignmentCenter;
        followBalanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",self.quotaMoeny];
        [_balanceView addSubview:followBalanceMoneyLabel];
        
        WEAK
        UIButton *rechargeButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space*2, followBalanceMoneyLabel.bottom+space*5, _balanceView.width-4*space, buttonHeight)];
        [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        [_balanceView addSubview:rechargeButton];
        [[rechargeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self turnToIndex:1 isAnimation:YES];
            [self changeToRecharge:YES];
        }];
        
        UIButton *rebackButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(rechargeButton.left, rechargeButton.bottom+space*2, rechargeButton.width, buttonHeight)];
        [rebackButton setTitle:@"返还钱包" forState:UIControlStateNormal];
        [rebackButton setBackgroundColor:YBLColor(245, 245, 245, 1) forState:UIControlStateNormal];
        [rebackButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        rebackButton.layer.borderColor = YBLColor(210, 210, 210, 1).CGColor;
        rebackButton.layer.borderWidth = .5;
        [_balanceView addSubview:rebackButton];
        [[rebackButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [self turnToIndex:1 isAnimation:YES];
            [self changeToRecharge:NO];
        }];

    }
    return _balanceView;
}

- (UIView *)rechargeView{
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc] initWithFrame:[self.contentScrollView bounds]];
        _rechargeView.backgroundColor = YBLColor(245, 245, 245, 1);
        _rechargeView.left = self.contentScrollView.width;
        [self.contentScrollView addSubview:_rechargeView];
        
        UILabel *walletsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, space*3, _rechargeView.width, 20)];
        walletsLabel.text = @"钱包余额";
        walletsLabel.font = YBLFont(12);
        walletsLabel.textColor = YBLTextLightColor;
        walletsLabel.textAlignment = NSTextAlignmentCenter;
        [_rechargeView addSubview:walletsLabel];
        self.walletsLabel = walletsLabel;
        
        UILabel *walletsBalanceMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, walletsLabel.bottom+space, _rechargeView.width, 20)];
        walletsBalanceMoneyLabel.font = YBLFont(20);
        walletsBalanceMoneyLabel.textColor = YBLTextColor;
        walletsBalanceMoneyLabel.textAlignment = NSTextAlignmentCenter;
        walletsBalanceMoneyLabel.text = [NSString stringWithFormat:@"%.2f",self.walletsMoeny];
        [_rechargeView addSubview:walletsBalanceMoneyLabel];
        self.walletsBalanceMoneyLabel = walletsBalanceMoneyLabel;
        
        UIView *fieldView = [[UIView alloc] initWithFrame:CGRectMake(2*space, walletsBalanceMoneyLabel.bottom+space*2, _rechargeView.width-4*space, 80)];
        fieldView.backgroundColor = [UIColor whiteColor];
        fieldView.layer.cornerRadius = 3;
        fieldView.layer.masksToBounds = YES;
        [_rechargeView addSubview:fieldView];
        
        UILabel *rechargeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, 200, 15)];
        rechargeInfoLabel.text = @"店铺投放";
        rechargeInfoLabel.font = YBLFont(12);
        rechargeInfoLabel.textColor = YBLTextLightColor;
        [fieldView addSubview:rechargeInfoLabel];
        self.rechargeInfoLabel = rechargeInfoLabel;
        
        UILabel *signlMoenyLabel = [[UILabel alloc] initWithFrame:CGRectMake(rechargeInfoLabel.left, 0, space, 20)];
        signlMoenyLabel.textColor = YBLTextColor;
        signlMoenyLabel.text = @"¥";
        signlMoenyLabel.font = YBLFont(14);
        [fieldView addSubview:signlMoenyLabel];
        
        XXTextField *moneyTextField = [[XXTextField alloc] initWithFrame:CGRectMake(signlMoenyLabel.right, rechargeInfoLabel.bottom+space, fieldView.width-signlMoenyLabel.right-space, fieldView.height-rechargeInfoLabel.bottom-space*2)];
        moneyTextField.textColor = BlackTextColor;
        moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        moneyTextField.isAutoSpaceInLeft = YES;
        moneyTextField.font = YBLFont(25);
        [fieldView addSubview:moneyTextField];
        self.moneyTextField = moneyTextField;
        
        signlMoenyLabel.centerY = moneyTextField.centerY;
        
        WEAK
        UIButton *tixianButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tixianButton.frame = CGRectMake(fieldView.left+space, fieldView.bottom, 80, 25);
        [tixianButton setTitle:@"全部提现" forState:UIControlStateNormal];
        [tixianButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [tixianButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        tixianButton.titleLabel.font = YBLFont(12);
        [_rechargeView addSubview:tixianButton];
        [[tixianButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",cureentBalanceMoney];
        }];
        self.tixianButton = tixianButton;
        
        UIButton *sureButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space*2, fieldView.bottom+space*4, _rechargeView.width-4*space, buttonHeight)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_rechargeView addSubview:sureButton];
        
        [[sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if (self.moneyTextField.text.doubleValue<=0) {
                [SVProgressHUD showErrorWithStatus:@"输入金额有误~"];
                return ;
            }
            [[YBLStoreFollowSettingViewModel siganlForStoreTransferWithDirection:direction amount:self.moneyTextField.text.doubleValue] subscribeNext:^(NSNumber*  _Nullable x) {
                if (x.boolValue) {
                    self.moneyTextField.text = nil;
                    [self turnToIndex:2 isAnimation:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"余额不足~"];
                }
            } error:^(NSError * _Nullable error) {
                
            }];
        }];
    }
    return _rechargeView;
}

- (UIView *)resultView{
    if (!_resultView) {
        _resultView = [[UIView alloc] initWithFrame:[self.contentScrollView bounds]];
        _resultView.left = self.contentScrollView.width*2;
        [self.contentScrollView addSubview:_resultView];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _resultView.width/6, _resultView.width/4, _resultView.width/4)];
        rightImageView.image = [UIImage imageNamed:@"arrow_right"];
        rightImageView.centerX = _resultView.width/2;
        [_resultView addSubview:rightImageView];
        
        UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rightImageView.bottom+space, _resultView.width, 20)];
        resultLabel.textColor = BlackTextColor;
        resultLabel.font = YBLFont(17);
        resultLabel.text = @"投放成功";
        resultLabel.textAlignment = NSTextAlignmentCenter;
        [_resultView addSubview:resultLabel];
        self.resultLabel = resultLabel;
        
        UIButton *doneButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space*2, rightImageView.top+resultLabel.bottom, _resultView.width-4*space, buttonHeight)];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_resultView addSubview:doneButton];
        WEAK
        [[doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
//            [self turnToIndex:0 isAnimation:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }
    return _resultView;
}

@end

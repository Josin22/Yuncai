//
//  YBLPayWayView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayWayCashierView.h"


static YBLPayWayCashierView *payWayCashierView = nil;

@interface YBLPayWayCashierView ()
{
    CGFloat contenHi;
}
@property (nonatomic, assign) PayWayCashierType cashierType;

@property (nonatomic, assign) OrderType orderType;

@property (nonatomic, copy  ) CashierSelectPayTypeBlock cashierSelectPayTypeBlock;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *forwardOrderBiView;

@property (nonatomic, strong) UIView *reverseOrderAllUseBiView;

@property (nonatomic, strong) UITextField *reverseOrderBiTextFeild;

@property (nonatomic, retain) UILabel *reverseOrderLessMoneyLable;

@property (nonatomic, retain) UILabel *chajiaLabel;

@property (nonatomic, strong) UIButton *reverseOrderAllUseBiButton;

@end

@implementation YBLPayWayCashierView

+ (void)showPayWayCashierViewWithPayWayCashierType:(PayWayCashierType)cashierType
                                         orderType:(OrderType)orderType
                         CashierSelectPayTypeBlock:(CashierSelectPayTypeBlock)block{
    
    if (!payWayCashierView) {
        payWayCashierView = [[YBLPayWayCashierView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) payWayCashierType:cashierType
                                                              orderType:orderType
                                              CashierSelectPayTypeBlock:block];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:payWayCashierView];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
            payWayCashierType:(PayWayCashierType)cashierType
                    orderType:(OrderType)orderType
    CashierSelectPayTypeBlock:(CashierSelectPayTypeBlock)block{
    
    if (self = [super initWithFrame:frame]) {
        _cashierType = cashierType;
        _orderType = orderType;
        _cashierSelectPayTypeBlock = block;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.f];
    [self addSubview:bgView];
    self.bgView = bgView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [bgView addGestureRecognizer:tap];
    NSString *titleString = nil;
    NSString *moneyInfoString = nil;
    NSString *payImageName = nil;
    switch (_orderType) {
        case OrderTypeForwardOrder:
        {
            //正向订单
            contenHi = self.height*2/5;
            moneyInfoString = @"向云采商城支付配送(发货)保证金 :";
        }
            break;
        case OrderTypeReverseOrder:
        {
            //反向订单
            contenHi = self.height/2+40;
            moneyInfoString = @"向云采商城支付发货款 :";
        }
            break;
            
        default:
            break;
    }
    switch (_cashierType) {
        case PayWayCashierTypeYunCai:
        {
            titleString = @"云采钱包支付";
        }
            break;
        case PayWayCashierTypeWXPay:
        {
            titleString = @"微信支付";
            payImageName = @"weixin";
        }
            break;
        case PayWayCashierTypeAlipay:
        {
            titleString = @"支付宝支付";
            payImageName = @"zhifubao";
        }
            break;
            
        default:
            break;
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, contenHi)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [YBLMethodTools addTopShadowToView:contentView];
    self.contentView = contentView;
    
    /* title view */
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 40)];
    [self.contentView addSubview:titleView];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage newImageWithNamed:@"login_close" size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(space, 5, 30, 30);
    [titleView addSubview:closeButton];
    WEAK
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self dismissView];
    }];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(closeButton.right, 0, titleView.width-closeButton.right*2, titleView.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = YBLFont(18);
    titleLabel.textColor = YBLThemeColor;
    titleLabel.text = titleString;
    [titleView addSubview:titleLabel];
    
    [titleView addSubview:[YBLMethodTools addLineView:CGRectMake(0, titleView.height-0.5, titleView.width, 0.5)]];
    
    /* money */
    UIView *moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.bottom, self.width, titleView.height*2)];
    [self.contentView addSubview:moneyView];
    UILabel *moneyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, space, moneyView.width-2*space, 20)];
    moneyInfoLabel.text = moneyInfoString;
    moneyInfoLabel.font = YBLFont(15);
    moneyInfoLabel.textColor = BlackTextColor;
    [moneyView addSubview:moneyInfoLabel];
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyInfoLabel.left, moneyInfoLabel.bottom, moneyInfoLabel.width, moneyView.height-20-space)];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = YBLFont(20);
    moneyLabel.textColor = BlackTextColor;
    moneyLabel.text = @"220.00云币";
    [moneyView addSubview:moneyLabel];
    [moneyView addSubview:[YBLMethodTools addLineView:CGRectMake(moneyLabel.left, moneyView.height-0.5, moneyView.width-moneyLabel.left, 0.5)]];
    
    
    if (_orderType == OrderTypeForwardOrder) {
        /* 云币抵扣 */
        UIView *forwardOrderBiView = [[UIView alloc] initWithFrame:CGRectMake(0, moneyView.bottom, moneyView.width, titleView.height)];
        [self.contentView addSubview:forwardOrderBiView];
        self.forwardOrderBiView = forwardOrderBiView;
        
        UILabel *forwardOrderBiLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, forwardOrderBiView.width-space*2-50-5, forwardOrderBiView.height)];
        forwardOrderBiLabel.text = @"云币 共2000云币 , 使用500云币,抵扣¥10";
        forwardOrderBiLabel.font = YBLFont(13);
        forwardOrderBiLabel.textColor = BlackTextColor;
        [forwardOrderBiView addSubview:forwardOrderBiLabel];

        UISwitch *forwardOrderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(forwardOrderBiLabel.right+5, 5, 40, 30)];
        forwardOrderSwitch.onTintColor = YBLThemeColor;
        [forwardOrderBiView addSubview:forwardOrderSwitch];
        
        [forwardOrderBiView addSubview:[YBLMethodTools addLineView:CGRectMake(forwardOrderBiLabel.left, forwardOrderBiView.height-0.5, forwardOrderBiView.width-forwardOrderBiLabel.left, 0.5)]];
        
    } else {
        
        /* 使用云币 */
        UIView *useBiView = [[UIView alloc] initWithFrame:CGRectMake(0, moneyView.bottom, moneyView.width, moneyView.height)];
        [self.contentView addSubview:useBiView];
        
        //label
        NSString *text1 = @"使用云币 : ";
        CGSize textSize = [text1 heightWithFont:YBLFont(15) MaxWidth:200];
        UILabel *reverseOrderUseBiLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, textSize.width, textSize.height)];
        reverseOrderUseBiLabel.font = YBLFont(15);
        reverseOrderUseBiLabel.text = text1;
        reverseOrderUseBiLabel.textColor = BlackTextColor;
        reverseOrderUseBiLabel.centerY = useBiView.height/2;
        [useBiView addSubview:reverseOrderUseBiLabel];
        
        //textfeild
        UITextField *reverseOrderBiTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(reverseOrderUseBiLabel.right, 0, useBiView.width-reverseOrderUseBiLabel.right-space, useBiView.height-2*space)];
        reverseOrderBiTextFeild.centerY = reverseOrderUseBiLabel.centerY;
        reverseOrderBiTextFeild.borderStyle = UITextBorderStyleNone;
        reverseOrderBiTextFeild.font = YBLFont(28);
        reverseOrderBiTextFeild.keyboardType = UIKeyboardTypePhonePad;
        reverseOrderBiTextFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
//        reverseOrderBiTextFeild.placeholder = @"可用100云币";
        reverseOrderBiTextFeild.textColor = BlackTextColor;
        [useBiView addSubview:reverseOrderBiTextFeild];
        self.reverseOrderBiTextFeild = reverseOrderBiTextFeild;
        
        [useBiView addSubview:[YBLMethodTools addLineView:CGRectMake(reverseOrderUseBiLabel.left, useBiView.height-0.5, useBiView.width-reverseOrderUseBiLabel.left, 0.5)]];
        
        /* 全部使用云币 */
        UIView *reverseOrderAllUseBiView = [[UIView alloc] initWithFrame:CGRectMake(0, useBiView.bottom, useBiView.width, titleView.height)];
        [self.contentView addSubview:reverseOrderAllUseBiView];
        self.reverseOrderAllUseBiView = reverseOrderAllUseBiView;
        
        NSString *lessString = @"钱包余额100云币,";
        CGSize lessSize = [lessString heightWithFont:YBLFont(15) MaxWidth:200];
        UILabel *reverseOrderLessMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, lessSize.width, reverseOrderAllUseBiView.height)];
        reverseOrderLessMoneyLable.text = lessString;
        reverseOrderLessMoneyLable.textColor = BlackTextColor;
        reverseOrderLessMoneyLable.font = YBLFont(13);
        [reverseOrderAllUseBiView addSubview:reverseOrderLessMoneyLable];
        self.reverseOrderLessMoneyLable = reverseOrderLessMoneyLable;
        //差价
        UILabel *chajiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, reverseOrderAllUseBiView.width-2*space, reverseOrderAllUseBiView.height)];
        chajiaLabel.text = @"您还需要支付120元";
        chajiaLabel.textColor = YBLThemeColor;
        chajiaLabel.font = YBLFont(13);
        [reverseOrderAllUseBiView addSubview:chajiaLabel];
        self.chajiaLabel = chajiaLabel;
        
        UIButton *reverseOrderAllUseBiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reverseOrderAllUseBiButton setTitle:@"全部使用云币支付" forState:UIControlStateNormal];
        reverseOrderAllUseBiButton.frame = CGRectMake(reverseOrderLessMoneyLable.right+3, reverseOrderLessMoneyLable.top, reverseOrderAllUseBiView.width-reverseOrderLessMoneyLable.right-3, reverseOrderLessMoneyLable.height);
        [reverseOrderAllUseBiButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        reverseOrderAllUseBiButton.titleLabel.font = YBLFont(13);
        reverseOrderAllUseBiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [reverseOrderAllUseBiView addSubview:reverseOrderAllUseBiButton];
        [[reverseOrderAllUseBiButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            self.reverseOrderBiTextFeild.text = @"100";
            self.reverseOrderLessMoneyLable.hidden = YES;
            self.reverseOrderAllUseBiButton.hidden = YES;
            self.chajiaLabel.hidden = NO;
        }];
        self.reverseOrderAllUseBiButton = reverseOrderAllUseBiButton;
        
        [reverseOrderAllUseBiView addSubview:[YBLMethodTools addLineView:CGRectMake(reverseOrderLessMoneyLable.left, reverseOrderAllUseBiView.height-0.5, reverseOrderAllUseBiView.width-reverseOrderLessMoneyLable.left, 0.5)]];
        
    }
    
    CGFloat top = 0;
    if (_orderType == OrderTypeForwardOrder) {
        top = self.forwardOrderBiView.bottom;
    } else {
        top = self.reverseOrderAllUseBiView.bottom;
    }
    
    /* 微信 支付宝 */
    if (_cashierType == PayWayCashierTypeYunCai) {
        
        UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.contentView.width, moneyView.height*3/2)];
        [self.contentView addSubview:payView];
        
        YBLButton *wxPayButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        wxPayButton.frame = CGRectMake(0, payView.height/6, payView.width/2, payView.height*2/3);
        [wxPayButton setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [wxPayButton setTitle:@"微信支付" forState:UIControlStateNormal];
        wxPayButton.imageRect = CGRectMake(payView.width/4-25, 0, 50, 50);
        wxPayButton.titleRect = CGRectMake(0, 55, payView.width/2, payView.height*2/3-55);
        wxPayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        wxPayButton.titleLabel.font = YBLFont(13);
        [wxPayButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [payView addSubview:wxPayButton];
        [[wxPayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self blockType:PayWayCashierTypeWXPay];
        }];
        
        YBLButton *alipayPayButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        alipayPayButton.frame = CGRectMake(wxPayButton.right, wxPayButton.top, wxPayButton.width, wxPayButton.height);
        [alipayPayButton setImage:[UIImage imageNamed:@"zhifubao"] forState:UIControlStateNormal];
        [alipayPayButton setTitle:@"支付宝支付" forState:UIControlStateNormal];
        alipayPayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        alipayPayButton.titleLabel.font = YBLFont(13);
        alipayPayButton.imageRect = CGRectMake(payView.width/4-25, 0, 50, 50);
        alipayPayButton.titleRect = CGRectMake(0, 55, payView.width/2, payView.height*2/3-55);
        [alipayPayButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [payView addSubview:alipayPayButton];
        [[alipayPayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self blockType:PayWayCashierTypeAlipay];

        }];
        
        [payView addSubview:[YBLMethodTools addLineView:CGRectMake(payView.width/2, payView.height/4, 0.5, payView.height/2)]];
        
        contenHi = payView.bottom;
        
    } else {
        
        UIView *singlePayView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.width, moneyView.height*2/3)];
        [self.contentView addSubview:singlePayView];
        //支付
        YBLButton *payButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        payButton.frame = CGRectMake(space, 0, singlePayView.width-space*2-30, singlePayView.height);
        [payButton setImage:[UIImage imageNamed:payImageName] forState:UIControlStateNormal];
        [payButton setTitle:titleString forState:UIControlStateNormal];
        payButton.imageRect = CGRectMake(0, space, singlePayView.height-2*space, singlePayView.height-2*space);
        payButton.titleRect = CGRectMake(singlePayView.height-2*space+5, 0, 200, singlePayView.height);
        payButton.titleLabel.font = YBLFont(13);
        [payButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [singlePayView addSubview:payButton];
        [[payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            [self blockType:self.cashierType];
        }];
        
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
        arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
        arrowImageView.center = CGPointMake(singlePayView.width-space-8, singlePayView.height/2);
        [singlePayView addSubview:arrowImageView];
        
        [singlePayView addSubview:[YBLMethodTools addLineView:CGRectMake(space, singlePayView.height-0.5, singlePayView.width-space, 0.5)]];
        
        contenHi = singlePayView.bottom+3*space;
    }
    self.contentView.height = contenHi;
    /* begain animation */
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
                         self.contentView.top = self.height-contenHi;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    /* RAC */
    [self.reverseOrderBiTextFeild.rac_textSignal subscribeNext:^(NSString *x) {
        if (x.length == 0) {
            self.reverseOrderLessMoneyLable.hidden = NO;
            self.reverseOrderAllUseBiButton.hidden = NO;
            self.chajiaLabel.hidden = YES;
        }
    }];
}

- (void)blockType:(PayWayCashierType)type{
    
    [self dismissView];
    BLOCK_EXEC(self.cashierSelectPayTypeBlock,type);
}

- (void)dismiss:(UITapGestureRecognizer *)tap{
    [self dismissView];
}

- (void)dismissView{
    
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         self.contentView.top = self.height;
                     }
                     completion:^(BOOL finished) {
                         [payWayCashierView removeFromSuperview];
                         payWayCashierView = nil;
                     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}

@end

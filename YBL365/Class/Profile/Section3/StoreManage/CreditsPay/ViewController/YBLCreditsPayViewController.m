//
//  YBLCreditsPayViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCreditsPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "YBLPayResultViewController.h"

static NSInteger tag_button = 555;

@interface YBLCreditsPayViewController ()

@end

@implementation YBLCreditsPayViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"支付方式";

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
    RACSignal * deallocSignal = [self rac_signalForSelector:@selector(viewWillDisappear:)];
    
    /* 监听微信支付回调 */
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:WX_PAY_NOTIFICATION_NAME object:nil] takeUntil:deallocSignal] subscribeNext:^(NSNotification *x) {
        
        BOOL isSuccess = [[[x userInfo] objectForKey:@"result"] boolValue];
        if (!self.viewModel.isSearchPayResult) {
            [self payResultWith:isSuccess];
        }
    }];
    //回到程序
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:deallocSignal] subscribeNext:^(id x) {
        NSLog(@"UIApplicationDidEnterBackgroundNotification");
        if (self.viewModel.isPaying&&!self.viewModel.isSearchPayResult) {
            //查询支付结果
            [self checkResult];
        }
    }];
}

- (void)createUI{
    
    
    /*
     UIButton *invoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
     invoiceButton.frame = CGRectMake(space, zhifupeisongView.bottom, zhifupeisongView.width, 40);
     [self.contentView addSubview:invoiceButton];
     self.invoiceButton = invoiceButton;
     
     UILabel *pjxx_label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, invoiceButton.height)];
     pjxx_label1.font = YBLFont(15);
     pjxx_label1.text = @"票据信息";
     pjxx_label1.textColor = BlackTextColor;
     [invoiceButton addSubview:pjxx_label1];
     
     UIImageView *arrowImageView00 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
     arrowImageView00.frame = CGRectMake(0, 0, 8, 16.5);
     arrowImageView00.centerY = invoiceButton.height/2;
     arrowImageView00.left = invoiceButton.width-8;
     [invoiceButton addSubview:arrowImageView00];
     
     UILabel *invoiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(pjxx_label1.right, 0, invoiceButton.width-pjxx_label1.right-arrowImageView00.width-space, invoiceButton.height)];
     invoiceLabel.text = @"";
     invoiceLabel.textAlignment = NSTextAlignmentRight;
     invoiceLabel.textColor = BlackTextColor;
     invoiceLabel.font = YBLFont(13);
     [invoiceButton addSubview:invoiceLabel];
     self.invoiceLabel = invoiceLabel;
     
     [invoiceButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, invoiceButton.height-0.5, invoiceButton.width+space, 0.5)]];

     */
    NSArray *titleArray = @[@"类型 :",@"金额 :"];
    NSArray *valueArray = @[self.viewModel.payModel.serviceName,self.viewModel.payModel.price];

    NSInteger index = 0;
    for (NSString *titleA in titleArray) {
        
        CGRect frame = CGRectMake(space, space+index*40, 100, 40);

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:frame];
        titleLabel.text = titleA;
        titleLabel.textColor = BlackTextColor;
        titleLabel.font = YBLFont(15);
        [self.view addSubview:titleLabel];
        
        NSString *valueString = valueArray[index];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, titleLabel.top, YBLWindowWidth-titleLabel.right-space, titleLabel.height)];
        valueLabel.text = valueString;
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textColor = YBLThemeColor;
        valueLabel.font = YBLFont(16);
        [self.view addSubview:valueLabel];
        
        if (index==titleArray.count-1) {
            [self.view addSubview:[YBLMethodTools addLineView:CGRectMake(space, titleLabel.bottom-.5, YBLWindowWidth, .5)]];
            
            //微信支付宝
            NSArray *titleArray = @[@[@"支付宝支付",@"zhifubao"],@[@"微信支付",@"weixin"]];
            NSInteger iindex = 0;
            for (NSArray *itemArray in titleArray) {
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom+iindex*60, YBLWindowWidth, 60)];
                [self.view addSubview:itemView];
                
                UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, itemView.height-2*space, itemView.height-2*space)];
                iconImageView.image = [UIImage imageNamed:itemArray[1]];
                [itemView addSubview:iconImageView];
                
                UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+space, 0, 100, 20)];
                itemLabel.centerY = itemView.height/2;
                itemLabel.text = itemArray[0];
                itemLabel.textColor = BlackTextColor;
                itemLabel.font = YBLFont(16);
                [itemView addSubview:itemLabel];
                
                UIImageView *arrowIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(YBLWindowWidth-space-10, 0, 10, 19)];
                arrowIamgeView.image = [UIImage imageNamed:@"found_arrow"];
                arrowIamgeView.centerY = itemView.height/2;
                [itemView addSubview:arrowIamgeView];
                
                UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
                clickButton.frame = [itemView bounds];
                clickButton.tag = tag_button+iindex;
                [clickButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
                [itemView addSubview:clickButton];
                
                [itemView addSubview:[YBLMethodTools addLineView:CGRectMake(space, itemView.height-.5, itemView.width, .5)]];
                iindex++;
            }
            
        }
        index++;
    }

    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    helpButton.frame = CGRectMake(0, 0, 200, 20);
    helpButton.centerX = self.view.width/2;
    [helpButton setTitle:@"信用体系服务协议" forState:UIControlStateNormal];
    [helpButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    helpButton.titleLabel.font = YBLFont(11);
    helpButton.bottom = YBLWindowHeight-kNavigationbarHeight-space;
    [self.view addSubview:helpButton];
    WEAK
    [[helpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_CreditServiceDelegate title:@"信用体系服务协议"];
        
    }];
    
    UIButton *helpButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    helpButton1.frame = CGRectMake(0, 0, 100, 20);
    helpButton1.bottom = helpButton.top;
    helpButton1.centerX = self.view.width/2;
    [helpButton1 setTitle:@"信用通协议" forState:UIControlStateNormal];
    [helpButton1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    helpButton1.titleLabel.font = YBLFont(11);
    [self.view addSubview:helpButton1];
    [[helpButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_CreditDelegate title:@"信用通协议"];
    }];
    
}

- (void)payClick:(UIButton *)btn{
    
    NSInteger index = btn.tag-tag_button+1;
    //默认
    WEAK
    [[self.viewModel signalForPayCreditsWithPayModel:index] subscribeError:^(NSError *error) {
    } completed:^{
        STRONG
        ///
        if (index == 1) {
            //支付宝
            [[AlipaySDK defaultService] payOrder:self.viewModel.payOrderModel.pay_url
                                      fromScheme:@"yuncai"
                                        callback:^(NSDictionary *resultDic) {
                                            NSLog(@"支付宝支付:%@-----",resultDic);
                                            int resultStatus = [resultDic[@"resultStatus"] intValue];
                                            BOOL isSuccess = NO;
                                            if (resultStatus == 9000 || resultStatus == 8000) {
                                                isSuccess = YES;
                                            }
                                            [self payResultWith:isSuccess];
                                        }];

        } else if (index == 2){
            //微信
            if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
            {
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = self.viewModel.payOrderModel.pay_url[@"appid"];
                req.partnerId           = self.viewModel.payOrderModel.pay_url[@"partnerid"];
                req.prepayId            = self.viewModel.payOrderModel.pay_url[@"prepayid"];
                req.nonceStr            = self.viewModel.payOrderModel.pay_url[@"noncestr"];
                req.timeStamp           = (UInt32)[self.viewModel.payOrderModel.pay_url[@"timestamp"] intValue];
                req.package             = self.viewModel.payOrderModel.pay_url[@"package"];;
                req.sign                = self.viewModel.payOrderModel.pay_url[@"sign"];
                
                [WXApi sendReq:req];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:@"未检测到您有安装微信客户端"];
            }

        }
    }];
}
        
//支付成功==>>查询支付结果
- (void)payResultWith:(BOOL)isSuccess{
    
    if (isSuccess) {
        
        [SVProgressHUD showWithStatus:@"查询支付结果..."];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self checkResult];
        });
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败!"];
    }
}

- (void)checkResult{
    
    
    WEAK
    [[self.viewModel signalForCheckPayResult] subscribeNext:^(NSNumber *x) {
        STRONG
        if (x.boolValue) {
            YBLPayResultModel *payModel = [YBLPayResultModel new];
            payModel.payWay = self.viewModel.payModel.serviceName;
            payModel.payMoney = @(self.viewModel.payModel.price.doubleValue);
            payModel.takeOrderType = self.viewModel.takeOrderType;
            YBLPayResultViewModel *viewModel = [YBLPayResultViewModel new];
            viewModel.payResultModel = payModel;
            YBLPayResultViewController *resultVC = [YBLPayResultViewController new];
            resultVC.viewModel = viewModel;
            [self.navigationController pushViewController:resultVC animated:YES];
        }
    } error:^(NSError *error) {
        
    }];
}


@end

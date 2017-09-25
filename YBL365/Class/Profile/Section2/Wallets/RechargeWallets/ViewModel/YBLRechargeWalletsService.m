//
//  YBLRechargeWalletsService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLRechargeWalletsService.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLRechargeItemCell.h"
#import "TextImageButton.h"
#import "YBLCreditsPayViewController.h"
#import "YBLRechargeWalletsHeaderView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "YBLPayResultViewController.h"

@interface YBLRechargeWalletsService ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak  ) YBLRechargeWalletsViewController *Vc;

@property (nonatomic, weak  ) YBLRechargeWalletsViewModel *viewModel;

@property (nonatomic, strong) YBLRechargeWalletsHeaderView *headerView;

@property (nonatomic, strong) UICollectionView *rechargeItemCollectionView;

@end

@implementation YBLRechargeWalletsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLRechargeWalletsViewModel *)viewModel;
        _Vc = (YBLRechargeWalletsViewController *)VC;
        
        [_Vc.view addSubview:self.headerView];
        [_Vc.view addSubview:self.rechargeItemCollectionView];
        
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
        
        ///请求数据
        [self.viewModel.rechargeWalletsSignal subscribeError:^(NSError *error) {
            
        } completed:^{
            [self.rechargeItemCollectionView jsReloadData];
        }];
        
        
    }
    return self;
}

- (YBLRechargeWalletsHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [[YBLRechargeWalletsHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 200)];
    }
    return _headerView;
}

- (UICollectionView *)rechargeItemCollectionView{
    
    if (!_rechargeItemCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.headerReferenceSize = CGSizeZero;
        CGFloat itemHi = (YBLWindowWidth/3)*2.5/5;
        layout.itemSize = CGSizeMake(YBLWindowWidth/3, itemHi);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _rechargeItemCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, YBLWindowWidth, YBLWindowHeight-kNavigationbarHeight-self.headerView.bottom)
                                                         collectionViewLayout:layout];
        _rechargeItemCollectionView.dataSource = self;
        _rechargeItemCollectionView.delegate = self;
        _rechargeItemCollectionView.showsVerticalScrollIndicator = NO;
        _rechargeItemCollectionView.backgroundColor = [UIColor whiteColor];
        [_rechargeItemCollectionView registerClass:NSClassFromString(@"YBLRechargeItemCell") forCellWithReuseIdentifier:@"YBLRechargeItemCell"];
    }
    return _rechargeItemCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.viewModel.rechargeDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLRechargeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YBLRechargeItemCell" forIndexPath:indexPath];
    
    YBLRechargeWalletsModel *model = self.viewModel.rechargeDataArray[indexPath.row];
    
    [cell updateItemModel:model];
    WEAK
    [[[cell.itemButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG

        /*
        YBLCreditPayModel *payModel = [YBLCreditPayModel new];
        payModel.price = [NSString stringWithFormat:@"%@",model.price];
        payModel.id = model.id;
        payModel.serviceName = @"云币充值";
        
        YBLCreditsPayViewModel *viewModel = [YBLCreditsPayViewModel new];
        viewModel.payModel = payModel;
        viewModel.takeOrderType = TakeOrderTypeRechargeYunMoeny;
        
        YBLCreditsPayViewController *payVC = [YBLCreditsPayViewController new];
        payVC.viewModel = viewModel;
        [self.Vc.navigationController pushViewController:payVC animated:YES];
         */
        self.viewModel.payModel.price = [NSString stringWithFormat:@"%@",model.price];
        self.viewModel.payModel.id = model.id;
        
        WEAK
        NSInteger index = self.headerView.currentPayIndex+1;
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
                
            } else if (index == 2 ){
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

    }];
    
    return cell;
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
            payModel.takeOrderType = TakeOrderTypeRechargeYunMoeny;
            YBLPayResultViewModel *viewModel = [YBLPayResultViewModel new];
            viewModel.payResultModel = payModel;
            YBLPayResultViewController *resultVC = [YBLPayResultViewController new];
            resultVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:resultVC animated:YES];
        }
    } error:^(NSError *error) {
        
    }];
}

@end

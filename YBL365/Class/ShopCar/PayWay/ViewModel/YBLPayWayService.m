//
//  YBLPayWayService.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPayWayService.h"
#import "YBLPayWayViewController.h"
#import "YBLPayResultViewController.h"
#import "YBLPayWayCashierView.h"
#import "YBLPayWayViewModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#pragma mark YBLPayWayCell

@interface YBLPayWayCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, retain) UILabel *nameLabel;

@property (nonatomic, retain) UILabel *infoLabel;

@property (nonatomic, strong) NSDictionary *dataDic;

+ (CGFloat)getPayWayCellHeight;

@end

@implementation YBLPayWayCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space_middle, space_middle, 50, 50)];
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+space, iconImageView.top, YBLWindowWidth-(iconImageView.right+space)-space*2-8, 20)];
    nameLabel.font = YBLFont(15);
    nameLabel.textColor = BlackTextColor;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 30)];
    infoLabel.numberOfLines = 0;
    infoLabel.textColor = YBLTextColor;
    infoLabel.font = YBLFont(12);
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"found_arrow"]];
    arrowImageView.frame = CGRectMake(0, 0, 8, 16.5);
    arrowImageView.center = CGPointMake(infoLabel.right+space+4, 40);
    [self addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(space, iconImageView.bottom+space_middle-0.5, YBLWindowWidth-space, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
    
}

- (void)setDataDic:(NSDictionary *)dataDic{
    
    NSString *name = dataDic[@"name"];
    NSString *image = dataDic[@"image"];
    NSString *info = dataDic[@"info"];
    self.nameLabel.text = name;
    self.iconImageView.image = [UIImage imageNamed:image];
    self.infoLabel.text = info;
}

+ (CGFloat)getPayWayCellHeight{
    
    return 80;
}

@end

#pragma mark YBLPayWayHeaderView

@interface YBLPayWayHeaderView : UITableViewHeaderFooterView

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *moneyLabel;

+ (CGFloat)getPayWayHeaderHeight;

@end

@implementation YBLPayWayHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, YBLWindowWidth/2-space, 40)];
    titleLabel.text = @"订单金额";
    titleLabel.font = YBLFont(14);
    titleLabel.textColor = YBLTextColor;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right, 0, self.titleLabel.width, self.titleLabel.height)];
    moneyLabel.textColor = YBLThemeColor;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    moneyLabel.text = @"222.22元";
    moneyLabel.font = YBLFont(14);
    [self addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40-0.5, YBLWindowWidth, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

+ (CGFloat)getPayWayHeaderHeight{
    
    return 40;
}

@end

#pragma mark service

@interface YBLPayWayService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) YBLPayWayViewController *VC;

@property (nonatomic, strong) UITableView *payWayTableView;

@property (nonatomic, strong) NSMutableArray *payDataArray;

@property (nonatomic, strong) YBLPayWayViewModel *viewModel;

@end

@implementation YBLPayWayService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLPayWayViewController *)VC;
        _viewModel = (YBLPayWayViewModel *)viewModel;
        
        [_VC.view addSubview:self.payWayTableView];
        
    }
    return self;
}

- (UITableView *)payWayTableView{
    
    if (!_payWayTableView) {
        _payWayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight) style:UITableViewStylePlain];
        _payWayTableView.dataSource = self;
        _payWayTableView.delegate   = self;
        _payWayTableView.showsVerticalScrollIndicator = NO;
        _payWayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payWayTableView.rowHeight = [YBLPayWayCell getPayWayCellHeight];
        _payWayTableView.sectionHeaderHeight = [YBLPayWayHeaderView getPayWayHeaderHeight];
        [_payWayTableView registerClass:NSClassFromString(@"YBLPayWayCell") forCellReuseIdentifier:@"YBLPayWayCell"];
        [_payWayTableView registerClass:NSClassFromString(@"YBLPayWayHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLPayWayHeaderView"];
    }
    return _payWayTableView;
}

- (NSMutableArray *)payDataArray{
    
    if (!_payDataArray) {
        _payDataArray = [NSMutableArray array];
        [_payDataArray addObject:@{@"name":@"我的钱包",@"image":@"myyuncai",@"info":@"没有手续费用,将退还到您的钱包 \n 我还有222枚云币,充足"}];
        [_payDataArray addObject:@{@"name":@"微信支付",@"image":@"weixin",@"info":@"没有手续费用,将已云币形式 \n 退还到您的钱包"}];
        [_payDataArray addObject:@{@"name":@"支付宝支付",@"image":@"zhifubao",@"info":@"没有手续费用,将已云币形式 \n 退还到您的钱包"}];;
    }
    return _payDataArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.payDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLPayWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLPayWayCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YBLPayWayHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLPayWayHeaderView"];
    
    return headerView;
}


- (void)configureCell:(YBLPayWayCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = self.payDataArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    PayWayCashierType cashierType = PayWayCashierTypeYunCai;
    
    switch (row) {
        case 0:
        {
            cashierType = PayWayCashierTypeYunCai;
        }
            break;
        case 1:
        {
            cashierType = PayWayCashierTypeWXPay;
        }
            break;
        case 2:
        {
            cashierType = PayWayCashierTypeAlipay;
            
        }
            break;
            
        default:
            break;
    }
    WEAK
    [YBLPayWayCashierView showPayWayCashierViewWithPayWayCashierType:cashierType
                                                           orderType:self.viewModel.payWay
                                           CashierSelectPayTypeBlock:^(PayWayCashierType type) {
                                               STRONG
                                               
                                               switch (type) {
                                                   case 0:
                                                   {
                                                       //
                                                   }
                                                       break;
                                                   case 1:
                                                   {
                                                       //wx
                                                       self.viewModel.payWayType = PayWayTypeWXPay;
                                                       
                                                       [self.viewModel.orderPaySignal subscribeError:^(NSError *error) {
                                                           
                                                       } completed:^{
                                                           if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
                                                           {
                                                               //调起微信支付
                                                               PayReq* req             = [[PayReq alloc] init];
                                                               req.openID              = self.viewModel.wxPayParaDict[@"appid"];
                                                               req.partnerId           = self.viewModel.wxPayParaDict[@"partnerid"];
                                                               req.prepayId            = self.viewModel.wxPayParaDict[@"prepayid"];
                                                               req.nonceStr            = self.viewModel.wxPayParaDict[@"noncestr"];
                                                               req.timeStamp           = (UInt32)[self.viewModel.wxPayParaDict[@"timestamp"] intValue];
                                                               req.package             = self.viewModel.wxPayParaDict[@"package"];;
                                                               req.sign                = self.viewModel.wxPayParaDict[@"sign"];
                                                               
                                                               [WXApi sendReq:req];
                                                               
                                                           }else{
                                                               
                                                               [SVProgressHUD showErrorWithStatus:@"未检测到您有安装微信客户端"];
                                                           }
                                                           
                                                       }];

                                                   }
                                                       break;
                                                   case 2:
                                                   {
                                                       //alipay
                                                       self.viewModel.payWayType = PayWayTypeAlipay;
                                                       
                                                       [self.viewModel.orderPaySignal subscribeError:^(NSError *error) {
                                                           
                                                       } completed:^{
                                                           
                                                           [[AlipaySDK defaultService] payOrder:self.viewModel.aliPayParaString
                                                                                     fromScheme:@"yuncai"
                                                                                       callback:^(NSDictionary *resultDic) {
                                                                                            NSLog(@"支付宝支付:%@-----",resultDic);
                                                                                           int resultStatus = [resultDic[@"resultStatus"] intValue];
                                                                                           if (resultStatus == 9000 || resultStatus == 8000) {
                                                                                               //支付成功
                                                                                               
                                                                                               
                                                                                           } else {
                                                                                               [SVProgressHUD showErrorWithStatus:@"支付失败!"];
                                                                                           }
                                                                                       }];
                                                           
                                                       }];
                                                   }
                                                       break;
                                                       
                                                   default:
                                                       break;
                                               }
                                               
                                               return ;
                                               YBLPayResultModel *payModel = [YBLPayResultModel new];
                                               payModel.payWay = @"在线支付";
                                               payModel.payMoney = @(0000);
                                               YBLPayResultViewModel *viewModel = [YBLPayResultViewModel new];
                                               viewModel.payResultModel = payModel;
                                               YBLPayResultViewController *payResultVC = [[YBLPayResultViewController alloc] init];
                                               payResultVC.viewModel = viewModel;
                                               [self.VC.navigationController pushViewController:payResultVC animated:YES];
     
                                           }];
    
}


@end

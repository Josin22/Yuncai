//
//  YBLPurchaseOutPriceRecordsService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseOutPriceRecordsService.h"
#import "YBLPurchaseOutPriceRecordsVC.h"
#import "YBLOrderMMOutPriceRecordsCell.h"
#import "YBLPurchaseOutPriceRecordsViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLOutPriceBar.h"
#import "YBLFoundTabBarViewController.h"
#import "YBLOrderDetailViewController.h"
#import "YBLEditPurchaseViewController.h"
#import "YBLGoodModel.h"
#import "YBLOutPriceHeaderView.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLEdictPurchaseViewModel.h"
#import "YBLNavigationViewController.h"
#import "YBLPurchaseBiddingVC.h"

@interface YBLPurchaseOutPriceRecordsService ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, weak  ) YBLPurchaseOutPriceRecordsVC *VC;
@property (nonatomic, strong) YBLPurchaseOutPriceRecordsViewModel *viewModel;

@property (nonatomic, strong) YBLOutPriceHeaderView *outPriceHeaderView;
@property (nonatomic, strong) YBLOutPriceBar *outPriceBar;
@property (nonatomic, strong) UITableView *OutPriceRecordsTableView;

@end

@implementation YBLPurchaseOutPriceRecordsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLPurchaseOutPriceRecordsVC *)VC;
        _viewModel = (YBLPurchaseOutPriceRecordsViewModel *)viewModel;
        
        [self requestISreload:YES];
    }
    return self;
}

- (void)requestISreload:(BOOL)isreload{
    
    [[self.viewModel siganlForPurchaseBidRecordsisReload:isreload] subscribeError:^(NSError * _Nullable error) {
        [self.OutPriceRecordsTableView.mj_header endRefreshing];
    } completed:^{
        [self.OutPriceRecordsTableView.mj_header endRefreshing];
        [self reloadView];
    }];
}

- (void)reloadView{
    [self.OutPriceRecordsTableView jsReloadData];
    [self.outPriceBar updateDataModel:self.viewModel.purchaseDetailModel];
    [self.outPriceHeaderView updateModel:self.viewModel.purchaseDetailModel];
}

-(UITableView *)OutPriceRecordsTableView{
    
    if (!_OutPriceRecordsTableView) {
        _OutPriceRecordsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowHeight-buttonHeight) style:UITableViewStylePlain];
        _OutPriceRecordsTableView.dataSource = self;
        _OutPriceRecordsTableView.delegate = self;
        _OutPriceRecordsTableView.emptyDataSetDelegate = self;
        _OutPriceRecordsTableView.emptyDataSetSource  = self;
        _OutPriceRecordsTableView.tableHeaderView = self.outPriceHeaderView;
        _OutPriceRecordsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        _OutPriceRecordsTableView.backgroundColor = [UIColor whiteColor];
        _OutPriceRecordsTableView.showsVerticalScrollIndicator = NO;
        _OutPriceRecordsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _OutPriceRecordsTableView.rowHeight = [YBLOrderMMOutPriceRecordsCell getItemCellHeightWithModel:nil];
        [_OutPriceRecordsTableView registerClass:NSClassFromString(@"YBLOrderMMOutPriceRecordsCell") forCellReuseIdentifier:@"YBLOrderMMOutPriceRecordsCell"];
        [_VC.view addSubview:_OutPriceRecordsTableView];
        
        if (self.viewModel.purchaseDetailModel.isMyselfPurchaseOrder) {
            _OutPriceRecordsTableView.height -= self.outPriceBar.height;
        }
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_OutPriceRecordsTableView completion:^{
            STRONG
            [self requestISreload:YES];
        }];

    }
    return _OutPriceRecordsTableView;
}

- (YBLOutPriceHeaderView *)outPriceHeaderView{
    
    if (!_outPriceHeaderView) {
        _outPriceHeaderView = [[YBLOutPriceHeaderView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 240)];
        [self.outPriceHeaderView updateModel:self.viewModel.purchaseDetailModel];
    }
    return _outPriceHeaderView;
}

- (void)requestCancleOrder{
    
    [[self.viewModel signalForCanclePurchaseOrder] subscribeNext:^(YBLPurchaseOrderModel *cancel_model) {
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        self.viewModel.purchaseDetailModel = cancel_model;
        [self reloadView];
        
    } error:^(NSError *error) {
    }];
}


- (YBLOutPriceBar *)outPriceBar{
    
    if (!_outPriceBar) {
        _outPriceBar = [[YBLOutPriceBar alloc] initWithFrame:CGRectMake(0, YBLWindowHeight-45-kNavigationbarHeight, YBLWindowWidth, 45)];
        [_VC.view addSubview:_outPriceBar];
        WEAK
        _outPriceBar.outPriceBarButtonClickBlock = ^(CurrentButtonType type){
            STRONG
            switch (type) {
#pragma mark 取消订单
                case CurrentButtonTypeCancle:
                {
                    if (!self.viewModel.purchaseDetailModel.spree_order_id) {
                        //查询是否扣除保证金
                        [[self.viewModel signalForJudgeCanclePurchaseOrderIsDeductBaozhengjin] subscribeNext:^(NSNumber *x) {
                            STRONG
                            if (x.boolValue) {
                                [SVProgressHUD dismiss];
                                //扣钱
                                [YBLOrderActionView showTitle:@"您确定取消订单吗? \n 订单取消系统会扣除您的订单保证金付给最低中标供应商"
                                                       cancle:@"我再想想"
                                                         sure:@"确定取消"
                                              WithSubmitBlock:^{
                                                  
                                                  [self requestCancleOrder];
                                              }
                                                  cancelBlock:^{
                                                      
                                                  }];
                            } else {
                                //不扣钱
                                [self requestCancleOrder];
                            }
                        } error:^(NSError *error) {
                        }];
                    } else {
                        //扣钱
                        [YBLOrderActionView showTitle:@"您确定取消订单吗? \n 订单取消系统会扣除您的订单保证金付给最低中标供应商"
                                               cancle:@"我再想想"
                                                 sure:@"确定取消"
                                      WithSubmitBlock:^{
                                          
                                          [self requestCancleOrder];
                                      }
                                          cancelBlock:^{}];

                    }
                }
                    break;
#pragma mark 确认采购
                case CurrentButtonTypeSurePurchase:
                {
                    [[self.viewModel signalForChooseBid] subscribeNext:^(NSNumber *x) {
                        if (x.boolValue) {
                            [SVProgressHUD showSuccessWithStatus:@"确认采购成功~"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (![YBLMethodTools popToMyPurchaseVCFrom:self.VC]) {
                                    [self.VC.navigationController popViewControllerAnimated:YES];
                                }
                            });
                        }
                    } error:^(NSError *error) {}];
                }
                    break;
#pragma mark 查看订单
                case CurrentButtonTypeLookOrder:
                {
                    YBLOrderItemModel *orderModel = [YBLOrderItemModel new];
                    orderModel.order_id = self.viewModel.purchaseDetailModel.spree_order_id;
                    YBLOrderDetailViewModel *detailVM = [YBLOrderDetailViewModel new];
                    detailVM.itemDetailModel = orderModel;
                    YBLOrderDetailViewController *detailVC = [YBLOrderDetailViewController new];
                    detailVC.viewModel = detailVM;
                    [self.VC.navigationController pushViewController:detailVC animated:YES];
                }
                    break;
#pragma mark 再次发布
                case CurrentButtonTypeReleaseAgain:
                {
                    float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:self.viewModel.purchaseDetailModel.quantity.integerValue Price:self.viewModel.purchaseDetailModel.price.doubleValue];
                    [[YBLEdictPurchaseViewModel signalReleasePurchaseForCheckGoldWith:baozhengjin] subscribeNext:^(YBLCheckGoldModel *checkModel) {
                        STRONG
                        if (checkModel.flag.boolValue) {
                            [YBLOrderActionView showTitle:@"是否要修改发布采购订单?"
                                                   cancle:@"修改发布"
                                                     sure:@"直接发布"
                                          WithSubmitBlock:^{
                                              STRONG
                                              [[self.viewModel signalForReleaseAgain] subscribeNext:^(YBLPurchaseOrderModel *purchaseOrderModel) {
                                                  if (![YBLMethodTools popToFoundVCFrom:self.VC]) {
                                                      [self.VC.navigationController popViewControllerAnimated:YES];
                                                  }
                                              } error:^(NSError *error) {}];
                                          }
                                              cancelBlock:^{
                                                  
                                                  YBLEdictPurchaseViewModel *viewModel = [YBLEdictPurchaseViewModel new];
                                                  viewModel.purchaseOrderModel = self.viewModel.purchaseDetailModel;
                                                  viewModel.purchaseEditPushType = PurchaseDetailPushTypeSepacial;
                                                  YBLEditPurchaseViewController *editPurchaseVC = [YBLEditPurchaseViewController new];
                                                  editPurchaseVC.viewModel = viewModel;
                                                  [self.VC.navigationController pushViewController:editPurchaseVC animated:YES];
                                                  
                                              }];

                        } else {
                            //2.云币不足,去充值
                            [YBLOrderActionView showTitle:checkModel.less_show_text
                                                   cancle:@"我再想想"
                                                     sure:@"立即充值"
                                          WithSubmitBlock:^{
                                              YBLRechargeWalletsViewController *walletsVC = [YBLRechargeWalletsViewController new];
                                              YBLNavigationViewController *bav = [[YBLNavigationViewController alloc] initWithRootViewController:walletsVC];
                                              [self.VC presentViewController:bav animated:YES completion:nil];
                                          }
                                              cancelBlock:^{}];

                        }
                        
                    } error:^(NSError * _Nullable error) {}];
                    
                }
                    break;
#pragma mark 开始报价
                case CurrentButtonTypeIwantOutPrice:{
                    
                    PurchaseBiddingParaModel *model = [PurchaseBiddingParaModel new];
                    model._id = self.viewModel.purchaseDetailModel._id;
                    model.price = self.viewModel.purchaseDetailModel.price;
                    float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:self.viewModel.purchaseDetailModel.quantity.integerValue
                                                                          Price:self.viewModel.purchaseDetailModel.price.doubleValue];;
                    
                    model.baozhengjinprice = @(baozhengjin);
                    
                    YBLPurchaseBiddingViewModel *viewModel = [[YBLPurchaseBiddingViewModel alloc] init];
                    viewModel.paraModel = model;
                    viewModel.purchaseDetailModel = self.viewModel.purchaseDetailModel;
                    YBLPurchaseBiddingVC *payVC = [[YBLPurchaseBiddingVC alloc] init];
                    payVC.viewModel = viewModel;
                    [self.VC.navigationController pushViewController:payVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _outPriceBar;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.recordsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    YBLOrderMMOutPriceRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOrderMMOutPriceRecordsCell" forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(YBLOrderMMOutPriceRecordsCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLPurchaseOrderModel *model = self.viewModel.recordsDataArray[row];
    [cell updateBiddingModel:model purchaseGoodModel:self.viewModel.purchaseDetailModel];
    cell.signLabel.signText = [NSString stringWithFormat:@"%@",@(row+1)];
    if ([model._id isEqualToString:self.viewModel.chooseBidModel._id]) {
        cell.selectButton.selected = YES;
    } else {
        cell.selectButton.selected = NO;
    }
    if (row == self.viewModel.recordsDataArray.count-PrestrainLessCount&&row>=PrestrainLessCount&&!self.viewModel.isNoMoreData) {
        [self requestISreload:NO];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    YBLPurchaseOrderModel *model = self.viewModel.recordsDataArray[row];
    if ([model._id isEqualToString:self.viewModel.chooseBidModel._id]) {
        return;
    }
    self.viewModel.chooseBidModel = model;
    [self.OutPriceRecordsTableView jsReloadData];
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无竞标记录";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return kNavigationbarHeight;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

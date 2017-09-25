//
//  YBLTakeOrderUIService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLTakeOrderUIService.h"
#import "YBLTakeOrderViewController.h"
#import "YBLOrderBannerView.h"
#import "YBLOrderAddressViewController.h"
#import "YBLPayWayViewController.h"
#import "YBLOrderStoreHeader.h"
#import "YBLOrderStoreFooter.h"
#import "YBLOrderGoodCell.h"
#import "YBLTakeOrderViewModel.h"
#import "YBLPayResultViewController.h"
#import "YBLSelectPayShipsMentViewController.h"
#import "YBLManyPayWayViewController.h"
#import "YBLTakeOrderModel.h"
#import "YBLAddInvoiceViewController.h"
#import "YBLTakeOrderParaItemModel.h"

@interface YBLTakeOrderUIService ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat addressViewHi;
}
@property (nonatomic, strong) YBLTakeOrderViewModel *viewModel;

@property (nonatomic, strong) YBLOrderBannerView *bannerView;

@property (nonatomic, weak  ) YBLTakeOrderViewController *VC;

@property (nonatomic, strong) UITableView *orderTabelView;

@end

@implementation YBLTakeOrderUIService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLTakeOrderViewController *)VC;
        _viewModel = (YBLTakeOrderViewModel *)viewModel;
        
        [_VC.view addSubview:self.orderTabelView];
        [_VC.view addSubview:self.addressView];
        [_VC.view addSubview:self.bannerView];

        [self adjustmentViewAndCalculateTotalPrice];
        ///
        RAC(self.bannerView.submitButton,enabled) = [RACSignal combineLatest:@[RACObserve(self.viewModel, isHaveAddress),
                                                                               RACObserve(self.viewModel, isCanTakeOrder)]
                                                                      reduce:^(NSNumber *x_isNoHaveAddress,NSNumber *x_isAllNoCanTakeOrder){
                                                                          return @(x_isNoHaveAddress.boolValue&&x_isAllNoCanTakeOrder.boolValue);
                                                                      }];
    }
    return self;
}

- (void)adjustmentViewAndCalculateTotalPrice{
    
    [self.addressView updateAdressModel:self.viewModel.orderConfirmModel.default_ship_address];
    
    addressViewHi = self.addressView.height;

    self.orderTabelView.contentInset = UIEdgeInsetsMake(self.addressView.height, 0, 0, 0);
    
    self.orderTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.addressView.height+self.bannerView.height)];
    
    self.bannerView.price = self.viewModel.orderConfirmModel.shops_total.doubleValue;
    
}

- (YBLOrderBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[YBLOrderBannerView alloc] initWithFrame:CGRectMake(0, self.VC.view.height - kBottomBarHeight - kNavigationbarHeight, YBLWindowWidth, kBottomBarHeight)];
        _bannerView.backgroundColor = [UIColor whiteColor];
        WEAK
#warning  commite order!!!!!!
        [[_bannerView.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            self.bannerView.submitButton.enabled = NO;
            
            [self.viewModel.commitSignal subscribeError:^(NSError *error) {
                STRONG
                self.bannerView.submitButton.enabled = NO;
            } completed:^{
                STRONG
                self.bannerView.submitButton.enabled = YES;
                //非在线支
                NSMutableArray *totalWay = @[].mutableCopy;
                for (YBLTakeOrderPaymentModel *paymentModel in self.viewModel.takeOrderModel.payments) {
                    [totalWay addObject:paymentModel.payment_method.name];
                }
                NSString *payWaY = [YBLMethodTools getAppendingStringWithArray:totalWay appendingKey:@"+"];;
                YBLPayResultModel *payModel = [YBLPayResultModel new];
                payModel.payWay = payWaY;
                payModel.payMoney = self.viewModel.takeOrderModel.total;
                payModel.takeOrderType = TakeOrderTypeNormalOrder;
                YBLPayResultViewModel *viewModel = [YBLPayResultViewModel new];
                viewModel.payResultModel = payModel;
                YBLPayResultViewController *payResultVC = [[YBLPayResultViewController alloc] init];
                payResultVC.viewModel = viewModel;
                [self.VC.navigationController pushViewController:payResultVC animated:YES];
                
                /*
                BOOL isHaveOn = NO;
                for (YBLTakeOrderPaymentModel *payM in self.viewModel.takeOrderModel.payments) {
                    if (([payM.payment_method.type isEqualToString:onlineString]||[payM.payment_method.type isEqualToString:expressString])&&([payM.state isEqualToString:@"checkout"]||[payM.state isEqualToString:@"balance_due"])) {
                        isHaveOn = YES;
                    }
                }
                if (self.viewModel.takeOrderModel.payments.count>=2&&isHaveOn) {
                    //多种支付合并
                    YBLManyPayWayViewModel *viewM = [YBLManyPayWayViewModel new];
                    viewM.paymentArray = self.viewModel.takeOrderModel.payments;
                    YBLManyPayWayViewController *manyVC = [[YBLManyPayWayViewController alloc] init];
                    manyVC.viewModel = viewM;
                    [self.VC.navigationController pushViewController:manyVC animated:YES];
                    
                } else if(isHaveOn){
                    //在线支付
                    YBLPayWayViewModel *viewModel = [YBLPayWayViewModel new];
                    viewModel.payWay = OrderTypeForwardOrder;
                    viewModel.takeOrderModel = self.viewModel.takeOrderModel;
                    YBLPayWayViewController *payVC = [[YBLPayWayViewController alloc] init];
                    payVC.viewModel = viewModel;
                    [self.VC.navigationController pushViewController:payVC animated:YES];
        
                } else {
                 
                }
                 */


            }];
            
        }];
        
    }
    return _bannerView;
}

- (YBLOrderAddressView *)addressView{
    
    if (!_addressView) {
//        addressViewHi = 70;
        _addressView = [[YBLOrderAddressView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, addressViewHi)];
        [_addressView updateAdressModel:self.viewModel.orderConfirmModel.default_ship_address];
        addressViewHi = _addressView.height;
        WEAK
        [[_addressView.addressButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            YBLAddressViewModel *viewModel = [YBLAddressViewModel new];
            viewModel.addressViewBlock = ^(YBLAddressModel *selectModel){
                STRONG
                if (!selectModel) {
                    return ;
                }
                if ([self.viewModel.orderConfirmModel.default_ship_address.id isEqualToString:selectModel.id]) {
                    return;
                }
                self.bannerView.submitButton.enabled = NO;
                [[self.viewModel orderConfirmSiganl:selectModel.id] subscribeError:^(NSError * _Nullable error) {
                    self.bannerView.submitButton.enabled = NO;
                } completed:^{
                    STRONG
                    self.bannerView.submitButton.enabled = self.viewModel.isCanTakeOrder;
                    self.viewModel.orderConfirmModel.default_ship_address = selectModel;
                    [self adjustmentViewAndCalculateTotalPrice];
                    [self.orderTabelView jsReloadData];
                }];
            };
            YBLOrderAddressViewController *addressVC = [[YBLOrderAddressViewController alloc] init];
            addressVC.viewModel = viewModel;
            [self.VC.navigationController pushViewController:addressVC animated:YES];
        }];
    }
    return _addressView;
}

- (UITableView *)orderTabelView{
    
    if (!_orderTabelView) {
        _orderTabelView = [[UITableView alloc] initWithFrame:[self.VC.view bounds] style:UITableViewStyleGrouped];
        _orderTabelView.dataSource = self;
        _orderTabelView.delegate = self;
        _orderTabelView.backgroundColor = [UIColor whiteColor];
        _orderTabelView.rowHeight = [YBLOrderGoodCell getOrderGoodCellHi];
        _orderTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTabelView.contentInset = UIEdgeInsetsMake(self.addressView.height, 0, 0, 0);
        _orderTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.addressView.height+self.bannerView.height)];
        [_orderTabelView registerClass:NSClassFromString(@"YBLOrderGoodCell") forCellReuseIdentifier:@"YBLOrderGoodCell"];
        [_orderTabelView registerClass:NSClassFromString(@"YBLOrderStoreHeader") forHeaderFooterViewReuseIdentifier:@"YBLOrderStoreHeader"];
        [_orderTabelView registerClass:NSClassFromString(@"YBLOrderStoreFooter") forHeaderFooterViewReuseIdentifier:@"YBLOrderStoreFooter"];
    }
    return _orderTabelView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.orderConfirmModel.shop_line_items count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    YBLCartModel *cartModel = self.viewModel.orderConfirmModel.shop_line_items[section];
    return [cartModel.line_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [YBLOrderStoreFooter getOrderStoreFooterHi];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return [YBLOrderStoreHeader getOrderStoreHeaderHi];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YBLOrderStoreFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLOrderStoreFooter"];
    YBLCartModel *cartModel = self.viewModel.orderConfirmModel.shop_line_items[section];
    [footer updateShopModel:cartModel];
    /**
     *  留言 票据 支付 配送方式
     */
    YBLTakeOrderParaItemModel *paraModel = self.viewModel.orderConfirmParaCopyArray[section];
    footer.liuyanTextFeild.text = paraModel.message;
    footer.invoiceLabel.text = paraModel.invoice.title;
    footer.zfps_1_label.text = [YBLMethodTools getAppendingPaymentTitleStringWithArray:paraModel.line_items appendingKey:@"+"];
    footer.zfps_2_label.text = [YBLMethodTools getAppendingShippingmentTitleStringWithArray:paraModel.line_items appendingKey:@"+"];
    WEAK
    /**
     *  留言
     */
    [[footer.liuyanTextFeild.rac_textSignal takeUntil:footer.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
        [paraModel setValue:x forKey:@"message"];
    }];
#pragma mark 支付配送方式
    /**
     *  支付配送
     */
    [[[footer.zhifupeisongBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:footer.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        if (cartModel.filter_line_items.count==0) {
            [SVProgressHUD showErrorWithStatus:@"该商品超出配送范围!"];
            return ;
        }
        YBLSelectPayShipsMentViewModel *viewModel = [YBLSelectPayShipsMentViewModel new];
        /**
         *  筛选后支配数据
         */
        viewModel.lineItemsArray = [cartModel.filter_line_items mutableCopy];
        /**
         *  支配参数
         */
        viewModel.paraLineItemsArray = paraModel.line_items;
        
        viewModel.index = section;
#pragma mark 支配防水选择的回调
        viewModel.selectPayShipsMentBlock = ^(NSInteger index,NSMutableArray *lineItemsArray){
            STRONG
            cartModel.filter_line_items = lineItemsArray;
            /**
             *  计算价格运费
             */
            float total = [self.viewModel ReCalculateCurrentSectionPrice:index];
            self.bannerView.price = total;
            [self.orderTabelView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
        };
        YBLSelectPayShipsMentViewController *payshippingVC = [[YBLSelectPayShipsMentViewController alloc] init];
        payshippingVC.viewModel = viewModel;
        [self.VC.navigationController pushViewController:payshippingVC animated:YES];
    }];
    /**
     *  票据
     */
    [[[footer.invoiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:footer.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        YBLAddInvoiceViewController *addInvoiceVC = [[YBLAddInvoiceViewController alloc] init];
        if (paraModel.invoice) {
            addInvoiceVC.invoiceModel = paraModel.invoice;
        }
        addInvoiceVC.addInvoiceBlock = ^(YBLInvoiceModel *invoiceModel){
            STRONG
            [paraModel setValue:invoiceModel forKey:@"invoice"];
            [self.orderTabelView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.VC.navigationController pushViewController:addInvoiceVC animated:YES];
    }];
    
    //
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YBLOrderStoreHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLOrderStoreHeader"];
    YBLCartModel *cartModel = self.viewModel.orderConfirmModel.shop_line_items[section];
    shop *shop = cartModel.shop;
    header.storeNameLabel.text = [NSString stringWithFormat:@"订单%@ : %@",@(section+1),shop.shopname];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOrderGoodCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLOrderGoodCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section = indexPath.section;
    YBLCartModel *cartModel = self.viewModel.orderConfirmModel.shop_line_items[section];
    lineitems *ietms = cartModel.line_items[indexPath.row];
    [cell updateItemsModel:ietms];
    
}

#pragma mark -  scroll delegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat contentY = scrollView.contentOffset.y;
    
    if (-contentY<=addressViewHi&&-contentY>=0) {
        self.addressView.top = -(addressViewHi+contentY);
    } else if(-contentY<0){
        self.addressView.top = -addressViewHi;
    } else if (-contentY>addressViewHi) {
        self.addressView.top = 0;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.VC.view endEditing:YES];
}


@end

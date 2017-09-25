//
//  YBLSelectPayShipsMentService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSelectPayShipsMentService.h"
#import "YBLSelectPayShipsMentViewModel.h"
#import "YBLSelectPayShipsMentViewController.h"
#import "YBLPayshipmentCell.h"
#import "YBLShowSelectAreaRadiusView.h"
#import "YBLSelectAddressView.h"
#import "YBLAddressModel.h"

@interface YBLSelectPayShipsMentService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) YBLSelectPayShipsMentViewController *ViewController;

@property (nonatomic, weak) YBLSelectPayShipsMentViewModel *viewModel;

@property (nonatomic, strong) UITableView *payshipmentTableView;

@end

@implementation YBLSelectPayShipsMentService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _ViewController = (YBLSelectPayShipsMentViewController *)VC;
        _viewModel = (YBLSelectPayShipsMentViewModel *)viewModel;
        
        [self.ViewController.view addSubview:self.payshipmentTableView];
        
        ///保存
        UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-kNavigationbarHeight-buttonHeight-space, YBLWindowWidth-2*space, buttonHeight)];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.ViewController.view addSubview:saveButton];
        WEAK
        [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            BOOL isAllSelect = [self.viewModel checkAllPayShippingmentIsSelect];
            if (!isAllSelect) {
                [SVProgressHUD showErrorWithStatus:@"支付配送方式还没有选择完整哟~"];
                return ;
            }
            /**
             *  映射
             */
            [self.viewModel handleParaPayShippingmentArray];
            
            BLOCK_EXEC(self.viewModel.selectPayShipsMentBlock,self.viewModel.index,self.viewModel.lineItemsArray)
            [self.ViewController.navigationController popViewControllerAnimated:YES];
        }];
    }
    return self;
}


- (UITableView *)payshipmentTableView{
    
    if (!_payshipmentTableView) {
        _payshipmentTableView = [[UITableView alloc] initWithFrame:[self.ViewController.view bounds] style:UITableViewStyleGrouped];
        _payshipmentTableView.dataSource = self;
        _payshipmentTableView.delegate = self;
        _payshipmentTableView.rowHeight = [YBLPayshipmentCell getHi];
        _payshipmentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payshipmentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+45)];
        [_payshipmentTableView registerClass:NSClassFromString(@"YBLPayshipmentCell") forCellReuseIdentifier:@"YBLPayshipmentCell"];
    }
    return _payshipmentTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.lineItemsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, headerView.width, headerView.height)];
    title.textColor = BlackTextColor;
    title.font = YBLFont(16);
    title.text = self.viewModel.titleArray[section];
    [headerView addSubview:title];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLPayshipmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLPayshipmentCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLPayshipmentCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    lineitems *itemModel = self.viewModel.lineItemsArray[row];
    if (section == 0) {
        cell.wayType = WayTypePay;
    } else if (section == 1) {
        cell.wayType = WayTypeShipping;
    }
    [cell updateModel:itemModel];
    WEAK
    cell.payshipmentCellButtonClickBlock = ^(id select_model, NSInteger index) {
        STRONG
        YBLShowPayShippingsmentModel *new_model = (YBLShowPayShippingsmentModel *)select_model;
        if (section == 0) {
            //支付方式
            //物流代收   相互制约->>物流自提
            if ([new_model.payment_method.type isEqualToString:@"PaymentMethod::ExpressCollecting"]) {
                
                [self showWLZTViewWithModel:new_model lineitemsModel:itemModel];
                
            } else {
                
                [self.viewModel resetPayShipmentLineitemsModel:itemModel isPayment:YES isWLZT:NO];
                
                [self savePaymentWithItemModel:new_model lineModel:itemModel isPayment:YES];
            }
            
        } else {
            //配送方式
            //物流自提  相互制约->>物流代收
            if ([new_model.shipping_method.code isEqualToString:@"wlzt"]) {
                [self showWLZTViewWithModel:new_model lineitemsModel:itemModel];
            }
            //上门自提
            else if ([new_model.shipping_method.code isEqualToString:@"smzt"]) {
                
                [YBLSelectAddressView showSelectAddressViewFromVC:self.ViewController.navigationController
                                                      addressData:new_model.addresses
                                                     addressGenre:AddressGenreTakeOrderSelectZiti
                                                       doneHandle:^(YBLAddressModel *selectAddressModel) {
                                                            [self.viewModel resetPayShipmentLineitemsModel:itemModel isPayment:NO isWLZT:NO];
//                                                           [new_model.addresses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                                               YBLAddressModel *selectAddressObj = (YBLAddressModel *)obj;
//                                                               if ([selectAddressObj.id isEqualToString:selectAddressModel.id]) {
//                                                                   selectAddressObj.is_select = YES;
//                                                                   *stop = YES;
//                                                               }
//                                                           }];
                                                           [self savePaymentWithItemModel:new_model lineModel:itemModel isPayment:NO];
                                                       }];
            } else {
                if (new_model.is_default.boolValue) {
                    return ;
                }
                [self.viewModel resetPayShipmentLineitemsModel:itemModel isPayment:NO isWLZT:NO];
                [self savePaymentWithItemModel:new_model lineModel:itemModel isPayment:NO];
            }
        }
    };
}

- (void)savePaymentWithItemModel:(YBLShowPayShippingsmentModel *)itemModel lineModel:(lineitems *)lineModel isPayment:(BOOL)isPayment{
    itemModel.is_default = @(YES);
    if (isPayment) {
        [lineModel setValue:itemModel forKey:@"select_product_payment_methods"];
    } else {
        [lineModel setValue:itemModel forKey:@"select_product_shipping_methods"];
    }
    [self.payshipmentTableView jsReloadData];
}


- (void)showWLZTViewWithModel:(YBLShowPayShippingsmentModel *)itemModel lineitemsModel:(lineitems *)lineitemsModel{
    
    //找到物流代收-->>弹出物流价格,若选择则,其支付配送方式点红
    [YBLShowSelectAreaRadiusView showselectAreaRadiusViewFromVC:self.ViewController.navigationController
                                             distanceRadiusType:DistanceRadiusTypeExpressPriceChoose
                                            areaRadiusDataArray:lineitemsModel.product.shipping_prices
                                                     doneHandle:^{
                                                         [self.viewModel resetPayShipmentLineitemsModel:lineitemsModel isPayment:NO isWLZT:YES];
                                                         [self.viewModel chooseWLZTShipPaymentModelWith:lineitemsModel];
                                                         [self.payshipmentTableView jsReloadData];
                                                     }];
}



@end

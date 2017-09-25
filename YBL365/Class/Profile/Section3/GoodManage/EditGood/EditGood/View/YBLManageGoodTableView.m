//
//  YBLManageGoodTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManageGoodTableView.h"
#import "YBLEditGoodViewModel.h"
#import "YBLEditItemGoodParaModel.h"
#import "YBLChooseAreaViewController.h"
#import "YBLEditGoodViewController.h"
#import "YBLSettingPayShippingMentVC.h"
#import "YBLCompanyTypePricesViewController.h"
#import "YBLGoodModel.h"
#import "YBLGoodsManageViewModel.h"
#import "YBLEditSaleDisplayAreaViewController.h"
#import "YBLChangeDeliveryGoodViewController.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"

@interface YBLManageGoodTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBLManageGoodTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate   = self;
        
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cellManageGoodDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLEditPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLEditPurchaseCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLEditPurchaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLEditItemGoodParaModel *paraModel = self.viewModel.cellManageGoodDataArray[row];
    [cell updateItemCellModel:paraModel];
    if (row == 0) {
        cell.good_switch.on = paraModel.value.boolValue;
    }
    WEAK
    [[cell.valueTextFeild.rac_textSignal takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString *x) {
        [paraModel setValue:x forKey:@"value"];
    }];
    
    [[[cell.good_switch rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (row == 0) {
            if (paraModel.value.boolValue) {
                //下架
                [[YBLGoodsManageViewModel siganlForChangeGoodStatusWithID:self.viewModel._id isOnline:NO] subscribeError:^(NSError * _Nullable error) {
                    
                } completed:^{
                    [SVProgressHUD showSuccessWithStatus:@"下架成功~"];
//                    self.viewModel.goodStatus = NO;
                    YBLGoodModel *goodModel = self.viewModel.productModel;
                    goodModel.state.value = @"offline";
                    self.viewModel.productModel = goodModel;
                    paraModel.value = [NSString stringWithFormat:@"%@",@(NO)];
                    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
            } else {
                //上架
                [[YBLGoodsManageViewModel siganlForChangeGoodStatusWithID:self.viewModel._id isOnline:YES] subscribeError:^(NSError * _Nullable error) {
                    
                } completed:^{
                    [SVProgressHUD showSuccessWithStatus:@"上架成功~"];
//                    self.viewModel.goodStatus = YES;
                    YBLGoodModel *goodModel = self.viewModel.productModel;
                    goodModel.state.value = @"online";
                    self.viewModel.productModel = goodModel;
                    paraModel.value = [NSString stringWithFormat:@"%@",@(YES)];
                    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }];
            }
            
        }
    }];
    
    [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([paraModel.paraString isEqualToString:@"xsqygl"]) {
            //销售区域设置
            /*
            YBLChooseAreaViewModel *viewModel = [YBLChooseAreaViewModel new];
            viewModel._id = self.viewModel._id;
            YBLChooseAreaViewController *chooseVC = [YBLChooseAreaViewController new];
            chooseVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:chooseVC animated:YES];
            */
            YBLEditSaleDisplayAreaViewModel *viewModel = [YBLEditSaleDisplayAreaViewModel new];
            viewModel._id = self.viewModel._id;
            YBLEditSaleDisplayAreaViewController *saleVC = [YBLEditSaleDisplayAreaViewController new];
            saleVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:saleVC animated:YES];

        } else if ([paraModel.paraString isEqualToString:@"pszffs"]) {
            
            //配送支付方式
            YBLSettingPayShippingMentViewModel *viewModel = [YBLSettingPayShippingMentViewModel new];
            viewModel._id = self.viewModel._id;
            YBLSettingPayShippingMentVC *payshippingVC = [YBLSettingPayShippingMentVC new];
            payshippingVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:payshippingVC animated:YES];
            
        } else if ([paraModel.paraString isEqualToString:@"xsjgyjqpslsz"]) {
            //多价格
            YBLCompanyTypePricesViewModel *viewModel = [YBLCompanyTypePricesViewModel new];
            viewModel.product_id = self.viewModel._id;
            viewModel.companyType_id = paraModel.paraString;
            viewModel.unitValue = self.viewModel.productModel.unit;
            viewModel.company_type_prices = self.viewModel.productModel.company_type_prices;
            YBLCompanyTypePricesViewController *priceVC = [YBLCompanyTypePricesViewController new];
            priceVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:priceVC animated:YES];
            
        } else if ([paraModel.paraString isEqualToString:@"spwlszqy"]) {
            //商品物流区域设置
            YBLChangeDeliveryGoodViewModel *viewModel = [YBLChangeDeliveryGoodViewModel new];
            viewModel._id = self.viewModel.productModel.id;
            YBLChangeDeliveryGoodViewController *deliverVC = [YBLChangeDeliveryGoodViewController new];
            deliverVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:deliverVC animated:YES];

        } else if ([paraModel.paraString isEqualToString:@"ktkdwlgl"]) {
            
            YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
            viewModel.listVCType = ListVCTypeSingleExpressCompany;
            YBLLogisticsCompanyAndGoodListViewController *lcaglVC = [YBLLogisticsCompanyAndGoodListViewController new];
            lcaglVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:lcaglVC animated:YES];
        }

    }];
}

@end

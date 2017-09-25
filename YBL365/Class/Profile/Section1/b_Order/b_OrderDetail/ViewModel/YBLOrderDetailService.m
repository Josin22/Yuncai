
//
//  YBLOrderDetailService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDetailService.h"
#import "YBLOrderDetailViewModel.h"
#import "YBLOrderDetailViewController.h"
#import "YBLOrderDetailContactFooterView.h"
#import "YBLOrderDetailStoreHeaderView.h"
#import "YBLOrderDetailPayMoneyCell.h"
#import "YBLOrderDetailTotalMoenyCell.h"
#import "YBLOrderDetailTextCell.h"
#import "YBLOrderGoodCell.h"
#import "YBLOrderDetailAddressCell.h"
#import "YBLOrderDetailNoStatusCell.h"
#import "YBLStoreViewController.h"
#import "YBLOrderDetailBarView.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLOrderDetailDeliverCell.h"
#import "YBLOrderViewModel.h"
#import "YBLPopWriteCodeView.h"
#import "YBLOrderDeliverViewController.h"


@interface YBLOrderDetailService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YBLOrderDetailViewModel *viewModel;

@property (nonatomic, weak  ) YBLOrderDetailViewController *Vc;

@property (nonatomic, strong) UITableView *orderDetailTableView;

@property (nonatomic, strong) YBLOrderDetailBarView *orderBarView;

@end

@implementation YBLOrderDetailService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLOrderDetailViewModel *)viewModel;
        _Vc = (YBLOrderDetailViewController *)VC;
        _viewModel.Vc = _Vc;
        
        [_Vc.view addSubview:self.orderDetailTableView];
        [_Vc.view addSubview:self.orderBarView];
        
        WEAK
        [YBLMethodTools headerRefreshWithTableView:self.orderDetailTableView completion:^{
            STRONG
            [self requestDetailOrder];
        }];
        
        [self requestDetailOrder];
    }
    return self;
}

- (void)requestDetailOrder{
    
    WEAK
    [self.viewModel.OrderDetailSignal subscribeError:^(NSError *error) {
        [self.orderDetailTableView.mj_header endRefreshing];
    } completed:^{
        STRONG
        [self.orderDetailTableView.mj_header endRefreshing];
        self.orderBarView.itemModel = self.viewModel.itemDetailModel;
        [self.orderDetailTableView jsReloadData];
    }];
    
}

- (void)goBack{
    BLOCK_EXEC(self.viewModel.orderStateBlock,self.viewModel.itemDetailModel);
    [self.Vc.navigationController popViewControllerAnimated:YES];
}

- (YBLOrderDetailBarView *)orderBarView{
    
    if (!_orderBarView) {
        _orderBarView = [[YBLOrderDetailBarView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight-50-20-kNavigationbarHeight, YBLWindowWidth, 50+20)
                                                         orderSource:self.viewModel.orderSource];
        /**
         *  判断按钮
         */
        WEAK
        _orderBarView.orderDetailBarViewClickBlock = ^(NSString *selectButtonText,YBLOrderPropertyItemModel *selectButtonModel,BOOL isSeller){
            STRONG
            
            [self.viewModel dealWithSellerAndBuyerCellButtonActionEventWithModel:self.viewModel.itemDetailModel
                                                                       indexPath:nil
                                                                    currentTitle:selectButtonText
                                                          orderPropertyItemModel:selectButtonModel
                                                                            cell:nil
                                                                        isSeller:isSeller
                                                                   isOrderDetail:YES
                                                                orderDeleteBlock:^{
                                                                    STRONG
                                                                    [self goBack];
                                                                }
                                                               orderRequestBlock:^{
                                                                   STRONG
                                                                   NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
                                                                   [self.orderDetailTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
                                                                   self.orderBarView.itemModel = self.viewModel.itemDetailModel;
                                                               }
                                                                currentTableView:nil];
        };
    }
    return _orderBarView;
}


- (UITableView *)orderDetailTableView{
    
    if (!_orderDetailTableView) {
        _orderDetailTableView = [[UITableView alloc] initWithFrame:[_Vc.view bounds] style:UITableViewStylePlain];
        _orderDetailTableView.dataSource = self;
        _orderDetailTableView.delegate = self;
        _orderDetailTableView.backgroundColor = [UIColor whiteColor];
        _orderDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 120+20)];
        NSArray *cellClassNameArray = @[@"YBLOrderDetailNoStatusCell",
                                        @"YBLOrderDetailAddressCell",
                                        @"YBLOrderGoodCell",
                                        @"YBLOrderDetailTextCell",
                                        @"YBLOrderDetailTotalMoenyCell",
                                        @"YBLOrderDetailPayMoneyCell",
                                        @"YBLOrderDetailDeliverCell"];
        NSArray *headerFooterArray = @[@"YBLOrderDetailStoreHeaderView",
                                       @"YBLOrderDetailContactFooterView"];
        for (NSString *className in cellClassNameArray) {
            [_orderDetailTableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
        }
        for (NSString *headerFooter in headerFooterArray) {
            [_orderDetailTableView registerClass:NSClassFromString(headerFooter) forHeaderFooterViewReuseIdentifier:headerFooter];
        }
        
    }
    return _orderDetailTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.viewModel.oderDetailCellArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSArray *cellArray = dataDict[cell_identity_key];
    if ([cellArray[0] isEqualToString:@"YBLOrderGoodCell"]) {
        if (cellArray.count>2) {
            if (self.viewModel.isShowAllGood) {
                return cellArray.count;
            } else {
                return 2;
            }
        }
    }
    return cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[cell_identity_key][row];
    
    if ([cellName isEqualToString:@"YBLOrderDetailNoStatusCell"]) {
        
        return [YBLOrderDetailNoStatusCell getHi];
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailDeliverCell"]) {
        
        return [YBLOrderDetailDeliverCell getHi];
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailAddressCell"]) {
        YBLAddressModel *addressModel = dataDict[cell_data_identity_key];
        return [YBLOrderDetailAddressCell getItemCellHeightWithModel:addressModel];
        
    } else if ([cellName isEqualToString:@"YBLOrderGoodCell"]) {
        
        return [YBLOrderGoodCell getOrderGoodCellHi];
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailTextCell"]) {
        
        return [YBLOrderDetailTextCell getHi];

    } else if ([cellName isEqualToString:@"YBLOrderDetailTotalMoenyCell"]) {
        
        return [YBLOrderDetailTotalMoenyCell getHi];
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailPayMoneyCell"]) {
        
        return [YBLOrderDetailPayMoneyCell getItemCellHeightWithModel:self.viewModel.itemDetailModel];
        
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[footer_identity_key];
    
    if ([cellName isEqualToString:@"YBLOrderDetailContactFooterView"]) {
        
        NSMutableArray *cellArray1 = dataDict[cell_identity_key];
        BOOL isFullTwoGoodCount = cellArray1.count > 2?YES:NO;
        return [YBLOrderDetailContactFooterView getHi:isFullTwoGoodCount];
        
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[header_identity_key];
    
    if ([cellName isEqualToString:@"YBLOrderDetailStoreHeaderView"]) {
        
        return [YBLOrderDetailStoreHeaderView getHi];
        
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[footer_identity_key];
    
    if ([cellName isEqualToString:@"YBLOrderDetailContactFooterView"]) {
        
        YBLOrderDetailContactFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellName];
        
        NSMutableArray *cellArray1 = dataDict[cell_identity_key];
        BOOL isFullTwoGoodCount = cellArray1.count > 2?YES:NO;
        footer.isHaveTwoCount = isFullTwoGoodCount;
        footer.moreButton.selected = self.viewModel.isShowAllGood;
        if (self.viewModel.orderSource == OrderSourceBuyer||self.viewModel.orderSource == OrderSourcePurchaseBuyer) {
            [footer.contactButton setTitle:@"联系卖家" forState:UIControlStateNormal];
        } else {
            [footer.contactButton setTitle:@"联系买家" forState:UIControlStateNormal];
        }
        WEAK
        //更多
        [[[footer.moreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:footer.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
            STRONG
            self.viewModel.isShowAllGood = !self.viewModel.isShowAllGood;
            [self.orderDetailTableView jsReloadData];
        }];
        //联系人
        [[[footer.contactButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:footer.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            if (self.viewModel.orderSource == OrderSourceBuyer) {
                [YBLMethodTools callWithNumber:self.viewModel.itemDetailModel.seller_mobile];
            } else {
                [YBLMethodTools callWithNumber:self.viewModel.itemDetailModel.customer_mobile];
            }
            
        }];
        
        return footer;
        
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[header_identity_key];
    
    if ([cellName isEqualToString:@"YBLOrderDetailStoreHeaderView"]) {
        
        YBLOrderDetailStoreHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellName];
        [header.storeButton setTitle:self.viewModel.itemDetailModel.seller_shopname forState:UIControlStateNormal];
        WEAK
        [[[header.storeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:header.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            if (!self.viewModel.itemDetailModel.purchase_order) {
                YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
                viewModel.shopid = self.viewModel.itemDetailModel.seller_id;
                YBLStoreViewController *storeVC = [YBLStoreViewController new];
                storeVC.viewModel = viewModel;
                [self.Vc.navigationController pushViewController:storeVC animated:YES];
            }
        }];
        return header;
        
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[cell_identity_key][row];
    
    if ([cellName isEqualToString:@"YBLOrderDetailNoStatusCell"]) {
        
        YBLOrderDetailNoStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.orderNoLabel.text = [NSString stringWithFormat:@"订单号:%@",self.viewModel.itemDetailModel.number];
        cell.orderStatusLabel.text = self.viewModel.itemDetailModel.state_cn;
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailDeliverCell"]) {
        
        YBLOrderDetailDeliverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOrderDetailDeliverCell"
                                                                          forIndexPath:indexPath];
        WEAK
        [[[cell.undefineButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            YBLOrderDeliverViewModel *viewModel = [YBLOrderDeliverViewModel new];
            viewModel.orderID = self.viewModel.itemDetailModel.order_id;
            viewModel.orderNo = self.viewModel.itemDetailModel.number;
            YBLOrderDeliverViewController *deliverVc = [YBLOrderDeliverViewController new];
            deliverVc.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:deliverVc animated:YES];
        }];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailAddressCell"]) {
        
        YBLOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        YBLAddressModel *addressModel = dataDict[cell_data_identity_key];
        
//        [cell.addressView updateAdressModel:addressModel];
        [cell updateItemCellModel:addressModel];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderGoodCell"]) {

        YBLOrderGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray *cellDataArray = dataDict[cell_data_identity_key];
        
        [cell updateItemsModel:cellDataArray[row]];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailTextCell"]) {
        
        YBLOrderDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *dataArray = dataDict[cell_data_identity_key];
        cell.titleLabel.text = dataArray[0][row];
        cell.valueLabel.text = dataArray[1][row];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailTotalMoenyCell"]) {
        
        YBLOrderDetailTotalMoenyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.viewModel.itemDetailModel.item_total.doubleValue];
        cell.yunfeiLabel.text = [NSString stringWithFormat:@"¥%.2f",self.viewModel.itemDetailModel.shipment_total.doubleValue];
        
        return cell;
        
    } else if ([cellName isEqualToString:@"YBLOrderDetailPayMoneyCell"]) {
        
        
        YBLOrderDetailPayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
        
        [cell updateItemCellModel:self.viewModel.itemDetailModel];
        
        return cell;
        
    } else {
        return 0;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSDictionary *dataDict = self.viewModel.oderDetailCellArray[section];
    NSString *cellName = dataDict[cell_identity_key][row];
    
    if ([cellName isEqualToString:@"YBLOrderGoodCell"]&&!self.viewModel.itemDetailModel.purchase_order) {
        
        lineitems *itemModel = self.viewModel.itemDetailModel.line_items[row];
        YBLGoodsDetailViewModel *viewModel = [YBLGoodsDetailViewModel new];
        viewModel.goodID = itemModel.product.id;
        YBLGoodsDetailViewController *goodDetailVC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
        goodDetailVC.viewModel = viewModel;
        [self.Vc.navigationController pushViewController:goodDetailVC animated:YES];
    }
}


@end

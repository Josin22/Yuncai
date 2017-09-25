//
//  YBLChooseDeliveryService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseDeliveryService.h"
#import "YBLChooseDeliveryViewModel.h"
#import "YBLChooseDeliveryViewController.h"
#import "YBLFourLevelAddressHeaderView.h"
#import "YBLChooseDeliveryGoodAndLogisticsCompanyCell.h"
#import "YBLSetLogisticsPricesCell.h"
#import "YBLExpressCompanyItemModel.h"
#import "YBLLogisticsCompanyAndGoodListViewController.h"

@interface YBLChooseDeliveryService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) YBLChooseDeliveryViewController *Vc;

@property (nonatomic, strong) YBLChooseDeliveryViewModel *viewModel;

@property (nonatomic, strong) UITableView *chooseDeliveryTableView;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) YBLFourLevelAddressHeaderView *headerView;

@end

@implementation YBLChooseDeliveryService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLChooseDeliveryViewModel *)viewModel;
        _Vc = (YBLChooseDeliveryViewController *)VC;

        [_Vc.view addSubview:self.chooseDeliveryTableView];
        [_Vc.view addSubview:self.saveButton];
        /**
         *  获取已开通快递物流物流
         */
        WEAK
        [[self.viewModel validExpressCompaniesSiganl] subscribeError:^(NSError * _Nullable error) {
            
        } completed:^{
            STRONG
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.chooseDeliveryTableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    return self;
}

- (UITableView *)chooseDeliveryTableView{
    if (!_chooseDeliveryTableView) {
        _chooseDeliveryTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStyleGrouped];
        _chooseDeliveryTableView.dataSource = self;
        _chooseDeliveryTableView.delegate = self;
        _chooseDeliveryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chooseDeliveryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+buttonHeight)];
        [_chooseDeliveryTableView registerClass:NSClassFromString(@"YBLFourLevelAddressHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLFourLevelAddressHeaderView"];
        [_chooseDeliveryTableView registerClass:NSClassFromString(@"YBLChooseDeliveryGoodAndLogisticsCompanyCell") forCellReuseIdentifier:@"YBLChooseDeliveryGoodAndLogisticsCompanyCell"];
        [_chooseDeliveryTableView registerClass:NSClassFromString(@"YBLSetLogisticsPricesCell") forCellReuseIdentifier:@"YBLSetLogisticsPricesCell"];
    }
    return _chooseDeliveryTableView;
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-kNavigationbarHeight-buttonHeight-space, YBLWindowWidth-2*space, buttonHeight)];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        WEAK
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if (![self.viewModel isHaveSelectGoods]) {
                [SVProgressHUD showErrorWithStatus:@"您还没有选中商品~"];
                return ;
            }
            if (![self.viewModel isHaveSelectExpressCompany]) {
                [SVProgressHUD showErrorWithStatus:@"您还没有选中物流快递~"];
                return ;
            }
            YBLFourLevelAddressHeaderView *headerView = (YBLFourLevelAddressHeaderView *)[self.chooseDeliveryTableView headerViewForSection:2];
            if (headerView.viewModel.selectAreaDataDict.count==0) {
                [SVProgressHUD showErrorWithStatus:@"您还没有选中地区~"];
                return ;
            }
            //保存
            [[self.viewModel siganlForSettingShippingsPricesWith:headerView.viewModel.selectAreaDataDict] subscribeError:^(NSError * _Nullable error) {
                
            } completed:^{
                STRONG
                [self.Vc.navigationController popViewControllerAnimated:YES];
            }];
            
        }];
    }
    return _saveButton;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        //区域快递
        return self.viewModel.addToAreaAddressArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        
        return [YBLFourLevelAddressHeaderView getHeaderViewHeight];
    }
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        
        if (!self.headerView) {
            YBLFourLevelAddressHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLFourLevelAddressHeaderView"];
            self.headerView = headerView;
        }
        return self.headerView;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return space;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    if (section == 2) {
        
        return [YBLSetLogisticsPricesCell getItemCellHeightWithModel:nil];
    }
    return [YBLChooseDeliveryGoodAndLogisticsCompanyCell getItemCellHeightWithModel:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 2) {
        
        YBLSetLogisticsPricesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLSetLogisticsPricesCell" forIndexPath:indexPath];
        
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
        
    } else {

        YBLChooseDeliveryGoodAndLogisticsCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLChooseDeliveryGoodAndLogisticsCompanyCell" forIndexPath:indexPath];

        [cell updateSection:section];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /* update value */
        if (section == 1) {
            [cell updateItemCellModel:self.viewModel.selectExpressCompanyArray];
        } else {
            [cell updateItemCellModel:self.viewModel.selectGoodsArray];
        }
        WEAK
        /**
         *  选中cell
         */
        cell.chooseDeliveryGoodAndLogisticsCompanyCellItemBlock = ^(id model) {
            STRONG
            if (section == 1) {
                [self.chooseDeliveryTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        /**
         *  添加物流 商品
         */
        cell.chooseDeliveryGoodAndLogisticsCompanyCellButtonClickBlock = ^{
            STRONG
            ListVCType type = ListVCTypeGood;
            NSMutableArray *tempArray = nil;
            if (section == 0) {
                //店铺商品
                type = ListVCTypeGood;
                tempArray = self.viewModel.selectGoodsArray;
            } else {
                //快递
                type = ListVCTypeExpressCompany;
                tempArray = self.viewModel.selectExpressCompanyArray;
            }
            YBLLogisticsCompanyAndGoodListViewModel *viewModel = [YBLLogisticsCompanyAndGoodListViewModel new];
            viewModel.listVCType = type;
            viewModel.openedExpressCompanyGoodListDataArray = tempArray;
            viewModel.logisticsCompanyAndGoodListBlock = ^(NSMutableArray *selectArray) {
                STRONG
                if (section == 0) {
                    self.viewModel.selectGoodsArray = selectArray;
                } else {
                    self.viewModel.selectExpressCompanyArray = selectArray;
                    [self.chooseDeliveryTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
                }
                [self.chooseDeliveryTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            };
            YBLLogisticsCompanyAndGoodListViewController *lcaglVC = [YBLLogisticsCompanyAndGoodListViewController new];
            lcaglVC.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:lcaglVC animated:YES];
        };
        return cell;
    }

}

- (void)configureCell:(YBLSetLogisticsPricesCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLExpressCompanyItemModel *itemModel = self.viewModel.addToAreaAddressArray[row];
    [cell updateItemCellModel:itemModel];
    /**
     *  快递费
     */
    cell.addSubView.currentFloatChangeBlock = ^(float doubleValue, YBLAddSubtractView *addSubView,BOOL isButtonClick) {
        
        [itemModel setValue:@(doubleValue) forKey:@"price"];
    };
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.Vc.view endEditing:YES];
}

@end

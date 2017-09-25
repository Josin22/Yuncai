//
//  YBLCompanyTypePricesService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCompanyTypePricesService.h"
#import "YBLCompanyTypePricesViewModel.h"
#import "YBLCompanyTypePricesViewController.h"
#import "YBLCompanyTypePricesHeaderView.h"
#import "YBLCompanyTypePriceItemCell.h"
#import "YBLCompanyTypePricesParaModel.h"

@interface YBLCompanyTypePricesService ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, weak  ) YBLCompanyTypePricesViewController *Vc;

@property (nonatomic, strong) YBLCompanyTypePricesViewModel *viewModel;

@property (nonatomic, strong) UITableView *priceTableView;

@end

@implementation YBLCompanyTypePricesService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLCompanyTypePricesViewController *)VC;
        _viewModel = (YBLCompanyTypePricesViewModel *)viewModel;
        [self.Vc.view addSubview:self.priceTableView];
        
        UIButton *saveButton = [YBLMethodTools getNextButtonWithFrame:CGRectMake(space, YBLWindowHeight-buttonHeight-kNavigationbarHeight-space, YBLWindowWidth-space*2, buttonHeight)];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitle:@"保存" forState:UIControlStateDisabled];
        saveButton.enabled = NO;
        [_Vc.view addSubview:saveButton];
        
        WEAK
        [[saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            [[self.viewModel siganlForSettingCompanyTypePrices] subscribeError:^(NSError * _Nullable error) {
                
            } completed:^{
                [SVProgressHUD showSuccessWithStatus:@"设置成功~"];
                [self.Vc.navigationController popViewControllerAnimated:YES];
            }];
        }];

        /*rac*/
        [[self.viewModel siganlForTwoLeverlCompanyTypeData] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            STRONG
            saveButton.enabled = YES;
            [self.priceTableView jsReloadData];
            [self showUpDown:YES];
        }];
    }
    return self;
}

- (void)showUpDown:(BOOL)isShow{
    
    for (YBLCompanyTypePricesParaModel *itemModel in self.viewModel.pricesDataArray) {
        itemModel.isNotShowRow = isShow;
    }
    [self.priceTableView jsReloadData];
}

- (UITableView *)priceTableView{
    
    if (!_priceTableView) {
        _priceTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        _priceTableView.dataSource = self;
        _priceTableView.delegate = self;
        _priceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _priceTableView.rowHeight = [YBLCompanyTypePriceItemCell getItemCellHeightWithModel:nil];
        _priceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight+buttonHeight)];
        [_priceTableView registerClass:NSClassFromString(@"YBLCompanyTypePriceItemCell") forCellReuseIdentifier:@"YBLCompanyTypePriceItemCell"];
        [_priceTableView registerClass:NSClassFromString(@"YBLCompanyTypePricesHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLCompanyTypePricesHeaderView"];
    }
    return _priceTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.pricesDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    YBLCompanyTypePricesParaModel *sectionModel = self.viewModel.pricesDataArray[section];
    if (sectionModel.isNotShowRow) {
        return 0;
    }
    return sectionModel.prices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [YBLCompanyTypePricesHeaderView  getHeaderHi];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YBLCompanyTypePricesHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLCompanyTypePricesHeaderView"];
    
    YBLCompanyTypePricesParaModel *sectionModel = self.viewModel.pricesDataArray[section];
    
    [headerView updatePriceArray:sectionModel];
    WEAK
    headerView.companyTypePricesHeaderViewDirectionButtonBlock = ^(BOOL isShow) {
        STRONG
        [sectionModel setValue:@(isShow) forKey:@"isNotShowRow"];
        [self.priceTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    //
    [[[headerView.priceSwitch rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(__kindof UISwitch * _Nullable x) {
        STRONG
        [sectionModel setValue:@(x.isOn) forKey:@"active"];
        for (PricesItemModel *itemModel in sectionModel.prices) {
            itemModel.active = @(x.isOn);
        }
        if (section == 0) {
            [self.viewModel resetMin:-1
                           salePrice:-1
                    fromIndexOfArray:-1
                             section:section
                  isAllButtonnAction:YES
                         isPureWrite:NO];
            [self.priceTableView reloadData];
        } else {
            [self.priceTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

    }];
  
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@",sectionModel.company_title];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLCompanyTypePriceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLCompanyTypePriceItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLCompanyTypePriceItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    YBLCompanyTypePricesParaModel *sectionModel = self.viewModel.pricesDataArray[section];
    PricesItemModel *model = sectionModel.prices[row];
    [cell updateItemCellModel:model];
    //
    WEAK
    //开关
    [[[cell.numCell.good_switch rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UISwitch * _Nullable x) {
        STRONG
        [model setValue:@(x.isOn) forKey:@"active"];
        NSInteger itemCount = 0;
        for (PricesItemModel *itemModel in sectionModel.prices) {
            if (!itemModel.active.boolValue) {
                itemCount++;
            }
        }
        BOOL isNotSectionAllSwitchOn = YES;
        if (itemCount==3) {
            isNotSectionAllSwitchOn = NO;
        }
        [sectionModel setValue:@(isNotSectionAllSwitchOn) forKey:@"active"];
        YBLCompanyTypePricesHeaderView *headerView = (YBLCompanyTypePricesHeaderView *)[self.priceTableView headerViewForSection:section];
        [headerView updatePriceArray:sectionModel];
        
        
        if (section == 0) {
            [self.viewModel resetMin:model.min.integerValue
                           salePrice:model.sale_price.doubleValue
                    fromIndexOfArray:row
                             section:section
                  isAllButtonnAction:NO
                         isPureWrite:YES];
            [self.priceTableView reloadData];
        }
    }];
    //数量
    cell.companyTypePriceItemCellNumTextfieldBlock = ^(NSString *text) {
        STRONG
        [model setValue:@(text.integerValue) forKey:@"min"];
        YBLCompanyTypePricesHeaderView *headerView = (YBLCompanyTypePricesHeaderView *)[self.priceTableView headerViewForSection:section];
        [headerView updatePriceArray:sectionModel];
//        [self.priceTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (section == 0) {
            [self.viewModel resetMin:model.min.integerValue
                           salePrice:-1
                    fromIndexOfArray:row
                             section:section
                  isAllButtonnAction:NO
                         isPureWrite:YES];
            [self.priceTableView reloadData];
        }

    };
    //价格
    cell.companyTypePriceItemCellPriceTextfieldBlock = ^(NSString *text) {
        STRONG
        [model setValue:@(text.doubleValue) forKey:@"sale_price"];
        YBLCompanyTypePricesHeaderView *headerView = (YBLCompanyTypePricesHeaderView *)[self.priceTableView headerViewForSection:section];
        [headerView updatePriceArray:sectionModel];
        if (section == 0) {
            [self.viewModel resetMin:-1
                           salePrice:model.sale_price.doubleValue
                    fromIndexOfArray:row
                             section:section
                  isAllButtonnAction:NO
                         isPureWrite:YES];
            [self.priceTableView reloadData];
        }

    };
    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.Vc.view endEditing:YES];
}

@end

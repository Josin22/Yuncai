//
//  YBLShopCarService.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLShopCarService.h"
#import "YBLShopCarViewController.h"
#import "YBLShopCarItemCell.h"
#import "YBLShopCarFooterView.h"
#import "YBLShopCarStoreHeaderView.h"
#import "YBLTakeOrderViewController.h"
#import "YBLGoodsDetailViewController.h"
#import "YBLStoreViewController.h"
#import "YBLLoginViewController.h"
#import "YBLNavigationViewController.h"
#import "YBLFooterSignView.h"
#import "YBLShopCarViewModel.h"

@interface YBLShopCarService ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    CGFloat top;
}
@property (nonatomic, weak) YBLShopCarViewController *VC;
@property (nonatomic, weak) YBLShopCarViewModel *viewModel;

@end

@implementation YBLShopCarService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLShopCarViewController *)VC;
        _viewModel = (YBLShopCarViewModel *)viewModel;
        
        top = 0;
        if (self.viewModel.carVCType == CarVCTypeNormal) {
            top = kBottomBarHeight;
        }
    
    }
    return self;
}
/**
 *  请求购物车
 */
- (void)requestShopCarData{
    
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        self.barView.buyButton.enabled = NO;
        [[self.viewModel shopCarSigal] subscribeError:^(NSError *error) {
            [self.carTableView.mj_header endRefreshing];
        } completed:^{
            [self.carTableView.mj_header endRefreshing];
            self.barView.buyButton.enabled = YES;
            [self.viewModel selectAll:YES];
            if (self.viewModel.shopCartDataArray.count!=0) {
                self.barView.hidden = NO;
            } else {
                self.barView.hidden = YES;
            }
            [self.carTableView jsReloadData];
        }];
        
    } else {
        self.viewModel.shopCartDataArray = nil;
        [self.carTableView jsReloadData];
        self.barView.hidden = YES;
    }
}

- (YBLShopCarBarView *)barView{
    
    if (!_barView) {
        _barView = [[YBLShopCarBarView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight-kNavigationbarHeight-kBottomBarHeight-top, YBLWindowWidth, kBottomBarHeight)];
        _viewModel.barView = _barView;
        _barView.hidden = YES;
        WEAK
        ///全选
        [[_barView.checkButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            STRONG
            x.selected = !x.selected;
            [self.viewModel selectAll:x.selected];
        }];
        ///确认
        [[_barView.buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *xButton) {
           STRONG
            xButton.enabled = NO;
            [[self.viewModel confirmSignal] subscribeError:^(NSError * _Nullable error) {
                xButton.enabled = YES;
            } completed:^{
                xButton.enabled = YES;
                STRONG
                if (self.viewModel.noStockCartDataArray.count>0) {
                    [YBLOrderActionView showTitle:[NSString stringWithFormat:@"当前%ld款商品库存不足,是否继续购买?",(unsigned long)self.viewModel.noStockCartDataArray.count]
                                           cancle:@"返回购物车"
                                             sure:@"去结算"
                                  WithSubmitBlock:^{
                                      STRONG
                                      [self pushOrderConfirmVC];
                                  }
                                      cancelBlock:^{
                                          STRONG
                                          [self requestShopCarData];
                                      }];
                } else {
                    [self pushOrderConfirmVC];
                }
            }];
        }];
        
    }
    return _barView;
}

- (void)pushOrderConfirmVC{
    
    YBLTakeOrderViewModel *viewModel = [[YBLTakeOrderViewModel alloc] init];
    viewModel.orderConfirmParaArray = self.viewModel.orderConfirmParaArray;
    viewModel.orderConfirmModel = self.viewModel.orderConfirmModel;
    YBLTakeOrderViewController *takeOrderVC = [[YBLTakeOrderViewController alloc] init];
    takeOrderVC.viewModel = viewModel;
    [YBLMethodTools pushVc:takeOrderVC withNavigationVc:self.VC.navigationController];
}

- (UITableView *)carTableView{
    
    if (!_carTableView) {
        _carTableView = [[UITableView alloc] initWithFrame:[self.VC.view bounds] style:UITableViewStylePlain];
        [_VC.view addSubview:_carTableView];
        _viewModel.cartTableView = _carTableView;
        [_VC.view addSubview:self.barView];
        _carTableView.dataSource = self;
        _carTableView.delegate  = self;
        _carTableView.emptyDataSetSource = self;
        _carTableView.emptyDataSetDelegate = self;
        _carTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _carTableView.rowHeight = [YBLShopCarItemCell getItemCellHi];
        [_carTableView registerClass:NSClassFromString(@"YBLShopCarItemCell") forCellReuseIdentifier:@"YBLShopCarItemCell"];
        [_carTableView registerClass:NSClassFromString(@"YBLShopCarFooterView") forHeaderFooterViewReuseIdentifier:@"YBLShopCarFooterView"];
        [_carTableView registerClass:NSClassFromString(@"YBLShopCarStoreHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLShopCarStoreHeaderView"];
        _carTableView.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, self.barView.height+top)];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_carTableView completion:^{
            STRONG
            [self requestShopCarData];
        }];
    }
    return _carTableView;
}

#pragma mark - data source

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.shopCartDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    YBLCartModel *cartModel = self.viewModel.shopCartDataArray[section];
    return [cartModel.line_items count];
}

#pragma mark - header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    YBLCartModel *cartModel = self.viewModel.shopCartDataArray[section];
    shop *shop = cartModel.shop;
    
    YBLShopCarStoreHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLShopCarStoreHeaderView"];
    
    [headerView updataShop:shop];
    
    WEAK
    [[[headerView.checkAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        x.selected = !x.selected;
        [self.viewModel sectionSelect:x.selected section:section];

    }];
    
    [[[headerView.storeButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
        viewModel.shopid = shop.shopid;
        YBLStoreViewController *storeVC = [[YBLStoreViewController alloc] init];
        storeVC.viewModel = viewModel;
        [self.VC.navigationController pushViewController:storeVC animated:YES];
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [YBLShopCarStoreHeaderView getHeaderHi];
}

#pragma mark - footer

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    YBLShopCarFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YBLShopCarFooterView"];
    
    YBLCartModel *cartModel = self.viewModel.shopCartDataArray[section];
    [footerView updataSingleSectionGood:cartModel];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return [YBLShopCarFooterView getFooterHi];
}

#pragma mark - cell

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLShopCarItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLShopCarItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLShopCarItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBLCartModel *cartModel = self.viewModel.shopCartDataArray[indexPath.section];
    lineitems *ietms = cartModel.line_items[indexPath.row];
    [cell updateItemsModel:ietms];
    //单选
    WEAK
    [[[cell.checkAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        STRONG
        [self.viewModel rowSelectButton:x IndexPath:indexPath];
    }];
    //加减
    cell.addSubtractView.currentCountChangeBlock = ^(NSInteger count,YBLAddSubtractView *addSubView,BOOL isButtonClick){
      STRONG
        
        [[self.viewModel signalForChangeItemQuantity:[@[@{@"line_item_id":ietms.line_item_id,@"quantity":@(count)}] mutableCopy]] subscribeNext:^(NSNumber *x) {
            STRONG
            addSubView.isEnableButton = x.boolValue;
            if (x.boolValue) {
                [self.viewModel rowChangeQuantity:count indexPath:indexPath];
            }
            
        } error:^(NSError *error) {
            addSubView.isEnableButton = YES;
        }];
    
    };
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    YBLCartModel *cartModel = self.viewModel.shopCartDataArray[indexPath.section];
    lineitems *ietms = cartModel.line_items[indexPath.row];
    
    YBLGoodsDetailViewModel *viewModel = [YBLGoodsDetailViewModel new];
    viewModel.goodID = ietms.product.id;
    YBLGoodsDetailViewController *VC = [[YBLGoodsDetailViewController alloc] initWithType:GoodsDetailTypeDefault];
    VC.viewModel = viewModel;
    [self.VC.navigationController pushViewController:VC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YBLCartModel *cartModel = self.viewModel.shopCartDataArray[indexPath.section];
        lineitems *ietms = cartModel.line_items[indexPath.row];
        WEAK
        [[self.viewModel signalForDeleteCartItem:[@[ietms.itemid] mutableCopy]] subscribeNext:^(NSNumber *x) {
            STRONG
            if (x.boolValue) {
                [self.viewModel deleteGoodsBySingleSlide:indexPath];
                [SVProgressHUD showSuccessWithStatus:@"删除成功~"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"删除失败~"];
            }
        } error:^(NSError *error) {
            
        }];
        
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"cartNoContentIcon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        text = @"购物车是空的";
    } else {
        text = @"您还未登录呢,请先登录";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *buttonString = nil;
    
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        buttonString = @"逛逛首页";
    } else {
        buttonString = @"去登录";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: YBLThemeColor};
    
    return [[NSAttributedString alloc] initWithString:buttonString attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if ([YBLMethodTools checkLoginWithVc:self.VC]) {
        [self.VC.tabBarController setSelectedIndex:0];
        if (self.viewModel.carVCType == CarVCTypeSpecial) {
            [self.VC.navigationController popToRootViewControllerAnimated:NO];
        }

    }
    /*
    if ([YBLUserManageCenter shareInstance].isLoginStatus) {
        [self.VC.tabBarController setSelectedIndex:0];
        if (self.viewModel.carVCType == CarVCTypeSpecial) {
            [self.VC.navigationController popToRootViewControllerAnimated:NO];
        }
    } else {
        
        YBLLoginViewController *loginVC = [[YBLLoginViewController alloc] init];
        YBLNavigationViewController *nav = [[YBLNavigationViewController alloc] initWithRootViewController:loginVC];
        [self.VC presentViewController:nav animated:YES completion:^{
            
        }];
    }
     */
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.VC.view endEditing:YES];
}

@end

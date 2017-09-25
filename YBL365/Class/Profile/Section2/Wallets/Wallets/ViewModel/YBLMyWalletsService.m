//
//  YBLMyWalletsService.m
//  YC168
//
//  Created by 乔同新 on 2017/3/30.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyWalletsService.h"
#import "YBLMyWalletsViewController.h"
#import "YBLWalletsRecordsItemCell.h"
#import "YBLWalletsHeaderView.h"
#import "YBLWalletsTitleHeaderView.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLWalletsRecordModel.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLRewardViewController.h"
#import "YBLCouponsManageViewController.h"

@interface YBLMyWalletsService ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak  ) YBLMyWalletsViewController *Vc;

@property (nonatomic, strong) YBLMyWalletsViewModel *viewModel;

@property (nonatomic, strong) YBLWalletsHeaderView *headerView;

@property (nonatomic, strong) UITableView *walletsTableView;

@end

@implementation YBLMyWalletsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLMyWalletsViewModel *)viewModel;
        _Vc = (YBLMyWalletsViewController *)VC;
    
        ///
        [self requestDataisReload:YES];
    }
    return self;
}


- (void)requestDataisReload:(BOOL)isReload{
    WEAK
    [[self.viewModel siganlForWalletsIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.walletsTableView.mj_header endRefreshing];
        if (isReload) {
            NSString *fronzeValue = @"个";
            id attributes = nil;
            if (self.viewModel.frozen_gold.integerValue>0) {
                
                fronzeValue = [NSString stringWithFormat:@"个 (冻结%@)",self.viewModel.frozen_gold];
                NSString *fullString = [NSString stringWithFormat:@"%.2f%@",self.viewModel.gold.doubleValue,fronzeValue];
                NSInteger kongrange = [fullString rangeOfString:@" "].location;
                attributes = @[[NSDictionary fn_dictionaryWithAttribute:@{NSFontAttributeName:YBLBFont(35),
                                                                          NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                                  range:NSMakeRange(0, kongrange-1)],
                               [NSDictionary fn_dictionaryWithAttribute:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                          NSFontAttributeName:YBLFont(15)}
                                                                  range:NSMakeRange(kongrange-1, fullString.length-kongrange+1)]];
            } else {
                NSString *goldString = [NSString stringWithFormat:@"%.2f个",self.viewModel.gold.doubleValue];
                attributes = @[[NSDictionary fn_dictionaryWithAttribute:@{NSFontAttributeName:YBLBFont(35),
                                                                          NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                                  range:NSMakeRange(0, goldString.length)]];
            }
            [self.headerView.yunMoneyLabel fn_setNumber:self.viewModel.gold duration:1.0f format:[@"%.2f" stringByAppendingString:fronzeValue] attributes:attributes];

        }
        self.walletsTableView.dataArray = self.viewModel.singleDataArray;
        [self.walletsTableView jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } error:^(NSError * _Nullable error) {
        [self.walletsTableView.mj_header endRefreshing];
    }];
    
    /*
    WEAK
    [[self.viewModel siganlForWallets] subscribeError:^(NSError * _Nullable error) {
        [self.walletsTableView.mj_header endRefreshing];
    } completed:^{
        STRONG
        [self.walletsTableView.mj_header endRefreshing];
        [self.walletsTableView jsReloadData];
        NSString *fronzeValue = @"个";
        id attributes = nil;
        if (self.viewModel.walletsModel.frozen_gold.integerValue>0) {
            
            fronzeValue = [NSString stringWithFormat:@"个 (冻结%@)",self.viewModel.walletsModel.frozen_gold];
            NSString *fullString = [NSString stringWithFormat:@"%.2f%@",self.viewModel.walletsModel.gold.doubleValue,fronzeValue];
            NSInteger kongrange = [fullString rangeOfString:@" "].location;
            attributes = @[[NSDictionary fn_dictionaryWithAttribute:@{NSFontAttributeName:YBLBFont(35),
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                              range:NSMakeRange(0, kongrange-1)],
                              [NSDictionary fn_dictionaryWithAttribute:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                         NSFontAttributeName:YBLFont(15)}
                                                              range:NSMakeRange(kongrange-1, fullString.length-kongrange+1)]];
        } else {
            NSString *goldString = [NSString stringWithFormat:@"%.2f个",self.viewModel.walletsModel.gold.doubleValue];
            attributes = @[[NSDictionary fn_dictionaryWithAttribute:@{NSFontAttributeName:YBLBFont(35),
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                              range:NSMakeRange(0, goldString.length)]];
        }
        [self.headerView.yunMoneyLabel fn_setNumber:self.viewModel.walletsModel.gold duration:1.0f format:[@"%.2f" stringByAppendingString:fronzeValue] attributes:attributes];
    }];
*/
}

- (YBLWalletsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YBLWalletsHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, (YBLWindowHeight-kNavigationbarHeight)/3)];
        WEAK
        [[_headerView.unfineButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            [SVProgressHUD showInfoWithStatus:@"此功能即将上线 \n 敬请期待!"];
            YBLCouponsManageViewModel *viewModel = [[YBLCouponsManageViewModel alloc] initWithCouponsListType:CouponsListTypeCustomerMine];
            YBLCouponsManageViewController *rewardVc = [YBLCouponsManageViewController new];
            rewardVc.viewModel = viewModel;
            [self.Vc.navigationController pushViewController:rewardVc animated:YES];
        }];
        [[_headerView.goRechargeWalletsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            STRONG
            YBLRechargeWalletsViewController *rechargeVC = [[YBLRechargeWalletsViewController alloc] init];
            [self.Vc.navigationController pushViewController:rechargeVC animated:YES];
        }];
        
    } 
    return _headerView;
}

- (UITableView *)walletsTableView{
    
    if (!_walletsTableView) {
        _walletsTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        [_Vc.view addSubview:_walletsTableView];
        _walletsTableView.dataSource = self;
        _walletsTableView.delegate = self;
        _walletsTableView.emptyDataSetSource = self;
        _walletsTableView.emptyDataSetDelegate = self;
        _walletsTableView.backgroundColor = [UIColor whiteColor];
        _walletsTableView.tableHeaderView = self.headerView;
        _walletsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        _walletsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_walletsTableView registerClass:NSClassFromString(@"YBLWalletsRecordsItemCell") forCellReuseIdentifier:@"YBLWalletsRecordsItemCell"];
        [_walletsTableView registerClass:NSClassFromString(@"YBLWalletsTitleHeaderView") forHeaderFooterViewReuseIdentifier:@"YBLWalletsTitleHeaderView"];
        WEAK
        [YBLMethodTools headerRefreshWithTableView:_walletsTableView completion:^{
            STRONG
            [self requestDataisReload:YES];
        }];
        
        
    }
    return _walletsTableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.singleDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = indexPath.row;
    YBLWalletflowsItemModel *itemModel =self.viewModel.singleDataArray[row];
    return [YBLWalletsRecordsItemCell getItemCellHeightWithModel:itemModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLWalletsRecordsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLWalletsRecordsItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLWalletsRecordsItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLWalletflowsItemModel *itemModel =self.viewModel.singleDataArray[row];
    [cell updateItemCellModel:itemModel];
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.viewModel.singleDataArray.count currentRow:row]) {
        if ([self.viewModel isSatisfyLoadMoreRequest]) {
            [self requestDataisReload:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = indexPath.row;
    YBLWalletflowsItemModel *itemModel =self.viewModel.singleDataArray[row];
    if (itemModel.purchase_order_id.length>0) {
        YBLPurchaseOrderModel *purModel  = [YBLPurchaseOrderModel new];
        purModel._id = itemModel.purchase_order_id;
        YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
        viewModel.purchaseDetailModel = purModel;
        YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
        detailVC.viewModel = viewModel;
        [self.Vc.navigationController pushViewController:detailVC animated:YES];
    }
    
}


#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_wallets_data";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}


@end

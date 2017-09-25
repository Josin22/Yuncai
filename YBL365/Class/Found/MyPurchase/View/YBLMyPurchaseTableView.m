//
//  YBLMyPurchaseTableView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyPurchaseTableView.h"
#import "YBLMyPurchaseCell.h"
#import "YBLPayWayViewController.h"
#import "YBLFoundMyPurchaseViewController.h"
#import "YBLMyPurchaseViewModel.h"
#import "YBLPurchaseOrderModel.h"
#import "YBLPurchaseGoodsDetailVC.h"
#import "YBLPurchaseOutPriceRecordsViewModel.h"
#import "YBLOrderDetailViewController.h"
#import "YBLEditPurchaseViewController.h"
#import "YBLPurchaseOutPriceRecordsVC.h"
#import "YBLPurchaseBiddingVC.h"
#import "YBLMyWalletsViewController.h"
#import "YBLEdictPurchaseViewModel.h"
#import "YBLNavigationViewController.h"
#import "YBLRechargeWalletsViewController.h"

@interface YBLMyPurchaseTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) MyPurchaseType type;

@end

@implementation YBLMyPurchaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style PurchaseType:(MyPurchaseType)type{
    
    if (self = [super initWithFrame:frame style:style]) {
        _type = type;
        
        [self initTbv];
    }
    return self;
}
- (void)initTbv{
    
    self.showsVerticalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.dataSource = self;
    self.delegate   = self;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    [self registerClass:NSClassFromString(@"YBLMyPurchaseCell") forCellReuseIdentifier:@"YBLMyPurchaseCell"];
    self.rowHeight = [YBLMyPurchaseCell getItemCellHeightWithModel:nil];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLMyPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLMyPurchaseCell" forIndexPath:indexPath];
    [self configureMyPurchaseOrderCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureMyPurchaseOrderCell:(YBLMyPurchaseCell *)cell
                   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBLPurchaseOrderModel *model = self.dataArray[indexPath.row];
    
    [cell updateItemCellModel:model];
    
    WEAK
    
    __weak typeof(YBLMyPurchaseCell) *weakCell = cell;
    
    cell.myPurchaseCellButtonBlock = ^(YBLPurchaseOrderModel *selectModel, NSString *currentTitle) {
        STRONG
        if ([currentTitle isEqualToString:purchase_order_button_cancel]) {
#pragma mark 取消订单
            if (!model.spree_order_id) {
                //查询是否扣除保证金
                [[YBLPurchaseOutPriceRecordsViewModel signalForJudgeCanclePurchaseOrderIsDeductBaozhengjinOrderid:model._id] subscribeNext:^(NSNumber *x) {
                    if (x.boolValue) {
                        [SVProgressHUD dismiss];
                        //扣钱
                        [YBLOrderActionView showTitle:@"您确定取消订单吗? \n 订单取消系统会扣除您的订单保证金付给最低报价供应商"
                                               cancle:@"我再想想"
                                                 sure:@"确定取消"
                                      WithSubmitBlock:^{
                                          STRONG
                                          [self requestCancleOrderWith:model._id get_cell:weakCell];
                                      }
                                          cancelBlock:^{}];
                    } else {
                        //不扣钱
                        [self requestCancleOrderWith:model._id get_cell:weakCell];
                    }
                } error:^(NSError *error) {}];
            } else {
                //扣钱
                [YBLOrderActionView showTitle:@"您确定取消订单吗? \n 订单取消系统会扣除您的订单保证金付给最低报价供应商"
                                       cancle:@"我再想想"
                                         sure:@"确定取消"
                              WithSubmitBlock:^{
                                  STRONG
                                  [self requestCancleOrderWith:model._id get_cell:weakCell];
                              }
                                  cancelBlock:^{}];
            }
            
            
        } else if ([currentTitle isEqualToString:purchase_order_button_lookOrderString]||[currentTitle isEqualToString:purchase_order_button_outPriceSuccess]) {
#pragma mark  查看订单
#pragma mark  报价成功
            YBLOrderItemModel *orderModel = [YBLOrderItemModel new];
            YBLPurchaseOrderModel *detailModel = model;
            orderModel.order_id = detailModel.spree_order_id;
            YBLOrderDetailViewModel *detailVM = [YBLOrderDetailViewModel new];
            detailVM.itemDetailModel = orderModel;
            YBLOrderDetailViewController *detailVC = [YBLOrderDetailViewController new];
            detailVC.viewModel = detailVM;
            [YBLMethodTools pushVC:detailVC FromeUndefineVC:self.VC];
            
        } else if ([currentTitle isEqualToString:purchase_order_button_release_again1]||[currentTitle isEqualToString:purchase_order_button_release_again2]){
#pragma mark 再次发布 重新发布
            [SVProgressHUD showWithStatus:@"加载中..."];
            float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:model.quantity.integerValue Price:model.price.doubleValue];
            [[YBLEdictPurchaseViewModel signalReleasePurchaseForCheckGoldWith:baozhengjin] subscribeNext:^(YBLCheckGoldModel *checkModel) {
                STRONG
                if (checkModel.flag.boolValue) {
                    [YBLOrderActionView showTitle:@"是否要修改发布采购订单?"
                                           cancle:@"修改发布"
                                             sure:@"直接发布"
                                  WithSubmitBlock:^{
                                      /**
                                       *  发布采购订单
                                       */
                                      [[YBLPurchaseOutPriceRecordsViewModel signalForReleaseAgainWithId:model._id] subscribeNext:^(YBLPurchaseOrderModel *purchaseOrderModel) {
                                          STRONG
                                          [SVProgressHUD showSuccessWithStatus:@"发布成功~"];
                                          [self.dataArray insertObject:purchaseOrderModel atIndex:0];
                                          NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:0] ;
                                          [self jsInsertRowIndexps:@[indexP] withRowAnimation:UITableViewRowAnimationAutomatic];
                                      } error:^(NSError *error) {}];
                                  }
                                      cancelBlock:^{
                                          STRONG
                                          [SVProgressHUD dismiss];
                                          /**
                                           *  编辑发布采购订单
                                           */
                                          YBLEdictPurchaseViewModel *viewModel = [YBLEdictPurchaseViewModel new];
                                          viewModel.purchaseOrderModel = model;
                                          viewModel.purchaseEditPushType = PurchaseDetailPushTypeSepacial;
                                          YBLEditPurchaseViewController *editPurchaseVC = [YBLEditPurchaseViewController new];
                                          editPurchaseVC.viewModel = viewModel;
                                          [YBLMethodTools pushVC:editPurchaseVC FromeUndefineVC:self.VC];
                                      }];

                } else {
                    //
                    [SVProgressHUD dismiss];
                    
                    [YBLOrderActionView showTitle:checkModel.less_show_text
                                           cancle:@"我再想想"
                                             sure:@"立即充值"
                                  WithSubmitBlock:^{
                                      STRONG
                                      YBLRechargeWalletsViewController *walletsVC = [YBLRechargeWalletsViewController new];
                                      YBLNavigationViewController *bav = [[YBLNavigationViewController alloc] initWithRootViewController:walletsVC];
                                      [self.VC presentViewController:bav animated:YES completion:nil];
                                      
                                  }    cancelBlock:^{
                                      
                                  }];
                }
            }];
            
        } else if ([currentTitle isEqualToString:purchase_order_button_look_price]){
#pragma mark 查看竞价
            YBLPurchaseOutPriceRecordsViewModel *viewModel = [[YBLPurchaseOutPriceRecordsViewModel alloc] init];
            viewModel.purchaseDetailModel = model;
            YBLPurchaseOutPriceRecordsVC *recordsVC= [[YBLPurchaseOutPriceRecordsVC alloc] init];
            recordsVC.viewModel = viewModel;
            [self.VC.navigationController pushViewController:recordsVC animated:YES];
            
        } else if ([currentTitle isEqualToString:purchase_order_button_bidding_again]||[currentTitle isEqualToString:purchase_order_button_out_price_again]){
#pragma mark 再次竞价 
#pragma mark 再次报价
            PurchaseBiddingParaModel *bid_model = [PurchaseBiddingParaModel new];
            bid_model._id = model._id;
            bid_model.price = model.price;
            float baozhengjin = [YBLMethodTools getBaozhengJINWithCount:model.quantity.integerValue
                                                                  Price:model.price.doubleValue];;
            bid_model.baozhengjinprice = @(baozhengjin);
            YBLPurchaseBiddingViewModel *viewModel = [[YBLPurchaseBiddingViewModel alloc] init];
            viewModel.paraModel = bid_model;
            viewModel.purchaseDetailModel = model;
            YBLPurchaseBiddingVC *payVC = [[YBLPurchaseBiddingVC alloc] init];
            payVC.viewModel = viewModel;
            [self.VC.navigationController pushViewController:payVC animated:YES];
        } else if ([currentTitle isEqualToString:purchase_order_button_lookMyYunDou]||[currentTitle isEqualToString:PurchaseBarButtonRecharge]){
#pragma mark 查看云币
            YBLMyWalletsViewController *myWalletsVC = [YBLMyWalletsViewController new];
            [self.VC.navigationController pushViewController:myWalletsVC animated:YES];
            
        }
    };
    
#pragma mark 点击商品跳转商品详情
    [[[cell.clickPurchaseGoodButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        YBLPurchaseGoodDetailViewModel *viewModel = [YBLPurchaseGoodDetailViewModel new];
        viewModel.purchaseDetailModel = model;
        YBLPurchaseGoodsDetailVC *detailVC = [[YBLPurchaseGoodsDetailVC alloc] init];
        detailVC.viewModel = viewModel;
        [YBLMethodTools pushVC:detailVC FromeUndefineVC:self.VC];
    }];
    
    BOOL isSatisfy = [YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:indexPath.row];
    if (isSatisfy) {
        //  在这个地方调用加载更多数据的方法。
        BLOCK_EXEC(self.myPurchasePrestrainBlock,)
    }
}

- (void)requestCancleOrderWith:(NSString *)purchaseId get_cell:(YBLMyPurchaseCell *)cell{
    WEAK
    [[YBLPurchaseOutPriceRecordsViewModel signalForCanclePurchaseOrder:purchaseId] subscribeNext:^(YBLPurchaseOrderModel *cancel_model) {
        STRONG
        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
        NSIndexPath *getPath = [self indexPathForCell:cell];
        [self.dataArray removeObjectAtIndex:getPath.row];
        [self.dataArray insertObject:cancel_model atIndex:getPath.row];
        [self reloadRowsAtIndexPaths:@[getPath] withRowAnimation:UITableViewRowAnimationFade];
    } error:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLPurchaseOrderModel *model = self.dataArray[indexPath.row];
    YBLPurchaseOutPriceRecordsViewModel *viewModel = [[YBLPurchaseOutPriceRecordsViewModel alloc] init];
    viewModel.purchaseDetailModel = model;
    YBLPurchaseOutPriceRecordsVC *recordsVC= [[YBLPurchaseOutPriceRecordsVC alloc] init];
    recordsVC.viewModel = viewModel;
    [self.VC.navigationController pushViewController:recordsVC animated:YES];
    
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无采购记录,快来采购吧！";
    if (self.type == MyPurchaseTypePurchaseRecords) {
        text = @"暂无报价记录,快去报价吧！";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

//
//  YBLOrderDeliverService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDeliverService.h"
#import "YBLOrderDeliverViewController.h"
#import "YBLOrderDeliverViewModel.h"
#import "YBLOrderDeliverItemCell.h"
#import "YBLDeliveritemModel.h"
#import "YBLActionSheetView.h"
#import "YBLOrderExpressImageBrowerVC.h"

@interface YBLOrderDeliverService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak  ) YBLOrderDeliverViewController *Vc;

@property (nonatomic, strong) YBLOrderDeliverViewModel *viewModel;

@property (nonatomic, strong) UITableView *deliverTableView;

@end

@implementation YBLOrderDeliverService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLOrderDeliverViewController *)VC;
        _viewModel = (YBLOrderDeliverViewModel *)viewModel;
        
        [self requestDeliver];
        
        WEAK
        [YBLMethodTools headerRefreshWithTableView:self.deliverTableView completion:^{
            STRONG
            [self requestDeliver];
        }];
    }
    return self;
}

- (void)requestDeliver{
 
    WEAK
    [self.viewModel.deliverSignal subscribeError:^(NSError * _Nullable error) {
        STRONG
        [self.deliverTableView.mj_header endRefreshing];
    } completed:^{
        STRONG
        [self.deliverTableView.mj_header endRefreshing];
        [self.deliverTableView jsReloadData];
    }];
    
}

- (UITableView *)deliverTableView{
    if (!_deliverTableView) {
        _deliverTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        [_Vc.view addSubview:_deliverTableView];
        _deliverTableView.dataSource = self;
        _deliverTableView.delegate = self;
//        _deliverTableView.rowHeight = [YBLOrderDeliverItemCell getItemCellHeightWithModel:nil];
        _deliverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _deliverTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        [_deliverTableView registerClass:NSClassFromString(@"YBLOrderDeliverItemCell") forCellReuseIdentifier:@"YBLOrderDeliverItemCell"];
    }
    return _deliverTableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.deliverDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    YBLDeliveritemModel *model = self.viewModel.deliverDataArray[row];
    return [YBLOrderDeliverItemCell getItemCellHeightWithModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *ordernoLabel = [[UILabel alloc] initWithFrame:CGRectMake(space, 0, headerView.width-2*space, headerView.height/2)];
    ordernoLabel.text = [NSString stringWithFormat:@"订单号 : %@",self.viewModel.orderNo];
    ordernoLabel.textColor = BlackTextColor;
    ordernoLabel.font = YBLFont(15);
    [headerView addSubview:ordernoLabel];
    
    NSString *name = @"暂无联系人";
    for (YBLDeliveritemModel *model in self.viewModel.deliverDataArray) {
        if (model.name.length>0) {
            name = model.name;
        }
    }
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ordernoLabel.left, ordernoLabel.bottom, ordernoLabel.width, ordernoLabel.height)];
    nameLabel.text = [NSString stringWithFormat:@"联系人 : %@",name];
    nameLabel.textColor = BlackTextColor;
    nameLabel.font = YBLFont(15);
    [headerView addSubview:nameLabel];

    [headerView addSubview:[YBLMethodTools addLineView:CGRectMake(0, headerView.height-.5, headerView.width, .5)]];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLOrderDeliverItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOrderDeliverItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLOrderDeliverItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = indexPath.row;
    YBLDeliveritemModel *model = self.viewModel.deliverDataArray[row];
    [cell updateItemCellModel:model];
    NSInteger count = self.viewModel.deliverDataArray.count;
    if (row == 0 && count >1) {
        cell.timeLine.timeLineState = TimeLineStateEndPoint;
        [cell.timeLine animate];
    } else if (count == 1 || row == count-1) {
        cell.timeLine.timeLineState = TimeLineStateStartPoint;
    } else if (count > 1){
        cell.timeLine.timeLineState = TimeLineStatePointLine;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    YBLDeliveritemModel *model = self.viewModel.deliverDataArray[row];
    if ([model.text isMatch:RX(@"\\d{11}")]) {
        NSMutableArray *titleArray = [@[@"拨打联系人电话",@"复制电话号码"] mutableCopy];
//        BOOL isHavDeliver = NO;
        if (model.shipping_evidence_urls.count>0) {
            [titleArray insertObject:@"查看物流凭证" atIndex:0];
//            isHavDeliver = YES;
        }
        [YBLActionSheetView showActionSheetWithTitles:titleArray
                                          handleClick:^(NSInteger index) {
                                              
                                              NSString *titleIndex = titleArray[index];
                                              if ([titleIndex isEqualToString:@"查看物流凭证"]) {
                                                  
                                                  YBLOrderExpressImageBrowerVC *OrderExpressImageBrowerVC = [YBLOrderExpressImageBrowerVC new];
                                                  OrderExpressImageBrowerVC.urlImageArray = [model.shipping_evidence_urls mutableCopy];
                                                  [self.Vc.navigationController pushViewController:OrderExpressImageBrowerVC animated:YES];
                                                  
                                              } else if ([titleIndex isEqualToString:@"复制电话号码"]) {
                                                  
                                                  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                  pasteboard.string = model.mobile;
                                                  [SVProgressHUD showSuccessWithStatus:@"复制成功~"];
                                              } else if ([titleIndex isEqualToString:@"拨打联系人电话"]) {
                                              
                                                  [YBLMethodTools callWithNumber:model.mobile];
                                              }
                                          }];
    }
}

@end

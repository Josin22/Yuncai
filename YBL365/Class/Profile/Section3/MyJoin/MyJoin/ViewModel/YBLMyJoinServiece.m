//
//  YBLMyJoinServiece.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyJoinServiece.h"
#import "YBLMyJoinViewModel.h"
#import "YBLMyJoinViewController.h"
#import "YBLMyJoinTableViewCell.h"
#import "YBLMyJoinHeaderView.h"
#import "YBLMyRemindViewController.h"
#import "YBLMyBrowsingHistoryViewController.h"
#import "YBLMyDemandOrderViewController.h"
#import "YBLOrderMMMyDepositVC.h"
#import "YBLMyMesssageViewController.h"
@interface YBLMyJoinServiece()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YBLMyJoinViewModel *viewModel;
@property (nonatomic,weak)YBLMyJoinViewController *vc;
@property (nonatomic,strong)UITableView *myJoinTableView;
@property (nonatomic,strong)NSArray *dataTitleSorceArr;
@property (nonatomic,strong)NSArray *dataPictureSoreceArr;
@end
@implementation YBLMyJoinServiece
- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _vc = (YBLMyJoinViewController *)VC;
        _viewModel = (YBLMyJoinViewModel *)viewModel;
        
        _dataTitleSorceArr = @[@"我的浏览",@"我的参与",@"我的订单",@"我的提醒",@"我的保证金"];
        _dataPictureSoreceArr = @[@"myjoinLl",@"myjoinCy",@"myjoinDd",@"myjoinTx",@"myjoinBzj"];
        UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mybutton setFrame:CGRectMake(0, 0, 25, 25)];
        [mybutton setBackgroundImage:[UIImage imageNamed:@"bar_more"] forState:UIControlStateNormal];
        UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:mybutton];
        _vc.navigationItem.rightBarButtonItem = rightCunstomButtonView;
        [mybutton addTarget:self action:@selector(myJoinMoreClicke:) forControlEvents:UIControlEventTouchUpInside];
        [_vc.view addSubview:self.myJoinTableView];
    }
    return self;
}
- (void)myJoinMoreClicke:(UIButton*)button{
    YBLMyMesssageViewController *myMessage = [[YBLMyMesssageViewController alloc]init];
    [self.vc.navigationController pushViewController:myMessage animated:YES];
    NSLog(@"通知消息");

}
- (UITableView*)myJoinTableView{
    if (_myJoinTableView == nil) {
        _myJoinTableView = [[UITableView alloc]initWithFrame:_vc.view.bounds style:UITableViewStylePlain];
        _myJoinTableView.backgroundColor = [UIColor whiteColor];
         _myJoinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myJoinTableView.dataSource = self;
        _myJoinTableView.delegate = self;
        YBLMyJoinHeaderView *headerView = [[YBLMyJoinHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.vc.view.width,212) and:@"ccbbyyan" and:@"renwu.png"];
        _myJoinTableView.tableHeaderView = headerView;
        
        _myJoinTableView.rowHeight = [YBLMyJoinTableViewCell getMyJoinCellHeight];
        [_myJoinTableView registerClass:[YBLMyJoinTableViewCell class] forCellReuseIdentifier:@"myJoinCell"];
    }
    return _myJoinTableView;

}
#pragma mark--UITableViewDataSource&&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataTitleSorceArr.count;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLMyJoinTableViewCell *cell = [[YBLMyJoinTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myJoinCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataForCell:[self.dataTitleSorceArr objectAtIndex:indexPath.row] and:[self.dataPictureSoreceArr objectAtIndex:indexPath.row]];
    return cell ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0)
    {
//        浏览记录
        YBLMyBrowsingHistoryViewController *myBrowsingHistory = [[YBLMyBrowsingHistoryViewController alloc]init];
        [self.vc.navigationController pushViewController:myBrowsingHistory animated:YES];
    }
    else if (indexPath.row == 1)
    {
    }
    else if(indexPath.row == 2)
    {
        //我的订单需求
        YBLMyDemandOrderViewController *myDemandOrder = [[YBLMyDemandOrderViewController alloc]init];
        [self.vc.navigationController pushViewController:myDemandOrder animated:YES];
    
    }
    else if (indexPath.row == 3)
    {
    //我的提醒
        YBLMyRemindViewController *myRemind = [[YBLMyRemindViewController alloc]init];
        [self.vc.navigationController pushViewController:myRemind animated:YES];
    
    }
    else if (indexPath.row == 4)
    {
        //我的保证金
        YBLOrderMMMyDepositVC *OrderMMMyDepositVC = [[YBLOrderMMMyDepositVC alloc]init];
        [self.vc.navigationController pushViewController:OrderMMMyDepositVC animated:YES];
    
    }

}
@end

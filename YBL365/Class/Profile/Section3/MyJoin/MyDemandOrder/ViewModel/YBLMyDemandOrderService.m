//
//  YBLMyDemandOrderService.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyDemandOrderService.h"
#import "YBLMyDemandOrderViewModel.h"
#import "YBLMyDemandOrderViewController.h"
#import "YBLMyDemandOrderTableViewCell.h"
@interface YBLMyDemandOrderService()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)YBLMyDemandOrderViewController*vc;
@property (nonatomic,strong)YBLMyDemandOrderViewModel *viewModel;
@property (nonatomic,strong)UITableView *myDemandOrderTableView;
@property (nonatomic,strong)NSMutableArray *dateSourceArr;
@end
@implementation YBLMyDemandOrderService
- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        self.vc = (YBLMyDemandOrderViewController*)VC;
        self.viewModel = (YBLMyDemandOrderViewModel*)viewModel;
        [self initData];
        [self.vc.view addSubview:self.myDemandOrderTableView];
    }
    return self;
}
- (NSMutableArray*)dateSourceArr{
    if (_dateSourceArr == nil) {
        _dateSourceArr = [NSMutableArray new];
    }
    return _dateSourceArr;
}
#pragma mark--初始化数据
- (void)initData{
    NSArray *arr = @[@"今天",@"昨天",@"1月8日",@"1月7日"];
    [self.dateSourceArr addObjectsFromArray:arr];

}
#pragma mark--懒加载tableview
- (UITableView*)myDemandOrderTableView{
    if (_myDemandOrderTableView == nil) {
        _myDemandOrderTableView = [[UITableView alloc]initWithFrame:self.vc.view.bounds style:UITableViewStyleGrouped];
        _myDemandOrderTableView.dataSource = self;
        _myDemandOrderTableView.delegate = self;
        _myDemandOrderTableView.rowHeight = [YBLMyDemandOrderTableViewCell getMyDemandOrderCellHeight];
        _myDemandOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myDemandOrderTableView registerClass:[YBLMyDemandOrderTableViewCell class] forCellReuseIdentifier:@"YBLMyDemandOrderTableViewCell"];
    }
    return _myDemandOrderTableView;
}
#pragma mark--UITableViewDataSource&&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dateSourceArr.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 5;
    }
    else
    {
        return 6;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,YBLWindowWidth,30)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(space,30/2-12/2,100,12)];
    label.text = [self.dateSourceArr objectAtIndex:section];
    label.textColor = YBLTextColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = YBLFont(12);
    [headerView addSubview:label];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(space,headerView.height-0.5 ,YBLWindowWidth - space,0.5)];
    line.backgroundColor = YBLLineColor;
    [headerView addSubview:line];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLMyDemandOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLMyDemandOrderTableViewCell" forIndexPath:indexPath];
    return cell;
}
@end

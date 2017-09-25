//
//  YBLMyRemindServer.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyRemindServer.h"
#import "YBLMyRemindViewModel.h"
#import "YBLMyRemindViewController.h"
#import "YBLMyRemindTableViewCell.h"
@interface YBLMyRemindServer()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YBLMyRemindViewModel *viewModel;
@property (nonatomic,weak)YBLMyRemindViewController *vc;
@property (nonatomic,strong)UITableView *myRemindtableView;
@end
@implementation YBLMyRemindServer
- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        _vc = (YBLMyRemindViewController*)VC;
        _viewModel = (YBLMyRemindViewModel*)viewModel;
        [self.vc.view addSubview:self.myRemindtableView];
    }
    return self;
}
- (UITableView*)myRemindtableView{
    if (_myRemindtableView == nil) {
        _myRemindtableView = [[UITableView alloc]initWithFrame:self.vc.view.bounds style:UITableViewStylePlain];
        _myRemindtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myRemindtableView.dataSource = self;
        _myRemindtableView.delegate = self;
        _myRemindtableView.rowHeight = [YBLMyRemindTableViewCell getMyRemindCellHeight];
        [_myRemindtableView registerClass:[YBLMyRemindTableViewCell class] forCellReuseIdentifier:@"myRemindCell"];
    }
    return _myRemindtableView;
}
#pragma mark--UITableViewDataSource&&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
};
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLMyRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myRemindCell" forIndexPath:indexPath];
    return cell;
}

@end

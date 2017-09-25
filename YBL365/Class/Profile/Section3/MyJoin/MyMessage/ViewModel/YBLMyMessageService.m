//
//  YBLMyMessageService.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyMessageService.h"
#import "YBLMyMessageViewModel.h"
#import "YBLMyMesssageViewController.h"
#import "YBLMyMessageTableViewCell.h"
@interface YBLMyMessageService()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)YBLMyMessageViewModel *viewModel;
@property (nonatomic,weak  )YBLMyMesssageViewController *vc;
@property (nonatomic,strong)UITableView *myMessageTableView;
@end
@implementation YBLMyMessageService
- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        self.viewModel = (YBLMyMessageViewModel*)viewModel;
        self.vc = (YBLMyMesssageViewController*)VC;
        [self.vc.view addSubview:self.myMessageTableView];
    }
    return self;
}
- (UITableView*)myMessageTableView
{
    if (_myMessageTableView == nil)
    {
        _myMessageTableView = [[UITableView alloc]initWithFrame:self.vc.view.bounds style:UITableViewStylePlain];
        _myMessageTableView.dataSource = self;
        _myMessageTableView.delegate = self;
        _myMessageTableView.rowHeight = [YBLMyMessageTableViewCell getMyMessageTableViewCellRowHeight];
        _myMessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myMessageTableView registerClass:[YBLMyMessageTableViewCell class] forCellReuseIdentifier:@"YBLMyMessageTableViewCell"];
    }
    return _myMessageTableView;
}
#pragma mark--UITableViewDataSource&&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLMyMessageTableViewCell" forIndexPath:indexPath];
    return cell;
}

@end

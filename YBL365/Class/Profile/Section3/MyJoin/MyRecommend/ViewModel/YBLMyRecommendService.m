//
//  YBLMyRecommendService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyRecommendService.h"
#import "YBLMyRecommendViewController.h"
#import "YBLMyRecommendCell.h"

@interface YBLMyRecommendService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YBLMyRecommendViewModel *viewModel;

@property (nonatomic, weak  ) YBLMyRecommendViewController *VC;

@property (nonatomic, strong) UITableView *joinTableView;

@end

@implementation YBLMyRecommendService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLMyRecommendViewController *)VC;
        _viewModel = (YBLMyRecommendViewModel *)viewModel;
        
        [_VC.view addSubview:self.joinTableView];
    }
    return self;
}

- (UITableView *)joinTableView{
    
    if (!_joinTableView) {
        _joinTableView = [[UITableView alloc] initWithFrame:[_VC.view bounds] style:UITableViewStylePlain];
        _joinTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _joinTableView.dataSource = self;
        _joinTableView.delegate = self;
        _joinTableView.rowHeight = [YBLMyRecommendCell getMyRecommendCellHeight];
        [_joinTableView registerClass:NSClassFromString(@"YBLMyRecommendCell") forCellReuseIdentifier:@"YBLMyRecommendCell"];
    }
    return _joinTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLMyRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLMyRecommendCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLMyRecommendCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

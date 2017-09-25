//
//  YBLOrderMMRankingListService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMRankingListService.h"
#import "YBLRankingButton.h"
#import "YBLOrderMMRankingListVC.h"
#import "YBLRankingListCell.h"

@interface YBLOrderMMRankingListService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) YBLOrderMMRankingListVC *VC;

@property (nonatomic, strong) YBLOrderMMRankingListViewModel *viewModel;

@property (nonatomic, strong) YBLRankingButton *button;

@property (nonatomic, strong) UITableView *rankingTableView;

@end

@implementation YBLOrderMMRankingListService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC = (YBLOrderMMRankingListVC *)VC;
        _viewModel = (YBLOrderMMRankingListViewModel *)viewModel;
        
        
        YBLRankingButton *button = [[YBLRankingButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        button.bigText = @"排行榜";
        button.smallText = @"郑州";
        _VC.navigationItem.titleView = button;
        self.button = button;
        
        [_VC.view addSubview:self.rankingTableView];
    }
    return self;
}

- (UITableView *)rankingTableView{
    
    if (!_rankingTableView) {
        _rankingTableView = [[UITableView alloc] initWithFrame:[_VC.view bounds] style:UITableViewStylePlain];
        _rankingTableView.dataSource = self;
        _rankingTableView.delegate = self;
        _rankingTableView.backgroundColor = YBLViewBGColor;
        _rankingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rankingTableView.showsVerticalScrollIndicator = NO;
        _rankingTableView.rowHeight = 120;
        [_rankingTableView registerClass:NSClassFromString(@"YBLRankingListCell") forCellReuseIdentifier:@"YBLRankingListCell"];
    }
    return _rankingTableView;
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
    YBLRankingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLRankingListCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLRankingListCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

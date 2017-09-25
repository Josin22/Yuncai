//
//  YBLCreditsPayRecordsService.m
//  YC168
//
//  Created by 乔同新 on 2017/5/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCreditsPayRecordsService.h"
#import "YBLCreditsPayRecordsViewController.h"
#import "YBLCreditsPayRecordsViewModel.h"
#import "YBLCreditsPayRecordsCell.h"

@interface YBLCreditsPayRecordsService ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak) YBLCreditsPayRecordsViewModel *viewModel;

@property (nonatomic, weak) YBLCreditsPayRecordsViewController *Vc;

@property (nonatomic, strong) UITableView *recordsTableView;

@end

@implementation YBLCreditsPayRecordsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLCreditsPayRecordsViewModel *)viewModel;
        _Vc = (YBLCreditsPayRecordsViewController *)VC;
        
        WEAK
        [YBLMethodTools headerRefreshWithTableView:self.recordsTableView completion:^{
            STRONG
            [self request];
        }];
        
        [self request];
    }
    return self;
}

- (void)request{
    WEAK
    [[self.viewModel siganlForCreditRecords] subscribeError:^(NSError * _Nullable error) {
        [self.recordsTableView.mj_header endRefreshing];
    } completed:^{
        STRONG
        [self.recordsTableView.mj_header endRefreshing];
        [self.recordsTableView jsReloadData];
    }];
}

- (UITableView *)recordsTableView{
    
    if (!_recordsTableView) {
        _recordsTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStylePlain];
        [self.Vc.view addSubview:_recordsTableView];
        _recordsTableView.dataSource = self;
        _recordsTableView.delegate  = self;
        _recordsTableView.emptyDataSetSource = self;
        _recordsTableView.emptyDataSetDelegate  = self;
        _recordsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recordsTableView.backgroundColor = [UIColor whiteColor];
        _recordsTableView.rowHeight = [YBLCreditsPayRecordsCell getItemCellHeightWithModel:nil];
        [_recordsTableView registerClass:NSClassFromString(@"YBLCreditsPayRecordsCell") forCellReuseIdentifier:@"YBLCreditsPayRecordsCell"];
    }
    return _recordsTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.recordsDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLCreditsPayRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLCreditsPayRecordsCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLCreditsPayRecordsCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell updateItemCellModel:self.viewModel.recordsDataArray[indexPath.row]];
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_charge_data";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无交易记录";
    
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

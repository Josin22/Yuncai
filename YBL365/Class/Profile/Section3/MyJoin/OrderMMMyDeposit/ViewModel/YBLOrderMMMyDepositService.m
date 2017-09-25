//
//  YBLOrderMMMyDepositService.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMMMyDepositService.h"
#import "YBLOrderMMMyDepositVC.h"
#import "YBLOrderMMMyDepositCell.h"

@interface YBLOrderMMMyDepositService()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *te;
}
@property (nonatomic, weak) YBLOrderMMMyDepositVC *VC;

@property (nonatomic, strong) YBLOrderMMMyDepositViewModel *viewModel;

@property (nonatomic, strong) UITableView *depositTableView;

@end

@implementation YBLOrderMMMyDepositService



- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _VC  = (YBLOrderMMMyDepositVC *)VC;
        _viewModel = (YBLOrderMMMyDepositViewModel *)viewModel;
        
        te = @[@0,@1,@2,@2,@1,@0,@2];
        
        [_VC.view addSubview:self.depositTableView];
    }
    return self;
}

- (UITableView *)depositTableView{
    
    if (!_depositTableView) {
        _depositTableView = [[UITableView alloc] initWithFrame:[_VC.view bounds] style:UITableViewStylePlain];
        _depositTableView.dataSource = self;
        _depositTableView.delegate  = self;
        _depositTableView.backgroundColor = YBLViewBGColor;
        _depositTableView.showsVerticalScrollIndicator = NO;
        _depositTableView.rowHeight = [YBLOrderMMMyDepositCell getDepositCellHeight];
        _depositTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_depositTableView registerClass:NSClassFromString(@"YBLOrderMMMyDepositCell") forCellReuseIdentifier:@"YBLOrderMMMyDepositCell"];
    }
    return _depositTableView;
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
    YBLOrderMMMyDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLOrderMMMyDepositCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLOrderMMMyDepositCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = [te[indexPath.row] integerValue];;
    cell.type = type;
}

@end

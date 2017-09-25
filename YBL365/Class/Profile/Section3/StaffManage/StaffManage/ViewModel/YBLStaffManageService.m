//
//  YBLStaffManageService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStaffManageService.h"
#import "YBLStaffManageVC.h"
#import "YBLStaffManageCell.h"
#import "YBLAddStaffViewController.h"

@interface YBLStaffManageService ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, weak) YBLStaffManageVC *Vc;

@property (nonatomic, strong) YBLStaffManageViewModel *viewModel;

@property (nonatomic, strong) UITableView *staffManageTableView;

@end

@implementation YBLStaffManageService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLStaffManageVC *)VC;
        _viewModel = (YBLStaffManageViewModel *)viewModel;
        
        //
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_icon"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(addClickMethod)];
        
        addItem.tintColor = YBLThemeColor;
        self.Vc.navigationItem.rightBarButtonItem = addItem;
        
        WEAK
        [YBLMethodTools headerRefreshWithTableView:self.staffManageTableView completion:^{
            STRONG
            [self jsReloadData];
        }];
    }
    return self;
}

- (void)jsReloadData{
    WEAK
    [self.viewModel.straffManageSignal subscribeError:^(NSError *error) {
        STRONG
        [self.staffManageTableView.mj_header endRefreshing];
        
    } completed:^{
        STRONG
        [self.staffManageTableView.mj_header endRefreshing];
        [self.staffManageTableView jsReloadData];
    }];
}


- (UITableView *)staffManageTableView{
    
    if (!_staffManageTableView) {
        _staffManageTableView = [[UITableView alloc] initWithFrame:[_Vc.view bounds] style:UITableViewStylePlain];
        [_Vc.view addSubview:_staffManageTableView];
        _staffManageTableView.rowHeight = [YBLStaffManageCell getItemCellHeightWithModel:nil];
        [_staffManageTableView registerClass:NSClassFromString(@"YBLStaffManageCell") forCellReuseIdentifier:@"YBLStaffManageCell"];
        _staffManageTableView.backgroundColor = [UIColor whiteColor];
        _staffManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _staffManageTableView.dataSource = self;
        _staffManageTableView.delegate = self;
        _staffManageTableView.emptyDataSetDelegate = self;
        _staffManageTableView.emptyDataSetSource = self;
        _staffManageTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
    }
    return _staffManageTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.staffDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLStaffManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStaffManageCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    YBLStaffManageModel *staffModel = self.viewModel.staffDataArray[indexPath.row];
    [cell updateItemCellModel:staffModel];
    WEAK
    [[[cell.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
       STRONG
        [self pushAddVCWithModel:staffModel];
    }];
    
    return cell;
}

- (void)pushAddVCWithModel:(YBLStaffManageModel *)model{
    YBLAddStaffViewController *addVC = [YBLAddStaffViewController new];
    addVC.staffManageModel = model;
    [self.Vc.navigationController pushViewController:addVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLStaffManageModel *staffModel = self.viewModel.staffDataArray[indexPath.row];
    [self pushAddVCWithModel:staffModel];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    YBLStaffManageModel *staffModel = self.viewModel.staffDataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        WEAK
        [YBLOrderActionView showTitle:@"是否删除当前员工?"
                               cancle:@"我再想想"
                                 sure:@"确定"
                      WithSubmitBlock:^{
                          STRONG
                          [[self.viewModel signalForDeleteStaffWithid:staffModel.id] subscribeNext:^(id x) {
                              STRONG
                              [self.viewModel.staffDataArray removeObjectAtIndex:row];
                              [self.staffManageTableView beginUpdates];
                              [self.staffManageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                              [self.staffManageTableView endUpdates];
                          } error:^(NSError *error) {
                              
                          }];
                      }
                          cancelBlock:^{
                              STRONG
                              NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
                              [self.staffManageTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                          }];
    }
}

- (void)addClickMethod{
    
    YBLAddStaffViewController *addVC = [YBLAddStaffViewController new];
    [self.Vc.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_yuangong";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有添加员工呢~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    [self addClickMethod];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}


@end

//
//  YBLAccountManageViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAccountManageViewController.h"
#import "YBLAccountManageItemModel.h"
#import "YBLAccountUserHeaderCell.h"
#import "YBLAccountItemCell.h"
#import "YBLOrderAddressViewController.h"
#import "YBLStoreViewController.h"
#import "YBLUserInfoViewController.h"

@interface YBLAccountManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *accountTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YBLAccountManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"账户管理";
    
    [self.view addSubview:self.accountTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.dataArray = nil;
    [self.accountTableView jsReloadData];
}

- (UITableView *)accountTableView{
    
    if (!_accountTableView) {
        _accountTableView = [[UITableView alloc] initWithFrame:[self.view bounds] style:UITableViewStyleGrouped];
        _accountTableView.dataSource = self;
        _accountTableView.delegate = self;
        _accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _accountTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        _accountTableView.showsVerticalScrollIndicator = NO;
        [_accountTableView registerClass:NSClassFromString(@"YBLAccountUserHeaderCell") forCellReuseIdentifier:@"YBLAccountUserHeaderCell"];
        [_accountTableView registerClass:NSClassFromString(@"YBLAccountItemCell") forCellReuseIdentifier:@"YBLAccountItemCell"];
    }
    return _accountTableView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *section0 = [NSMutableArray array];
        YBLAccountManageItemModel *model = [YBLAccountManageItemModel new];
        model.title = [YBLUserManageCenter shareInstance].userInfoModel.nickname;
        model.value = [YBLUserManageCenter shareInstance].userInfoModel.mobile;
        model.cellItemType = CellItemTypeClickWrite;
        NSString *useIconUrl = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
        if ([useIconUrl rangeOfString:@"missing.png"].location == NSNotFound) {
            model.icon_url = [YBLUserManageCenter shareInstance].userInfoModel.head_img;
        } else {
            model.icon_url = @"login_head_icon_70x70_";
        }
        [section0 addObject:model];
        [_dataArray addObject:section0];
        
        NSMutableArray *section1 = [NSMutableArray array];
        [section1 addObject:[self getTitle:@"地址管理" value:@"" cellType:CellItemTypeJustClick]];
        if ([YBLUserManageCenter shareInstance].userType == UserTypeSeller&&[YBLUserManageCenter shareInstance].aasmState == AasmStateApproved) {
            [section1 addObject:[self getTitle:@"店铺管理" value:@"" cellType:CellItemTypeJustClick]];   
        }
        [_dataArray addObject:section1];
    }
    return _dataArray;
}

- (YBLAccountManageItemModel *)getTitle:(NSString *)title value:(NSString *)value cellType:(CellItemType)cellType{
    
    YBLAccountManageItemModel *model = [YBLAccountManageItemModel new];
    model.title = title;
    model.value = value;
    model.cellItemType = cellType;
    return model;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
     return [YBLAccountUserHeaderCell getHi];
    } else {
     return [YBLAccountItemCell getHi];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section==0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLAccountUserHeaderCell"
                                                                         forIndexPath:indexPath];

    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLAccountItemCell"
                                                                         forIndexPath:indexPath];
    }

    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    YBLAccountManageItemModel *model  = self.dataArray[section][row];
    
    if ([cell isKindOfClass:[YBLAccountUserHeaderCell class]]) {
        
        YBLAccountUserHeaderCell *user_cell = (YBLAccountUserHeaderCell *)cell;
        [user_cell updateModel:model];
        WEAK
        [[[user_cell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            YBLUserInfoViewController *userInfoVC = [YBLUserInfoViewController new];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }];
        
    } else if ([cell isKindOfClass:[YBLAccountItemCell class]]) {
        
        YBLAccountItemCell *item_cell = (YBLAccountItemCell *)cell;
        [item_cell updateModel:model];
        WEAK
        [[[item_cell.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
            STRONG
            switch (row) {
                case 0:
                {
                    YBLOrderAddressViewController *addressVC = [YBLOrderAddressViewController new];
                    [self.navigationController pushViewController:addressVC animated:YES];
                }
                    break;
                case 1:
                {
                    YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
                    viewModel.shopid = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
                    viewModel.storeType = StoreTypePersonal;
                    YBLStoreViewController *storeVC = [[YBLStoreViewController alloc] init];
                    storeVC.viewModel = viewModel;
                    [self.navigationController pushViewController:storeVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
}

@end

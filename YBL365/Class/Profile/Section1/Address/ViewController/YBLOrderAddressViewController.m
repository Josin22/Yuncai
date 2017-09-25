//
//  YBLOrderAddressViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/24.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLOrderAddressViewController.h"
#import "YBLOrderAddressCell.h"
#import "YBLEditAddressViewController.h"
#import "YBLAddressViewModel.h"
#import "YBLAddressTableView.h"

@interface YBLOrderAddressViewController ()

@property (nonatomic, strong) YBLAddressTableView *tableView;

@end

@implementation YBLOrderAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    WEAK
    [self.viewModel.allAddressSignal subscribeError:^(NSError *error) {
        
    } completed:^{
        STRONG
        self.tableView.dataArray = self.viewModel.allAddressArray;
    }];
    
}

- (void)goback1{
    
    if (_viewModel.addressGenre != AddressGenreZiti) {
        if (self.viewModel.allAddressArray.count==0) {
            BLOCK_EXEC(self.viewModel.addressViewBlock,nil);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveManySelectZitiAddress {
 
    NSMutableArray *selectArray = [self.viewModel getSelectZitiArray];
    BLOCK_EXEC(self.viewModel.addressViewManySelectAddresBlock,selectArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收货地址";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_viewModel.addressGenre == AddressGenreZiti) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                                  style:UIBarButtonItemStyleDone
                                                                                 target:self
                                                                                 action:@selector(saveManySelectZitiAddress)];
        self.navigationItem.title = @"自提地址";
    }
    
    [self createTableView];
    
    [self createBottomView];
}

- (YBLAddressViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLAddressViewModel new];
    }
    return _viewModel;
}

- (void)createBottomView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    button.frame = CGRectMake(space, self.view.height - space - buttonHeight-kNavigationbarHeight, self.view.width - 2*space, buttonHeight);
    [button setTitle:@"   新建地址" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"contact_new_address_btn_n"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"contact_new_address_btn_n"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = YBLFont(16);
    button.backgroundColor = YBL_RED;
    [self.view addSubview:button];
    WEAK
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        [self pushEditVCWithModel:nil];
    }];
}

- (void)createTableView {
    
    self.tableView = [[YBLAddressTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)
                                                          style:UITableViewStylePlain
                                                   addressGenre:self.viewModel.addressGenre];
    
    [self.view addSubview:self.tableView];
    WEAK
    //cell select
    self.tableView.addressTableViewRowDidSelectBlock = ^(YBLAddressModel *model,NSInteger row) {
        STRONG
        if (self.viewModel.addressGenre == AddressGenreZiti) {
            
            model.is_select = !model.is_select;
            [model setValue:@(model.is_select) forKey:@"is_select"];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:row] withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            BLOCK_EXEC(self.viewModel.addressViewBlock,model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    //cell delete
    self.tableView.addressTableViewCellDeleteClickBlock = ^(YBLAddressModel *model,NSInteger row) {
        STRONG
        [[self.viewModel signalForDeleteAddressWithID:model.id] subscribeNext:^(NSNumber *x) {
            STRONG
            if (x.boolValue) {
                [self.viewModel.allAddressArray removeObjectAtIndex:row];
                [self.tableView jsReloadData];
            }
        } error:^(NSError *error) {
            
        }];
    };
    //cell button
    self.tableView.addressTableViewCellButtonClickBlock = ^(YBLAddressModel *model) {
        STRONG
        [self pushEditVCWithModel:model];
    };
    // cell empty
    self.tableView.addressTableViewCellEmptyButtonClickBlock = ^{
        STRONG
        [self pushEditVCWithModel:nil];
    };
    self.tableView.addressTableViewRowDefaultBlock = ^(YBLAddressModel *model, NSInteger section) {
        STRONG
        if (!self.viewModel.addressInfoModel) {
            self.viewModel.addressInfoModel = [YBLAddressModel new];
        }
        model._default = @(YES);
        self.viewModel.addressInfoModel = model;
        
        [[self.viewModel signalForChangeAddress] subscribeNext:^(id  _Nullable x) {
            
            for (YBLAddressModel *itemAddress in self.viewModel.allAddressArray) {
                itemAddress._default = @(NO);
            }
            model._default = @(YES);
            [self.tableView jsReloadData];
            
        } error:^(NSError * _Nullable error) {
            
        }];
    };

}


- (void)pushEditVCWithModel:(YBLAddressModel*)model{
    
    AddressType type = AddressTypeOrderEdit;
    if (!model) {
        type = AddressTypeOrderAdd;
    }
    YBLAddressViewModel *viewModel = [YBLAddressViewModel new];
    viewModel.addressType = type;
    viewModel.addressInfoModel = model;
    viewModel.addressGenre = self.viewModel.addressGenre;
    YBLEditAddressViewController *editAddressVC = [[YBLEditAddressViewController alloc] init];
    editAddressVC.viewModel = viewModel;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}


@end

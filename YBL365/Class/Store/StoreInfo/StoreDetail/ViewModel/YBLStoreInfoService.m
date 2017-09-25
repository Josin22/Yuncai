
//
//  YBLStoreService.m
//  YC168
//
//  Created by 乔同新 on 2017/5/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreInfoService.h"
#import "YBLStoreInfoViewModel.h"
#import "YBLStoreInfoViewController.h"
#import "YBLEditPurchaseCell.h"
#import "YBLStoreInfoHeaderView.h"
#import "shop.h"
#import "YBLStoreLookBusinessLicenseImageVC.h"
#import "YBLShopInfoModel.h"
#import "YBLStoreBrandView.h"
#import "YBLShopQRCImagePopView.h"
#import "YBLOpenCreditsViewController.h"

@interface YBLStoreInfoService ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak  ) YBLStoreInfoViewModel      *viewModel;

@property (nonatomic, weak  ) YBLStoreInfoViewController *Vc;

@property (nonatomic, strong) UITableView                *storeInfoTableView;

@property (nonatomic, strong) YBLStoreInfoHeaderView     *headerView;

@property (nonatomic, strong) YBLStoreBrandView          *storeBrandView;

@end

@implementation YBLStoreInfoService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLStoreInfoViewModel *)viewModel;
        _Vc = (YBLStoreInfoViewController *)VC;
        
        [self.Vc.view addSubview:self.storeInfoTableView];
        
        UIButton *callButton = [YBLMethodTools getFangButtonWithFrame:CGRectMake(0, self.storeInfoTableView.bottom, self.storeInfoTableView.width, buttonHeight)];
        [callButton setTitle:@"拨打电话" forState:UIControlStateNormal];
        [self.Vc.view addSubview:callButton];
        callButton.hidden = YES;
        
        WEAK
        [[callButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            NSMutableArray *titleArray = [NSMutableArray array];
            if (self.viewModel.shopInfoModel.mobile) {
                [titleArray addObject:self.viewModel.shopInfoModel.mobile];
            }
            if (self.viewModel.shopInfoModel.tel) {
                [titleArray addObject:self.viewModel.shopInfoModel.tel];
            }
            if (titleArray.count==0) {
                [SVProgressHUD showErrorWithStatus:@"暂无联系电话~"];
                return ;
            }
            [YBLActionSheetView showActionSheetWithTitles:[titleArray copy]
                                              handleClick:^(NSInteger index) {
                                                  NSString *phone = titleArray[index];
                                                  [YBLMethodTools callWithNumber:phone];
                                              }];
        }];
        
        
        [[self.viewModel siganlForShopInfo] subscribeError:^(NSError * _Nullable error) {
        } completed:^{
            STRONG
            [self.headerView.storeNameButton setTitle:self.viewModel.shopInfoModel.shop_name forState:UIControlStateNormal];
            self.storeBrandView.brandDataArray = [self.viewModel.shopInfoModel.licensing_brand mutableCopy];
            [self.storeInfoTableView jsReloadData];
            callButton.hidden = NO;
        }];
    }
    return self;
}

- (YBLStoreInfoHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YBLStoreInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView.storeImageView js_alpha_setImageWithURL:[NSURL URLWithString:self.viewModel.shopModel.logo_url] placeholderImage:smallImagePlaceholder];
        _headerView.signalLabel.text = [NSString stringWithFormat:@"综合 %.1f",self.viewModel.shopModel.comment_rate.doubleValue];
        [_headerView.storeNameButton setTitle:self.viewModel.shopModel.shopname forState:UIControlStateNormal];
        [_headerView.storeNameButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        _headerView.signalLabel.textColor = YBLTextLightColor;
    }
    return _headerView;
}

- (YBLStoreBrandView *)storeBrandView{
    
    if (!_storeBrandView) {
        _storeBrandView = [[YBLStoreBrandView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 100)];
    }
    return _storeBrandView;
}


- (UITableView *)storeInfoTableView{
    
    if (!_storeInfoTableView) {
        _storeInfoTableView = [[UITableView alloc] initWithFrame:[self.Vc.view bounds] style:UITableViewStyleGrouped];
        _storeInfoTableView.height -= kNavigationbarHeight+buttonHeight;
        _storeInfoTableView.dataSource = self;
        _storeInfoTableView.delegate = self;
        _storeInfoTableView.showsVerticalScrollIndicator = NO;
        _storeInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_storeInfoTableView registerClass:[YBLEditPurchaseCell class] forCellReuseIdentifier:@"YBLEditPurchaseCell"];
        _storeInfoTableView.tableHeaderView = self.headerView;
        _storeInfoTableView.tableFooterView = self.storeBrandView;
        
    }
    return _storeInfoTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cellDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return space;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    YBLEditItemGoodParaModel *model = self.viewModel.cellDataArray[section][row];
    return [YBLEditPurchaseCell getItemCellHeightWithModel:model];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.cellDataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLEditPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLEditPurchaseCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLEditPurchaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    YBLEditItemGoodParaModel *model = self.viewModel.cellDataArray[section][row];
    [cell updateItemCellModel:model];
    WEAK
    [[[cell.maskButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([model.paraString  isEqualToString:@"zjxx"]) {
            //证件照信息
            YBLStoreLookBusinessLicenseImageVC *licenseVC = [YBLStoreLookBusinessLicenseImageVC new];
//            licenseVC.licenseURL = self.viewModel.shopUserInfoModel.busp;
            licenseVC.shopInfoModel = self.viewModel.shopInfoModel;
            if ([[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:self.viewModel.shopModel.shopid]) {
                licenseVC.isSelfStore = YES;
            } else {
                licenseVC.isSelfStore = NO;
            }
            [self.Vc.navigationController pushViewController:licenseVC animated:YES];
        } else if ([model.paraString  isEqualToString:@"dpewm"]) {
            //店铺二维码
            [YBLShopQRCImagePopView showShopQRCImageWithContentURL:self.viewModel.shopInfoModel.share_url storeName:self.viewModel.shopInfoModel.shop_name];
            
        } else if ([model.paraString  isEqualToString:@"xyt"]) {
            if ([[YBLUserManageCenter shareInstance].userModel.userinfo_id isEqualToString:self.viewModel.shopModel.shopid]&&(([YBLUserManageCenter shareInstance].userOpenedCreditType == UserOpenedCreditTypeNone))) {
                YBLOpenCreditsViewController *creditsVC = [YBLOpenCreditsViewController new];
                [self.Vc.navigationController pushViewController:creditsVC animated:YES];
            }
        }
    }];
}

@end

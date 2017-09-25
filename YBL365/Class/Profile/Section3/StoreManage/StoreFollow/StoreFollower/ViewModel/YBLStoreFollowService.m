//
//  YBLStoreFollowService.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreFollowService.h"
#import "YBLStoreFollowViewController.h"
#import "YBLStoreFollowViewModel.h"
#import "YBLStoreSettingFollowRewardVC.h"
#import "YBLStoreFollowerTabelView.h"
#import "YBLRechargeWalletsViewController.h"
#import "YBLStoreViewController.h"
#import "KSPhotoBrowser.h"
#import "YBLGoodSharersModel.h"

@interface YBLStoreFollowService ()<YBLTableViewDelegate>

@property (nonatomic, weak  ) YBLStoreFollowViewController *selfVc;

@property (nonatomic, weak  ) YBLStoreFollowViewModel *viewModel;

@property (nonatomic, strong) YBLStoreFollowerTabelView *storeFollowerTabelView;

@end

@implementation YBLStoreFollowService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {

        _selfVc = (YBLStoreFollowViewController *)VC;
        _viewModel = (YBLStoreFollowViewModel *)viewModel;
        
        if (self.viewModel.followType != FollowTypeShares) {
            WEAK
            _selfVc.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"reward_icon" block:^{
                STRONG
                YBLStoreSettingFollowRewardVC *rewardVc = [YBLStoreSettingFollowRewardVC new];
                [self.selfVc.navigationController pushViewController:rewardVc animated:YES];
            }];
        }
        
        [self requestDataIsReload:YES];
    }
    return self;
}

- (void)requestDataIsReload:(BOOL)isReload{
 
    WEAK
    [[self.viewModel signalForFollowGoodsIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        STRONG
        [self.storeFollowerTabelView.mj_header endRefreshing];
        self.storeFollowerTabelView.dataArray = self.viewModel.singleDataArray;
//        [self.storeFollowerTabelView jsReloadData];
        if (isReload) {
            [self.storeFollowerTabelView jsReloadData];
        } else {
            [self.storeFollowerTabelView jsInsertRowIndexps:x withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } error:^(NSError * _Nullable error) {
        STRONG
        [self.storeFollowerTabelView.mj_header endRefreshing];
    }];
    
}

- (YBLStoreFollowerTabelView *)storeFollowerTabelView{
    if (!_storeFollowerTabelView) {
        _storeFollowerTabelView = [[YBLStoreFollowerTabelView alloc] initWithFrame:[self.selfVc.view bounds]
                                                                             style:UITableViewStylePlain
                                                                              type:self.viewModel.followType];
        [self.selfVc.view addSubview:_storeFollowerTabelView];
        _storeFollowerTabelView.ybl_delegate = self;
        WEAK
        _storeFollowerTabelView.prestrainBlock = ^{
            STRONG
            [self requestDataIsReload:NO];
        };
        [YBLMethodTools headerRefreshWithTableView:_storeFollowerTabelView completion:^{
            STRONG
            [self requestDataIsReload:YES];
        }];
    }
    return _storeFollowerTabelView;
}

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    YBLUserInfoModel *mode = (YBLUserInfoModel *)selectValue;
    WEAK
    [YBLOrderActionView showTitle:[NSString stringWithFormat:@"关注需要支付云币给粉丝,是否要继续关注?"]
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      STRONG
                      [[self.viewModel siganlForFollowPayMoneyWith:mode.id] subscribeNext:^(id  _Nullable x) {
                          STRONG
                          if ([x[@"result"] isEqualToString:@"SUCCESS"]) {
                              [SVProgressHUD showSuccessWithStatus:@"关注成功~"];
                              mode.follow_state = @(1);
                              [self.storeFollowerTabelView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                          } else {
//                              [SVProgressHUD showErrorWithStatus:@"关注失败~"];
                              [self goRecharge];
                          }
                      } error:^(NSError * _Nullable error) {
                          
                      }];
                  }
                      cancelBlock:^{
                          
                      }];
}

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    if ([selectValue isKindOfClass:[YBLUserInfoModel class]]) {
        YBLUserInfoModel *mode = (YBLUserInfoModel *)selectValue;
        if ([mode.user_type isEqualToString:@"seller"]&&[mode.aasm_state isEqualToString:@"approved"]) {
            NSString *shop_id = mode.id;
            YBLStoreViewModel *viewModel = [YBLStoreViewModel new];
            viewModel.shopid = shop_id;
            YBLStoreViewController * storeVC = [[YBLStoreViewController alloc]init];
            storeVC.viewModel = viewModel;
            [self.selfVc.navigationController pushViewController:storeVC animated:YES];
        }
    }
}

- (void)ybl_tableViewCellSlideToClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview{
    NSString *head_img = nil;
    if ([selectValue isKindOfClass:[YBLUserInfoModel class]]) {
        YBLUserInfoModel *model = (YBLUserInfoModel *)selectValue;
        head_img = model.head_img;
    } else if ([selectValue isKindOfClass:[YBLGoodSharersModel class]]){
        YBLGoodSharersModel *model = (YBLGoodSharersModel *)selectValue;
        head_img = model.head_img;
    }
    KSPhotoItem *items = [[KSPhotoItem alloc] initWithSourceView:(UIImageView *)tableview imageUrl:[NSURL URLWithString:head_img]];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[items] selectedIndex:0];
    //                                                  browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    browser.bounces = NO;
    [browser showFromViewController:self.selfVc];

}

/*

 */
- (void)goRecharge{
    WEAK
    [YBLOrderActionView showTitle:@"您的钱包云币不足,是否要去充值?"
                           cancle:@"我再想想"
                             sure:@"去充值"
                  WithSubmitBlock:^{
                      STRONG
                      YBLRechargeWalletsViewController *rechargeVC = [[YBLRechargeWalletsViewController alloc] init];
                      [self.selfVc.navigationController pushViewController:rechargeVC animated:YES];
                  }
                      cancelBlock:^{}];
}

@end

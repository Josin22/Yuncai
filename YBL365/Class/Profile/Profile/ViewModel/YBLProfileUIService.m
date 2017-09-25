//
//  YBLProfileUIService.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLProfileUIService.h"
#import "YBLProfileViewController.h"
#import "YBLHomeRecommendGoodCell.h"
#import "YBLShopCarRecommendGoodsCell.h"
#import "YBLProfileHeadView.h"
#import "YBLProfileItemCell.h"
#import "YBLProfilelistCell.h"
#import "YBLProfileNavigationView.h"
#import "YBLUpButton.h"
#import "YBLOrderMMMyDepositVC.h"
#import "YBLMyRecommendViewController.h"
#import "YBLMyJoinViewController.h"
#import "YBLMarketingPhotoViewController.h"
#import "YBLProfileViewModel.h"
#import "YBLLoginViewModel.h"

@interface YBLProfileUIService ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YBLProfileHeadView *headView;

@property (nonatomic, strong) YBLProfileNavigationView *navigationView;

@property (nonatomic, assign) BOOL isLogin;

@end

@implementation YBLProfileUIService

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.profileVC.view.bounds style:UITableViewStyleGrouped];
        _tableView.height = YBLWindowHeight - 49;
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = YBLColor(240, 240, 240, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[YBLProfilelistCell class] forCellReuseIdentifier:@"cellId1"];
        [_tableView registerClass:[YBLShopCarRecommendGoodsCell class] forCellReuseIdentifier:@"cellId2"];
        
    }
    return _tableView;
}

- (YBLProfileNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[YBLProfileNavigationView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 64)];
        _navigationView.backgroundColor = [UIColor clearColor];
        
        [[_navigationView.userButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
#warning test  logout!!!!!
            [[YBLLoginViewModel singalForLogout] subscribeError:^(NSError *error) {
                
            } completed:^{
                [self.tableView reloadData];
            }];
        }];
    }
    return _navigationView;
}

- (YBLProfileHeadView *)headView {
    if (!_headView) {
        _headView = [[YBLProfileHeadView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, YBLWindowWidth*0.4)];
        __weak typeof (self)weakSelf = self;
        [[_headView.bgButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (!weakSelf.isLogin) {
                if (weakSelf.loginBlock) {
                    weakSelf.loginBlock();
                }
            }
        }];
    }
    return _headView;
}



- (void)setProfileVC:(YBLProfileViewController *)profileVC {
    _profileVC = profileVC;
    [profileVC.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    //自定义导航头
    [profileVC.view addSubview:self.navigationView];
    [self createUpButton];
    
}

- (void)createUpButton {
    [YBLUpButton showInView:self.profileVC.view center:CGPointMake(self.profileVC.view.width - 30, self.profileVC.view.height-49 - 30) scrollView:self.tableView zeroTop:0];
}


- (void)updateWithIsLogin:(BOOL)isLogin {
    self.isLogin = isLogin;
    [self.headView updateWithIsLogin:isLogin];
    
    [self.tableView reloadData];
}



#pragma mark - 
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    return 3+n;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    if (n != 0 && section == 3) {
        return self.viewModel.recommendArray.count/2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    if (n != 0 && indexPath.section == 3) {
        return [YBLShopCarRecommendGoodsCell getCellHi];
    }
    if (indexPath.section == 2) {
        if (self.isLogin && [YBLUserModel shareInstance].userType == UserTypeBigB) {
           return [YBLProfilelistCell getHIWithCount:self.viewModel.section3_titles_B.count];
        } else {
            return [YBLProfilelistCell getHIWithCount:self.viewModel.section3_titles_b.count];
        }
    }
    return 80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    if (n != 0 && indexPath.section == 3) {
        YBLShopCarRecommendGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId2" forIndexPath:indexPath];
        [cell updateWithLeftGood:[self.viewModel.recommendArray objectAtIndex:indexPath.row*2] rightGood:[self.viewModel.recommendArray objectAtIndex:indexPath.row*2+1]];
        
        return cell;
    }
    if (indexPath.section == 0) {
        YBLProfileItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId3"];
        if (cell == nil) {
            cell = [[YBLProfileItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId3"];
            cell.isOrder = YES;
        }
        [cell updateShaowWithPayNumber:0 receiving:0 evaluate:0 aftermarket:0];
        
        return cell;
    }
    if (indexPath.section == 1) {
        YBLProfileItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId4"];
        if (cell == nil) {
            cell = [[YBLProfileItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId4"];
            cell.isOrder = NO;
        }

        return cell;
    }
    if (indexPath.section == 2) {
        YBLProfilelistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId1" forIndexPath:indexPath];
        
        if (self.isLogin && [YBLUserModel shareInstance].userType == UserTypeBigB) {
            [cell showBTitles:self.viewModel.section3_titles_B Bimages:self.viewModel.section3_title_images_B];
        } else {
            [cell showbTitles:self.viewModel.section3_titles_b bimages:self.viewModel.section3_title_images_b];
        }

        WEAK
        cell.profileButtonClickblock = ^(UserType usertype,NSInteger index){
            STRONG
          
            if (usertype == UserTypelittleb) {
                [self.viewModel pushVCClassName:self.viewModel.section3_littlebClassName[index] WithNavigationVC:self.profileVC.navigationController];
            } else {
                [self.viewModel pushVCClassName:self.viewModel.section3_bigBClassName[index] WithNavigationVC:self.profileVC.navigationController];
            }

        };
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    if (n == 0) {
        return 10;
    }else {
        if (section == 2 ||section == 3) {
            return 0.01;
        }
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    if (n != 0 && section == 3) {
        return 40;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger n = self.viewModel.recommendArray.count == 0?0:1;
    if (n != 0 && section == 3) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 40)];
        headView.backgroundColor = VIEW_BASE_COLOR;
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uniformRecommend_head_image_"]];
        [headView addSubview:image];
        image.frame = CGRectMake((YBLWindowWidth-376)/2, 0, 376, 40);
        return headView;
    }
    return nil;
}


#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpa = scrollView.contentOffset.y/NAVBAR_CHANGE_POINT;
    if (alpa > 0.95) {
        alpa = 0.95;
    }
    self.navigationView.bgViewAlpa = alpa;
}

@end

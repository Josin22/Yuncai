//
//  YBLStoreViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreViewController.h"
#import "YBLStoreService.h"
#import "YBLPopView.h"
#import "YBLShareView.h"
#import "YBLShopModel.h"
#import "YBLStoreOpenManageVC.h"
#import "YBLYunLongImageView.h"

@interface YBLStoreViewController ()

@property (nonatomic, strong) YBLStoreService *service;

@end

@implementation YBLStoreViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.service briberyLean];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.viewModel.storeType == StoreTypeOpen) {
        self.navigationItem.rightBarButtonItems = @[self.moreBarButtonItem,];
    } else {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setImage:[UIImage imageNamed:@"bar_more"]    forState:UIControlStateNormal];
        [btn1 setFrame:CGRectMake(0, 0, 30, 30)];
        [btn1 addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:btn1];
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setImage:[UIImage imageNamed:@"bar_store_setting"] forState:UIControlStateNormal];
        [btn2 setFrame:CGRectMake(0, 0, 30, 30)];
        [btn2 addTarget:self action:@selector(storeSettingButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:btn2];
        self.navigationItem.rightBarButtonItems = @[item1,item2];
    }
    
    self.service = [[YBLStoreService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)storeSettingButtonItemClick:(UIBarButtonItem *)btn{
    
    YBLStoreOpenManageVC *storeVc = [YBLStoreOpenManageVC new];
    [self.navigationController pushViewController:storeVc animated:YES];
}

- (void)moreClick:(UIBarButtonItem *)btn{
    
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, kNavigationbarHeight)
                               
                                                         titles:@[@"分享店铺",@"返回首页",@"店铺详情"]
                                                         images:@[@"xn_more_share",
                                                                  @"xn_more_home",
                                                                  @"search_store_icon"]];
    WEAK
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        STRONG
        switch (index) {
            case 0:
            {//分享
                if (!self.viewModel.shopinfo) {
                    return ;
                }
                NSString *title = self.viewModel.shopinfo.shopname;
                NSString *shareUrl = self.viewModel.shopinfo.share_url;
                YBLSystemSocialModel *model = [YBLSystemSocialModel new];
                model.imageType = SaveImageTypeNormalGoods;
                model.share_url = shareUrl;
                model.quantity = self.viewModel.nummberValueArray[0];
                model.shopName = title;
                model.head_img = self.viewModel.shopinfo.head_img;
                [YBLYunLongImageView showStoreYunLongImageViewWithModel:model];
                /*
                NSString *title = self.viewModel.shopModel.shopinfo.shopname;
                NSString *shareUrl = self.viewModel.shopModel.shopinfo.share_url;
                [YBLShareView shareViewWithPublishContentText:@"刚刚在云采商城看到一个不错的店铺,好东西要一起分享,快来看看吧~"
                                                       title:title
                                                   imagePath:self.viewModel.shopModel.shopinfo.logo_url
                                                         url:shareUrl
                                                      Result:^(ShareType type, BOOL isSuccess) {
                                                          
                                                      }
                                     ShareADGoodsClickHandle:^(){
//                                         YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] init];
//                                         [self.navigationController pushViewController:goodsDetailVC animated:YES];
                                     }];
                */
            }
                break;
            case 1:
            {//首页
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            case 2:{
                [self.service pushStoreInfo];
            }
                break;
            default:
                break;
        }
    };
    [morePopView show];
}

- (void)categoryClick:(UIBarButtonItem *)btn{
    
    YBLStoreOpenManageVC *openVC = [YBLStoreOpenManageVC new];
    [self.navigationController pushViewController:openVC animated:YES];
}

@end

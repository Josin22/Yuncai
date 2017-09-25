//
//  YBLStoreInfoViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/5/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreInfoViewController.h"
#import "YBLStoreInfoService.h"
#import "shop.h"
#import "YBLShareView.h"
#import "YBLShopInfoModel.h"
#import "YBLYunLongImageView.h"

@interface YBLStoreInfoViewController ()

@property (nonatomic, strong) YBLStoreInfoService *service;

@end

@implementation YBLStoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"店铺详情";
    
    self.service = [[YBLStoreInfoService alloc] initWithVC:self ViewModel:self.viewModel];
    
    self.navigationItem.rightBarButtonItem = self.shareBarButtonItem;
}

- (void)shareClick:(UIBarButtonItem *)btn{
    
    if (!self.viewModel.shopModel) {
        return ;
    }
    NSString *title = self.viewModel.shopInfoModel.shop_name;
    NSString *shareUrl = self.viewModel.shopInfoModel.share_url;
    YBLSystemSocialModel *model = [YBLSystemSocialModel new];
    model.imageType = SaveImageTypeNormalGoods;
    model.share_url = shareUrl;
    model.quantity = @(self.viewModel.allProductCount);
    model.shopName = title;
//    model.logo_url = self.viewModel.shopModel.logo_url;
    model.head_img = self.viewModel.shopModel.head_img;
    [YBLYunLongImageView showStoreYunLongImageViewWithModel:model];
    /*
    [YBLShareView shareViewWithPublishContentText:@"刚刚在云采商城看到一个不错的店铺,好东西要一起分享,快来看看吧~"
                                            title:title
                                        imagePath:self.viewModel.shopModel.logo_url
                                              url:shareUrl
                                           Result:^(ShareType type, BOOL isSuccess) {
                                               
                                           }
                          ShareADGoodsClickHandle:^(){
                              //                                         YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] init];
                              //                                         [self.navigationController pushViewController:goodsDetailVC animated:YES];
                          }];
    */
}

- (YBLStoreInfoViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [YBLStoreInfoViewModel new];
        shop *shopModel = [shop new];
        shopModel.shopid = [YBLUserManageCenter shareInstance].userModel.userinfo_id;
        shopModel.logo_url = [YBLUserManageCenter shareInstance].userInfoModel.logo_url;
        shopModel.shopname = [YBLUserManageCenter shareInstance].userInfoModel.shopname;
        _viewModel.shopModel = shopModel;
    }
    return _viewModel;
}

@end

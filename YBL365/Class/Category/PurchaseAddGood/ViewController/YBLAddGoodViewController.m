//
//  YBLAddGoodViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/24.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAddGoodViewController.h"
#import "YBLCategoryUIService.h"
#import "YBLShareView.h"

@interface YBLAddGoodViewController ()

@property (nonatomic, strong) YBLCategoryUIService *service;

@end

@implementation YBLAddGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    if (self.viewModel.goodCategoryType == GoodCategoryTypeForCommodityPoolCategory) {
//        
//        self.navigationItem.title = @"添加商品";
//        
//    } else if (self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithTabbar ||self.viewModel.goodCategoryType==GoodCategoryTypeForPurchaseWithOutTabbar) {
//    
//        self.navigationItem.title = @"选择采购商品";
//
//    }
//    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.rightBarButtonItem = self.explainButtonItem;
    
    self.service = [[YBLCategoryUIService alloc] initWithVC:self ViewModel:self.viewModel];
    /*
    WEAK
    self.service.rightTableView.itemClickBlock = ^(YBLCategoryTreeModel *model){
        STRONG
        YBLAddGoodListViewModel *viewModel = [YBLAddGoodListViewModel new];
        viewModel.category_id = model.id;
        viewModel.goodCategoryType = self.viewModel.goodCategoryType;
        YBLAddGoodListViewController *addGoodListVC = [YBLAddGoodListViewController new];
        addGoodListVC.viewModel = viewModel;
        [YBLMethodTools pushVC:addGoodListVC FromeUndefineVC:self];
    
    };
    */
}


- (void)shareClick:(UIBarButtonItem *)btn{
    
    
    [YBLShareView shareViewWithPublishContentText:@""
                                           title:@"我有一个采购需求,有货的商家赶快来接单吧"
                                       imagePath:smallImagePlaceholder
                                             url:@""
                                          Result:^(ShareType type, BOOL isSuccess) {
                                              
                                          }
                         ShareADGoodsClickHandle:^(){
                             
                         }];
}



- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
    if (self.viewModel.goodCategoryType != GoodCategoryTypeForCommodityPoolCategory) {
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_PurchaseReleaseAndOutPriceDelegate title:@"采购订单发布及报价协议"];
    } else {
        [YBLMethodTools pushWebVcFrom:self URL:H5_URL_SmallGoodStorgeDeclare_image title:@"商品图片库说明"];
    }
//
    
}

@end

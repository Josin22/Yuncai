//
//  YBLOrderMoreMoreHomeVC.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderMoreMoreHomeVC.h"
#import "YBLOrderMoreMoreService.h"
#import "XNShareView.h"
#import "YBLPopView.h"
#import "YBLGoodsDetailViewController.h"

@interface YBLOrderMoreMoreHomeVC ()

@property (nonatomic, strong) YBLOrderMoreMoreService *service;

@property (nonatomic, strong) YBLOrderMoreMoreViewModel *viewModel;

@end

@implementation YBLOrderMoreMoreHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"订单多多";
    
    self.navigationItem.rightBarButtonItems = @[self.moreBarButtonItem,self.shareBarButtonItem];
    

    self.viewModel = [[YBLOrderMoreMoreViewModel alloc] init];
    
    self.service = [[YBLOrderMoreMoreService alloc] initWithVC:self ViewModel:self.viewModel];
    
}


- (void)shareClick:(UIBarButtonItem *)btn{
    
    
    [XNShareView shareViewWithPublishContentText:@"飞天茅台 52度 特供 500ml 精品"
                                           title:@"我有一个采购需求,有货的商家赶快来接单吧"
                                       imagePath:smallImagePlaceholder
                                             url:@"http://lw.mayicms.net/app/index/jingdongp"
                                          Result:^(ShareType type, BOOL isSuccess) {
                                              
                                          }
                         ShareADGoodsClickHandle:^(){
                             YBLGoodsDetailViewController *goodsDetailVC = [[YBLGoodsDetailViewController alloc] init];
                             [self.navigationController pushViewController:goodsDetailVC animated:YES];
                         }];
    
}

- (void)moreClick:(UIBarButtonItem *)btn{
    
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, 64)
                                                         titles:@[@"搜索",@"首页"]
                                                         images:@[@"xn_more_search",@"xn_more_home"]];
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        switch (index) {
            case 0:
            {//搜索
                
            }
                break;
            case 1:
            {//首页
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
    };
    [morePopView show];
}

@end

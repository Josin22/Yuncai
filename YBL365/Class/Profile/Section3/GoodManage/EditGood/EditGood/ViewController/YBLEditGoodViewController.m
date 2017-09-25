//
//  YBLEditGoodViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodViewController.h"
#import "YBLEditGoodService.h"
#import "IQKeyboardManager.h"
#import "YBLPopView.h"
#import "YBLGoodAllInfosViewController.h"


@interface YBLEditGoodViewController ()

@property (nonatomic, strong) YBLEditGoodService *service;

@end

@implementation YBLEditGoodViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setIsPopGestureRecognizerEnable:NO];
    
    [self.service requestRackGood];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[YBLEditGoodService alloc] initWithVC:self ViewModel:self.viewModel];
    
    self.navigationItem.rightBarButtonItem = self.addButtonItem;

}

- (void)goback1{
    
    [YBLOrderActionView showTitle:@"确定要离开编辑吗?"
                           cancle:@"我再想想"
                             sure:@"确定"
                  WithSubmitBlock:^{
                      BLOCK_EXEC(self.viewModel.goodModelBlock,self.viewModel.productModel);
                      [self.navigationController popViewControllerAnimated:YES];
                  }
                      cancelBlock:^{
                      }];
}
- (void)addClick:(UIBarButtonItem *)btn{
    
    YBLPopView *morePopView = [[YBLPopView alloc] initWithPoint:CGPointMake(YBLWindowWidth-30, kNavigationbarHeight)
                                                         titles:self.viewModel.titleArray
                                                         images:nil];
    WEAK
    morePopView.selectRowAtIndexBlock = ^(NSInteger index){
        STRONG
        if (!self.viewModel.productModel) {
            return ;
        }
        if (index==self.viewModel.titleArray.count-1) {
            [YBLMethodTools pushWebVcFrom:self URL:H5_URL_GoodEditDeclare title:@"商品详情编辑说明"];
            return;
        }
        NSString *titleString = self.viewModel.titleArray[index];
        YBLGoodAllInfosViewModel *infosViewModel = [YBLGoodAllInfosViewModel new];
        infosViewModel.goodAllInfosType = index;
        infosViewModel.titleString = titleString;
        infosViewModel.goodInfoDataArray = self.viewModel.cellDataArray;
        infosViewModel.productModel = self.viewModel.productModel;
        YBLGoodAllInfosViewController *allInfoVC = [YBLGoodAllInfosViewController new];
        allInfoVC.viewModel = infosViewModel;
        [self.navigationController pushViewController:allInfoVC animated:YES];
    };
    [morePopView show];
    
    
}


@end

//
//  YBLCompanyTypePricesViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCompanyTypePricesViewController.h"
#import "YBLCompanyTypePricesService.h"

@interface YBLCompanyTypePricesViewController ()

@property (nonatomic, strong) YBLCompanyTypePricesService *service;

@end

@implementation YBLCompanyTypePricesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"多价格设置";

    UIButton *upDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upDownButton.frame = CGRectMake(0, 0, 23, 23);
    [upDownButton setImage:[UIImage newImageWithNamed:@"up_icon" size:CGSizeMake(23, 23)] forState:UIControlStateNormal];
    [upDownButton setImage:[UIImage newImageWithNamed:@"down_icon" size:CGSizeMake(23, 23)] forState:UIControlStateSelected];
    UIBarButtonItem *upDownItem = [[UIBarButtonItem alloc] initWithCustomView:upDownButton];
    WEAK
    [[upDownButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if (self.viewModel.pricesDataArray.count==0) {
            return ;
        }
        x.selected = !x.selected;
        [self.service showUpDown:x.selected];
    }];
    //默认
    upDownButton.selected = YES;

    self.navigationItem.rightBarButtonItems = @[upDownItem,self.explainButtonItem];
    
    self.service = [[YBLCompanyTypePricesService alloc] initWithVC:self ViewModel:self.viewModel];

}

- (void)explainButtonItemClick:(UIBarButtonItem *)btn{
    
    [YBLMethodTools pushWebVcFrom:self URL:H5_URL_SalePriceAndPISettingDeclare title:@"销售价格以及起批量设置说明"];
}

@end

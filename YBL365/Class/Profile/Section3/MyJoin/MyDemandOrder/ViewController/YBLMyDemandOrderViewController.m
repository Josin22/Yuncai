//
//  YBLMyDemandOrderViewController.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyDemandOrderViewController.h"
#import "YBLMyDemandOrderService.h"
#import "YBLMyDemandOrderViewModel.h"
@interface YBLMyDemandOrderViewController ()
@property (nonatomic,strong)YBLMyDemandOrderService *service;
@end

@implementation YBLMyDemandOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的需求订单";
    YBLMyDemandOrderViewModel *viewModel = [[YBLMyDemandOrderViewModel alloc]init];
    self.service = [[YBLMyDemandOrderService alloc]initWithVC:self ViewModel:viewModel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

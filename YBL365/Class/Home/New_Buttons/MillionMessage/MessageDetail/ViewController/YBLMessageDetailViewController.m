//
//  YBLMessageDetailViewController.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMessageDetailViewController.h"
#import "YBLMessageDetailService.h"

@interface YBLMessageDetailViewController ()

@property (nonatomic, strong) YBLMessageDetailService *service;

@end

@implementation YBLMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"通知详情";
    
    self.service = [[YBLMessageDetailService alloc] initWithVC:self ViewModel:self.viewModel];
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

//
//  YBLMyMesssageViewController.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyMesssageViewController.h"
#import "YBLMyMessageService.h"
#import "YBLMyMessageViewModel.h"
@interface YBLMyMesssageViewController ()
@property (nonatomic,strong)YBLMyMessageService *service;
@end

@implementation YBLMyMesssageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知消息";
    YBLMyMessageViewModel *viewModel = [[YBLMyMessageViewModel alloc]init];
    self.service = [[YBLMyMessageService alloc]initWithVC:self ViewModel:viewModel];
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

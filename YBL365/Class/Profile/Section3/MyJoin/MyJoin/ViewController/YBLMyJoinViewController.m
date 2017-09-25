//
//  YBLMyJoinViewController.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyJoinViewController.h"
#import "YBLMyJoinServiece.h"
#import "YBLMyJoinViewModel.h"
@interface YBLMyJoinViewController ()
@property (nonatomic,strong) YBLMyJoinServiece*service;
@end

@implementation YBLMyJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = [UIColor clearColor];
    YBLMyJoinViewModel *viewModel = [[YBLMyJoinViewModel alloc]init];
    self.service = [[YBLMyJoinServiece alloc]initWithVC:self ViewModel:viewModel];
    
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

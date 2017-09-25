//
//  YBLMyBrowsingHistoryViewController.m
//  YBL365
//
//  Created by 代恒彬 on 2017/1/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyBrowsingHistoryViewController.h"
#import "YBLMyBrowsingHistoryViewModel.h"
#import "YBLMyBrowsingHistoryService.h"
@interface YBLMyBrowsingHistoryViewController ()
@property (nonatomic,strong)YBLMyBrowsingHistoryService *service;
@end

@implementation YBLMyBrowsingHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览记录";
    YBLMyBrowsingHistoryViewModel *viewModel = [[YBLMyBrowsingHistoryViewModel alloc]init];
    self.service = [[YBLMyBrowsingHistoryService alloc]initWithVC:self ViewModel:viewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

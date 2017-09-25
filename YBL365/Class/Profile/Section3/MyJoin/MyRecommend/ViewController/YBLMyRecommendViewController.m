//
//  YBLMyRecommendViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMyRecommendViewController.h"
#import "YBLMyRecommendService.h"

@interface YBLMyRecommendViewController ()

@property (nonatomic, strong) YBLMyRecommendService *service;

@end

@implementation YBLMyRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"参与列表";
    
    YBLMyRecommendViewModel *viewModel = [[YBLMyRecommendViewModel alloc] init];
    self.service = [[YBLMyRecommendService alloc] initWithVC:self ViewModel:viewModel];
}



@end

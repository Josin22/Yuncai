//
//  YBLOrderCommentsViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderCommentsViewController.h"
#import "YBLOrderCommentsService.h"
#import "YBLOrderCommentsViewModel.h"

@interface YBLOrderCommentsViewController ()

@property (nonatomic, strong) YBLOrderCommentsViewModel *viewModel;

@property (nonatomic, strong) YBLOrderCommentsService *service;

@end

@implementation YBLOrderCommentsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.service requestDataIsReload:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评价中心";
    
    self.viewModel = [YBLOrderCommentsViewModel new];
    
    self.service = [[YBLOrderCommentsService alloc] initWithVC:self ViewModel:self.viewModel];

}

@end

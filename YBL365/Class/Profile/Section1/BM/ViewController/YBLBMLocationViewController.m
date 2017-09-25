//
//  YBLBMLocationViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBMLocationViewController.h"
#import "YBLBMLocationService.h"


@interface YBLBMLocationViewController ()

@property (nonatomic, strong) YBLBMLocationService *service;

@end

@implementation YBLBMLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"位置";
        
    self.service = [[YBLBMLocationService alloc] initWithVC:self ViewModel:self.viewModel];
}


@end

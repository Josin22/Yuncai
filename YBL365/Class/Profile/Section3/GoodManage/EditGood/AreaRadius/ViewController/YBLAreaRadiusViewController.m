//
//  YBLAreaRadiusViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLAreaRadiusViewController.h"
#import "YBLAreaRadiusService.h"

@interface YBLAreaRadiusViewController ()

@property (nonatomic, strong) YBLAreaRadiusService *service;

@end

@implementation YBLAreaRadiusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"同城配送";
    
    self.service = [[YBLAreaRadiusService alloc] initWithVC:self ViewModel:self.viewModel];
}



@end

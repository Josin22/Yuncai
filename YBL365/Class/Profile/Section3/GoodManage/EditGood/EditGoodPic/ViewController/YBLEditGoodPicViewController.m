//
//  YBLEditGoodPicViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEditGoodPicViewController.h"
#import "YBLEditGoodPicService.h"

@interface YBLEditGoodPicViewController ()

@property (nonatomic, strong) YBLEditGoodPicService *service;

@end

@implementation YBLEditGoodPicViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.isPopGestureRecognizerEnable = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.viewModel.editPicType == EditPicTypeMain) {
        self.navigationItem.title = @"主图";
    } else {
        self.navigationItem.title = @"详情图";
    }
    self.service = [YBLEditGoodPicService serviceWithVC:self ViewModel:self.viewModel];
}

@end

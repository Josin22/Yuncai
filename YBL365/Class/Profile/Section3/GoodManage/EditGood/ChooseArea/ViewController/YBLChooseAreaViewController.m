//
//  YBLChooseAreaViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLChooseAreaViewController.h"
#import "YBLChooseAreaService.h"

@interface YBLChooseAreaViewController ()

@property  (nonatomic, strong) YBLChooseAreaService *service;

@end

@implementation YBLChooseAreaViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择地区";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.service = [[YBLChooseAreaService alloc] initWithVC:self ViewModel:self.viewModel];
    
}

- (void)goback1{
    
    if (self.viewModel.chooseAreaVCType == ChooseAreaVCTypeGetAll||self.viewModel.chooseAreaVCType == ChooseAreaVCTypeGetPart) {
        
        BLOCK_EXEC(self.viewModel.chooseAreaSaveBlock,self.viewModel.selectAreaDataDict);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end

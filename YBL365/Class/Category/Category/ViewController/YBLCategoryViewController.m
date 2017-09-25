//
//  YBLCategoryViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/17.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCategoryViewController.h"
#import "YBLCategoryUIService.h"
#import "YBLGoodListViewController.h"
#import "YBLNetWorkHudBar.h"

@interface YBLCategoryViewController ()

@property (nonatomic,strong) YBLCategoryUIService *categoryUIService;

@end

@implementation YBLCategoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//       self.netHudBar.top = kNavigationbarHeight;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self starUIService];

}


- (void)starUIService {
    
    self.categoryUIService = [[YBLCategoryUIService alloc] initWithVC:self ViewModel:self.viewModel];
   
}


@end

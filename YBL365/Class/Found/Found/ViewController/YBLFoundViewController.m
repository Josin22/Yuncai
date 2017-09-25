//
//  YBLFoundViewController.m
//  YBL365
//
//  Created by 乔同新 on 16/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLFoundViewController.h"
#import "YBLFoundUIService.h"


@interface YBLFoundViewController ()

@property (nonatomic, strong) YBLFoundUIService * foundUIService;

@end

@implementation YBLFoundViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.viewModel = [YBLFoundViewModel new];
    
    self.foundUIService = [[YBLFoundUIService alloc] initWithVC:self ViewModel:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.foundUIService addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.foundUIService destroyTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

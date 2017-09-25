//
//  YBLFoundPurchaseViewController.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundMyPurchaseViewController.h"
#import "YBLFoundMyPurchaseService.h"

@interface YBLFoundMyPurchaseViewController ()

@property (nonatomic, strong) YBLFoundMyPurchaseService *servic;

@end

@implementation YBLFoundMyPurchaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.servic = [[YBLFoundMyPurchaseService alloc] initWithVC:self ViewModel:self.viewModel];
}

@end

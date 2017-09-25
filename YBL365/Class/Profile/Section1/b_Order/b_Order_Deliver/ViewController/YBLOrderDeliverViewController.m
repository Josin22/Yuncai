//
//  YBLOrderDeliverViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLOrderDeliverViewController.h"
#import "YBLOrderDeliverService.h"

@interface YBLOrderDeliverViewController ()

@property (nonatomic, strong) YBLOrderDeliverService *service;

@end

@implementation YBLOrderDeliverViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"订单跟踪";
    
//    NSString *numbber = [@"您的订单由第三方卖家发货人员（01冀宇航）18539252165已发货，感谢您的耐心等待" firstMatch:RX(@"\\d{11}")];
//    NSLog(@"numbber:%@",numbber);
    
    self.service = [[YBLOrderDeliverService alloc] initWithVC:self ViewModel:self.viewModel];
}



@end

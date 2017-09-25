//
//  YBLManageDistributionService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManageDistributionService.h"
#import "YBLManageDistributionViewController.h"

@interface YBLManageDistributionService ()

@property (nonatomic, weak) YBLManageDistributionViewController *Vc;

@property (nonatomic, strong) YBLManageDistributionViewModel *viewModel;

@end

@implementation YBLManageDistributionService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _viewModel = (YBLManageDistributionViewModel *)viewModel;
        _Vc = (YBLManageDistributionViewController *)VC;
        
    }
    return self;
}


@end

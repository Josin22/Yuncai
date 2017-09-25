//
//  YBLManageStatisticsService.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLManageStatisticsService.h"
#import "YBLManageStatisticsViewController.h"


@interface YBLManageStatisticsService ()

@property (nonatomic, weak) YBLManageStatisticsViewController *Vc;

@property (nonatomic, strong) YBLManageStatisticsViewModel *viewModel;



@end

@implementation YBLManageStatisticsService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        _Vc = (YBLManageStatisticsViewController *)VC;
        _viewModel = (YBLManageStatisticsViewModel *)viewModel;
        
        
    }
    return self;
}




@end

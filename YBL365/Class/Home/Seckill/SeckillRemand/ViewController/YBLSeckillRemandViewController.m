//
//  YBLSeckillRemandViewController.m
//  YBL365
//
//  Created by 乔同新 on 12/23/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillRemandViewController.h"
#import "YBLSeckillTableView.h"

@interface YBLSeckillRemandViewController ()

@property (nonatomic, strong) YBLSeckillTableView *remandTableView;

@end

@implementation YBLSeckillRemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的提醒";
    
    [self.view addSubview:self.remandTableView];
}

- (YBLSeckillTableView *)remandTableView{
    
    if (!_remandTableView) {
        _remandTableView = [[YBLSeckillTableView alloc] initWithFrame:[self.view bounds] style:UITableViewStyleGrouped Type:SeckillTableViewTypeCategoty];
        _remandTableView.test = 2;
    }
    return _remandTableView;
}


@end

//
//  YBLMessageDetailService.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/1.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMessageDetailService.h"
#import "YBLMessageDetailViewController.h"
#import "YBLMessageDetailTableView.h"

@interface YBLMessageDetailService()

@property (nonatomic, strong) YBLMessageDetailTableView *messageTableView;

@property (nonatomic, weak  ) YBLMessageDetailViewController *selfVc;

@property (nonatomic, weak  ) YBLMessageDetailViewModel *viewModel;

@end

@implementation YBLMessageDetailService

- (instancetype)initWithVC:(UIViewController *)VC ViewModel:(NSObject *)viewModel{
    
    if (self = [super initWithVC:VC ViewModel:viewModel]) {
        
        self.selfVc = (YBLMessageDetailViewController *)VC;
        self.viewModel = (YBLMessageDetailViewModel *)viewModel;
        
        [self requestMessageIsReload:YES];
    }
    return self;
}

- (void)requestMessageIsReload:(BOOL)isReload{
    WEAK
    [[self.viewModel singalForMessageIsReload:isReload] subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        STRONG
        [self.messageTableView.mj_header endRefreshing];
        [self.messageTableView jsInsertRowIndexps:self.viewModel.fin_indexps];
    }];
}

- (YBLMessageDetailTableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[YBLMessageDetailTableView alloc] initWithFrame:[self.selfVc.view bounds]
                                                                       style:UITableViewStyleGrouped];
        [self.selfVc.view addSubview:_messageTableView];
        _messageTableView.dataArray = self.viewModel.singleDataArray;
        WEAK
        _messageTableView.prestrainBlock = ^{
            STRONG
            [self requestMessageIsReload:NO];
        };
        [YBLMethodTools headerRefreshWithTableView:_messageTableView completion:^{
            STRONG
            [self requestMessageIsReload:YES];
        }];
    }
    return _messageTableView;
}

@end

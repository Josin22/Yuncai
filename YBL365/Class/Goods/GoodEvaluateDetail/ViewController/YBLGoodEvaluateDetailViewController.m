//
//  YBLGoodEvaluateDetailViewController.m
//  YC168
//
//  Created by 乔同新 on 2017/6/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodEvaluateDetailViewController.h"
#import "YBLPicTableView.h"
#import "YBLOrderCommentsItemModel.h"
#import "YBLFooterSignView.h"

@interface YBLGoodEvaluateDetailViewController ()

@property (nonatomic, strong) YBLPicTableView *commentsDetailTableView;

@end

@implementation YBLGoodEvaluateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"评价详情";
    
    self.commentsDetailTableView.commentModel = self.commentModel;
}


- (YBLPicTableView *)commentsDetailTableView{
    if (!_commentsDetailTableView) {
        _commentsDetailTableView = [[YBLPicTableView alloc] initWithFrame:[self.view bounds]
                                                                    style:UITableViewStylePlain
                                                         picTableViewType:PicTableViewTypeCommentsHeader];
        _commentsDetailTableView.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, _commentsDetailTableView.width, kNavigationbarHeight)];
        [self.view addSubview:_commentsDetailTableView];
    }
    return _commentsDetailTableView;
}

@end

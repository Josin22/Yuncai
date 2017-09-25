//
//  YBLBaseTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseTableView.h"
#import "YBLFooterSignView.h"

@interface YBLBaseTableView ()<UIScrollViewDelegate>

@end

@implementation YBLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLEditPurchaseCell getItemCellHeightWithModel:nil];
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        [self registerClass:NSClassFromString(@"YBLEditPurchaseCell") forCellReuseIdentifier:@"YBLEditPurchaseCell"];
        
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self endEditing:YES];
}

@end

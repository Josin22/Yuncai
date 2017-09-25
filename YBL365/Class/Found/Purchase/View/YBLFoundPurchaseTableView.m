//
//  YBLFoundPurchaseTableView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundPurchaseTableView.h"
#import "YBLFoundPurchaseCell.h"

@interface YBLFoundPurchaseTableView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YBLFoundPurchaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = YBLViewBGColor;
        self.showsVerticalScrollIndicator = NO;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.rowHeight = [YBLFoundPurchaseCell getPurchaseCellHeight];
        
        [self registerClass:NSClassFromString(@"YBLFoundPurchaseCell") forCellReuseIdentifier:@"YBLFoundPurchaseCell"];
   
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLFoundPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLFoundPurchaseCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLFoundPurchaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WEAK
    [[[cell.wantPurchaseButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        BLOCK_EXEC(self.foundPurchaseTableViewCellSelectBlock,);    
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BLOCK_EXEC(self.foundPurchaseTableViewCellSelectBlock,);
}

@end

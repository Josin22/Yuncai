//
//  YBLMessageDetailTableView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMessageDetailTableView.h"
#import "YBLMessageItemCell.h"
#import "YBLCustomersLogsModel.h"

@interface YBLMessageDetailTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end

@implementation YBLMessageDetailTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.isShowFooterSignView = YES;
        self.backgroundColor = YBLColor(237, 237, 237, 1);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[YBLMessageItemCell class] forCellReuseIdentifier:@"YBLMessageItemCell"];
    }
    return self;
}


#pragma mark - UITableViewDataSourc

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [YBLMessageItemCell getItemCellHeightWithModel:self.dataArray[indexPath.section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 17)];
    timeLabel.layer.cornerRadius = 3;
    timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    timeLabel.layer.masksToBounds = YES;
    timeLabel.font = YBLFont(10);
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:timeLabel];
    
    YBLCustomersLogsModel *model = self.dataArray[section];
    timeLabel.text = model.created_at;
    timeLabel.width = model.time_width;
    timeLabel.centerX = headerView.width/2;
    timeLabel.centerY = headerView.height/2;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLMessageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLMessageItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLMessageItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell updateItemCellModel:self.dataArray[indexPath.section]];
}


#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_message";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有发送通知记录~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(17),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

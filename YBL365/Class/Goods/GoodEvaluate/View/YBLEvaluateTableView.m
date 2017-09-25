//
//  YBLEvaluateTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEvaluateTableView.h"
//#import "YBLEvaluateDetailCell.h"
#import "YBLOrderCommentsItemModel.h"
#import "YBLGridView.h"
#import "YBLFooterSignView.h"
#import "YBLEvaluateOnePicCell.h"
#import "YBLEvaluateFourCell.h"
#import "YBLEvaluateNineSortCell.h"

@interface YBLEvaluateTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) YBLGridView *gridView;

@end

@implementation YBLEvaluateTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:NSClassFromString(@"YBLEvaluateBaseCell") forCellReuseIdentifier:@"YBLEvaluateBaseCell"];
        [self registerClass:NSClassFromString(@"YBLEvaluateOnePicCell") forCellReuseIdentifier:@"YBLEvaluateOnePicCell"];
        [self registerClass:NSClassFromString(@"YBLEvaluateFourCell") forCellReuseIdentifier:@"YBLEvaluateFourCell"];
        [self registerClass:NSClassFromString(@"YBLEvaluateNineSortCell") forCellReuseIdentifier:@"YBLEvaluateNineSortCell"];
        
    }
    return self;
}

#pragma mark - data source / degate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLOrderCommentsModel *itemModel = self.dataArray[indexPath.section];
    
    return [YBLEvaluateBaseCell getItemCellHeightWithModel:itemModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLOrderCommentsModel *commentsModel = self.dataArray[indexPath.section];
    
    //根据不同的唯一标识重用不同的cell
    YBLEvaluateBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsModel.cell_name];
    
    if (cell == nil) {
        //根据我们每行提供的model创建出对应的cell（根据不同的需求生产不同的产品）
        cell = [YBLEvaluateBaseCell initWithModel:commentsModel];
    }

    [cell updateItemCellModel:commentsModel];
    
    WEAK
    cell.gridView.itemClickBlock = ^(NSInteger index,UIImageView *clickImageView) {
        NSLog(@"----======%@",@(index));
        STRONG
        commentsModel.currentIndex = index;
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:commentsModel tableview:clickImageView];
        }
    };
    
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:indexPath.section]) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLOrderCommentsModel *commentsModel = self.dataArray[indexPath.section];
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:commentsModel tableview:self];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"order_comments";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"这里空空如也 \n 快去评价晒单吧~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(17),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavigationbarHeight-buttonHeight;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

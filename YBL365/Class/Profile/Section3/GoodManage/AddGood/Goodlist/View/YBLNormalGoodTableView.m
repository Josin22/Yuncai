//
//  YBLNormalGoodTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLNormalGoodTableView.h"
#import "YBLAddGoodListCell.h"
#import "YBLGoodModel.h"
#import "YBLFooterSignView.h"
#import "YBLRewardGoodCell.h"

@interface YBLNormalGoodTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) NormalTableViewType tableViewType;

@end

@implementation YBLNormalGoodTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame
                         style:style
                 tableViewType:NormalTableViewTypeGood];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                tableViewType:(NormalTableViewType)tableViewType{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _tableViewType = tableViewType;
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.rowHeight = [YBLAddGoodListCell getItemCellHeightWithModel:nil];
        NSString *cellIndenti = [self getCellName];
        [self registerClass:NSClassFromString(cellIndenti) forCellReuseIdentifier:cellIndenti];
        self.backgroundColor = [UIColor whiteColor];
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return self;
}

- (NSString *)getCellName{
    NSString  *cellName = @"YBLAddGoodListCell";
    if (_tableViewType == NormalTableViewTypeFollowGood) {
        cellName = @"YBLFollowGoodCell";
    } else if (_tableViewType == NormalTableViewTypeNotCommentsGood){
        cellName = @"YBLNotCommentsGoodCell";
    } else if (_tableViewType == NormalTableViewTypeCommentedGood){
        cellName = @"YBLCommentedGoodCell";
    } else if (_tableViewType == NormalTableViewTypeFooterRecordsGood){
        cellName = @"YBLFooterRecordsGoodCell";
    }  else if (_tableViewType == NormalTableViewTypeRewardToShareGood){
        cellName = @"YBLRewardGoodCell";
    }
    return cellName;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIndenti = [self getCellName];
    
    YBLAddGoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenti forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLAddGoodListCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger row = indexPath.row;
    
    id model = self.dataArray[row];
    
    [cell updateItemCellModel:model];
    
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellResetCell:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellResetCell:cell tableview:self];
    }
    
    WEAK
    [[[cell.addToStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:model tableview:self];
        }
    }];

    BOOL isSatify = [YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:row];
    if (isSatify) {
        BLOCK_EXEC(self.prestrainBlock,);
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YBLGoodModel *model = self.dataArray[indexPath.row];
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
    }
}

#pragma mark - delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableViewType == NormalTableViewTypeFollowGood||_tableViewType == NormalTableViewTypeFooterRecordsGood) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableViewType == NormalTableViewTypeFooterRecordsGood) {
        return @"删除商品";
    }
    return @"取消\n关注";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellSlideToClickWithIndexPath:selectValue:tableview:)]) {
            id model = self.dataArray[indexPath.row];
            [self.ybl_delegate ybl_tableViewCellSlideToClickWithIndexPath:indexPath selectValue:model tableview:self];
        }
    }
}


#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_good";
    if (_tableViewType == NormalTableViewTypeNotCommentsGood||_tableViewType == NormalTableViewTypeCommentedGood){
        imageName = @"order_comments";
    } else if (_tableViewType == NormalTableViewTypeFooterRecordsGood){
        imageName = @"footPrint";
    }
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有商品数据哦~";
    if (_tableViewType == NormalTableViewTypeNotCommentsGood){
        text = @"没有待评价的商品哦~";
    } else if (_tableViewType == NormalTableViewTypeCommentedGood){
        text = @"这里空空如也 \n 快去评价晒单吧~";
    } else if (_tableViewType == NormalTableViewTypeFooterRecordsGood){
        text = @"暂无浏览记录~";
    }
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    if (_tableViewType == NormalTableViewTypeNotCommentsGood||_tableViewType == NormalTableViewTypeCommentedGood){
        return -kNavigationbarHeight-buttonHeight;
    }
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

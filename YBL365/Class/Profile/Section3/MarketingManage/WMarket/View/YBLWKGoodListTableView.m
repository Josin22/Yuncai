//
//  YBLWKGoodListTableView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLWKGoodListTableView.h"
#import "YBLWMarketGoodCell.h"
#import "YBLProductShareManageCell.h"

@interface YBLWKGoodListTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) WKType wkype;

@end

@implementation YBLWKGoodListTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    return [self initWithFrame:frame
                         style:style
                          type:WKTypeMarket];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                         type:(WKType)type{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.wkype = type;
        self.dataSource = self;
        self.delegate   = self;
        self.isShowFooterSignView = YES;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLWMarketGoodCell getItemCellHeightWithModel:nil];
        NSString *currentClassName = [self getCurrentCellClassName];
        [self registerClass:NSClassFromString(currentClassName) forCellReuseIdentifier:currentClassName];
       
    }
    return self;
}

- (NSString *)getCurrentCellClassName{
    NSString *fin_string = @"YBLWMarketGoodCell";
    if (self.wkype == WKTypeReward) {
        fin_string = @"YBLProductShareManageCell";
    }
    return fin_string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *currentClassName = [self getCurrentCellClassName];
    YBLWMarketGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:currentClassName forIndexPath:indexPath];
    
    id itemModel = self.dataArray[indexPath.row];
    
    [cell updateItemCellModel:itemModel];
    
    WEAK
    [[[cell.addToStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:itemModel tableview:self];
        }
    }];
    
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:indexPath.row]) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.wkype == WKTypeReward) {
        return NO;
    }
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row;
        id itemModel = self.dataArray[row];
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellSlideToClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellSlideToClickWithIndexPath:indexPath selectValue:itemModel tableview:self];
        }
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_data_good";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有添加微营销商品哟";
    
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

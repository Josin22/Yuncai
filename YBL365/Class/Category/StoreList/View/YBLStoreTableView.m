//
//  YBLStoreTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreTableView.h"
#import "YBLStoreListCell.h"
#import "shop.h"
#import "YBLFooterSignView.h"
#import "YBLStoreRedbagCell.h"

@interface YBLStoreTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) StoreListType listType;

@end

@implementation YBLStoreTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame style:style listType:StoreListTypeBaseInfo];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                     listType:(StoreListType)listType{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _listType = listType;
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.tableFooterView = [[YBLFooterSignView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, kNavigationbarHeight)];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (_listType == StoreListTypeBaseInfo) {
            self.rowHeight = [YBLStoreBaseInfoCell getItemCellHeightWithModel:nil];
            [self registerClass:NSClassFromString(@"YBLStoreBaseInfoCell") forCellReuseIdentifier:@"YBLStoreBaseInfoCell"];
        } else if (_listType == StoreListTypeRedBag){
            self.rowHeight = [YBLStoreRedbagCell getItemCellHeightWithModel:nil];
            [self registerClass:NSClassFromString(@"YBLStoreRedbagCell") forCellReuseIdentifier:@"YBLStoreRedbagCell"];
        } else {
            self.rowHeight = [YBLStoreListCell getItemCellHeightWithModel:nil];
            [self registerClass:NSClassFromString(@"YBLStoreListCell") forCellReuseIdentifier:@"YBLStoreListCell"];
        }

    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_listType == StoreListTypeBaseInfo) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (_listType == StoreListTypeBaseInfo) {
        return self.dataArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_listType == StoreListTypeBaseInfo) {
        return 0.1;
    }
    return space;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (_listType == StoreListTypeBaseInfo) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreBaseInfoCell" forIndexPath:indexPath];
    } else if (_listType == StoreListTypeRedBag){
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreRedbagCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreListCell" forIndexPath:indexPath];
    }
    [self configureCell:(YBLStoreListCell *)cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLStoreListCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger iondx = indexPath.section;
    if (_listType == StoreListTypeBaseInfo) {
        iondx = indexPath.row;
    }
    shop *shopModel = self.dataArray[iondx];
    [cell updateItemCellModel:shopModel];
    WEAK
    if (_listType == StoreListTypeSearch) {
        //点击商品
        cell.storeListGoodClickBlock = ^(YBLGoodModel *selectGoodModel){
            STRONG
            if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
                [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:selectGoodModel tableview:self];
            }
        };
    }
    //点击店铺
    [[[cell.bgStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:shopModel tableview:self];
        }
    }];

    NSInteger currentRow = indexPath.section;
    if (_listType == StoreListTypeBaseInfo) {
        currentRow = indexPath.row;
    }
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.dataArray.count currentRow:currentRow]) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]&&_listType == StoreListTypeBaseInfo) {
        id model = self.dataArray[indexPath.row];
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
    }
}

#pragma mark - delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_listType == StoreListTypeBaseInfo) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消关注";
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
    NSString *imageName = @"null_data_store";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    if (_listType == StoreListTypeBaseInfo) {
        text = @"您还没有关注的店铺哟~";
    } else if (_listType == StoreListTypeRedBag){
        text = @"抱歉,没有红包店铺哟~";
    } else {
        text = @"抱歉,没有找到店铺~";
    }
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(14),
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

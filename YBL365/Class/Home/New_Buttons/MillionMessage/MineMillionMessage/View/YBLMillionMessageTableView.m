//
//  YBLMillionMessageTableView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLMillionMessageTableView.h"
#import "YBLMillionMessageItemBaseCell.h"
#import "YBLFooterSignView.h"

@interface YBLMillionMessageTableView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) MillionType millionType;

@end

@implementation YBLMillionMessageTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame
                         style:style
                   millionType:MillionTypePublic];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                  millionType:(MillionType)millionType{
    
    if (self = [super initWithFrame:frame style:style]) {
        _millionType = millionType;
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.isShowFooterSignView = YES;    
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLMillionMessageItemBaseCell getItemCellHeightWithModel:nil];
        NSString *className = [self getCellClassName];
        [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];

    }
    return self;
}

- (void)setMilionDataArray:(NSMutableArray *)milionDataArray{
    _milionDataArray = milionDataArray;
//    for (YBLMineMillionMessageItemModel *model in _milionDataArray) {
//        model.fake_phone = model.mobile;
//    }
}

- (NSString *)getCellClassName{
    NSString *className = nil;
    if (_millionType == MillionTypePublic) {
        className = @"YBLMillionMessageItemCell";
    } else if (_millionType == MillionTypeMine){
        className = @"YBLMineMillionMessageItemCell";
    } else if (_millionType == MillionTypeSelect){
        className = @"YBLMillionMessageSelectCell";
    }
    return className;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.milionDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return space;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, space)];
    topView.backgroundColor = YBLColor(240, 240, 240, 1);
    return topView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [self getCellClassName];
    
    YBLMillionMessageItemBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLMillionMessageItemBaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLMineMillionMessageItemModel *model = self.milionDataArray[indexPath.row];
    [cell updateItemCellModel:model];
    WEAK
    [[[cell.fousButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            x.selected = YES;
            [cell showMoneyView];
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:model tableview:self];
        }
    }];

    [[[cell.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
//        x.selected  = !x.selected;
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:model tableview:self];
        }
    }];
    
    [[[cell.iconTap rac_gestureSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        STRONG
         [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:model tableview:self];
    }];
    
    if ([YBLMethodTools isSatisfyPrestrainDataWithAllcount:self.milionDataArray.count currentRow:indexPath.row]) {
        BLOCK_EXEC(self.prestrainBlock,);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.ybl_delegate  respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        YBLMineMillionMessageItemModel *model = self.milionDataArray[indexPath.row];
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_customers";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"该分类暂无数据,请稍后再试~";
    
    NSDictionary *attributes = @{NSFontAttributeName: YBLFont(17),
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20.0f;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

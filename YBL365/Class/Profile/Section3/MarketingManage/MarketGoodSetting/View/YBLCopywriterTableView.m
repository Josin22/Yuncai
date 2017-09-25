//
//  YBLCopywriterTableView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/9.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCopywriterTableView.h"
#import "YBLCopyWriterItemCell.h"

@interface YBLCopywriterTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger currentIndex;
}
@property (nonatomic, assign) CopywriterTableViewType tableViewType;

@end

@implementation YBLCopywriterTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame
                         style:style
                 tableViewType:CopywriterTableViewTypeEdit];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                tableViewType:(CopywriterTableViewType)tableViewType{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        _tableViewType = tableViewType;
        currentIndex = -1;
        
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        [self registerClass:NSClassFromString(@"YBLCopyWriterItemCell") forCellReuseIdentifier:@"YBLCopyWriterItemCell"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *valueString = self.dataArray[indexPath.row];
    return [YBLCopyWriterItemCell getItemCellHeightWithModel:valueString];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLCopyWriterItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLCopyWriterItemCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLCopyWriterItemCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *valueString = self.dataArray[row];
    [cell updateItemCellModel:valueString];
    if (_tableViewType == CopywriterTableViewTypeEdit) {
        cell.editButton.hidden = NO;
        WEAK
        [[[cell.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            STRONG
            if ([self.cp_delegate respondsToSelector:@selector(copywriterCellButtonClickIndexPath:selectValue:)]) {
                NSIndexPath *new_path = [self indexPathForCell:cell];
                [self.cp_delegate copywriterCellButtonClickIndexPath:new_path selectValue:valueString];
            }
        }];
    } else {
        cell.editButton.hidden = YES;
        cell.cwTextLabel.width = self.width-2*space;
        if (row == currentIndex) {
            cell.cwTextLabel.textColor = YBLThemeColor;
        } else {
            cell.cwTextLabel.textColor = BlackTextColor;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSString *valueString = self.dataArray[row];
    if (_tableViewType == CopywriterTableViewTypeChoose) {
        if (currentIndex!=row) {
            currentIndex = row;
            [self jsReloadData];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = valueString;
            [SVProgressHUD showSuccessWithStatus:@"文案已复制成功~"];
        }
    }
    if ([self.cp_delegate respondsToSelector:@selector(copywriterCellDidSelectIndexPath:selectValue:)]) {
        [self.cp_delegate copywriterCellDidSelectIndexPath:indexPath selectValue:valueString];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_copywriter";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"你还没有添加文案哟~";
    
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

@end

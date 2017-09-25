//
//  YBLStoreFollowerTabelView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLStoreFollowerTabelView.h"
#import "YBLStoreFollowersCell.h"

@interface YBLStoreFollowerTabelView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) FollowType followType;

@end

@implementation YBLStoreFollowerTabelView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    return [self initWithFrame:frame
                         style:style
                          type:FollowTypeStore];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                         type:(FollowType)type{
    
    if (self = [super initWithFrame:frame style:style]) {
        self.followType = type;
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLStoreFollowersCell getItemCellHeightWithModel:nil];
        [self registerClass:NSClassFromString(@"YBLStoreFollowersCell") forCellReuseIdentifier:@"YBLStoreFollowersCell"];
        
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBLStoreFollowersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YBLStoreFollowersCell" forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLStoreFollowersCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id mode = self.dataArray[indexPath.row];
    [cell updateItemCellModel:mode];
    WEAK
    [[[cell.addToStoreButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:mode tableview:self];
        }
    }];
    [[[cell.iconTap rac_gestureSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellSlideToClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellSlideToClickWithIndexPath:indexPath selectValue:mode tableview:(UITableView *)cell.goodImageView];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YBLUserInfoModel *mode = self.dataArray[indexPath.row];
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:mode tableview:self];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_store_follow";
    if (self.followType == FollowTypeShares) {
        imageName = @"null_share_good";
    }
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您的店铺还没有人关注哟~";
    if (self.followType == FollowTypeShares) {
        text = @"您的商品还没有人分享哟~";
    }
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

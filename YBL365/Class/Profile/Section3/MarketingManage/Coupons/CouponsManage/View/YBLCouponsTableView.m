//
//  YBLCouponsTableView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCouponsTableView.h"
#import "YBLCouponsBaseCell.h"

@interface YBLCouponsTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, assign) CouponsStyle couponsStyle;

@end

@implementation YBLCouponsTableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style{
    
    return [self initWithFrame:frame
                         style:style
                  couponsStyle:CouponsStyleNormal];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                 couponsStyle:(CouponsStyle)couponsStyle{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.couponsStyle = couponsStyle;
        self.dataSource = self;
        self.delegate   = self;
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.isShowFooterSignView = YES;
        self.backgroundColor = YBLColor(243, 243, 243, 1);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rowHeight = [YBLCouponsBaseCell getItemCellHeightWithModel:nil];
        NSString *className = [self getCurrentCellClassName];
        [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
    return self;
}

- (NSString *)getCurrentCellClassName{
    NSString *className = @"YBLCouponsCell";
    if (self.couponsStyle == CouponsStyleSnap) {
        className = @"YBLSnapCouponsCell";
    } else if (self.couponsStyle == CouponsStyleGot){
        className = @"YBLCouponsGotCell";
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [self getCurrentCellClassName];
    YBLCouponsBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:className forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(YBLCouponsBaseCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataArray[indexPath.row];
    [cell updateItemCellModel:model];
    WEAK
    [[[cell.couponsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        STRONG
        if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellButtonClickWithIndexPath:selectValue:tableview:)]) {
            [self.ybl_delegate ybl_tableViewCellButtonClickWithIndexPath:indexPath selectValue:model tableview:self];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    if ([self.ybl_delegate respondsToSelector:@selector(ybl_tableViewCellDidSelectWithIndexPath:selectValue:tableview:)]) {
        [self.ybl_delegate ybl_tableViewCellDidSelectWithIndexPath:indexPath selectValue:model tableview:self];
    }
}

#pragma mark - empty datasource delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *imageName = @"null_coupons";
    return [UIImage imageNamed:imageName];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无优惠券哟~";
    
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

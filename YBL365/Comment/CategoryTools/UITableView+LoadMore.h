//
//  UITableView+YBLLoadMore.h
//  YC168
//
//  Created by 乔同新 on 2017/6/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBLTableViewDelegate <NSObject>

@optional;

- (void)ybl_tableViewCellDidSelectWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview;

- (void)ybl_tableViewCellButtonClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview;

- (void)ybl_tableViewCellSlideToClickWithIndexPath:(NSIndexPath *)indexPath selectValue:(id)selectValue tableview:(UITableView *)tableview;

- (void)ybl_tableViewCellResetCell:(UITableViewCell *)cell tableview:(UITableView *)tableview;

@end

@interface UITableView (LoadMore)

@property (nonatomic, weak  ) id <YBLTableViewDelegate> ybl_delegate;

@property (nonatomic, copy  ) ViewPrestrainBlock prestrainBlock;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isShowFooterSignView;

- (void)jsReloadData;

- (void)jsInsertRowIndexps:(NSMutableArray *)indexps;

- (void)jsInsertRowIndexps:(NSMutableArray *)indexps withRowAnimation:(UITableViewRowAnimation)animation;

@end

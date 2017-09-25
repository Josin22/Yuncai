//
//  UITableViewCell+updateModel.m
//  YC168
//
//  Created by 乔同新 on 2017/4/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "UITableViewCell+updateModel.h"

@implementation UITableViewCell (updateModel)

- (UITableView *)getTableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)updateItemCellModel:(id)itemModel{
    
}

+ (CGFloat)getItemCellHeightWithModel:(id)itemModel{
    //默认高度
    return 45;
}



@end

//
//  YBLLittlebOrderItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLOrderItemModel;

typedef void(^littlebOrderItemCellDiDSelectBlock)(YBLOrderItemModel *model,NSInteger index);

typedef void(^littlebOrderItemCellButtonBlock)(NSString * orderButtonCurrentTitle,YBLOrderPropertyItemModel *clickButtonModel);

@interface YBLLittlebOrderItemCell : UITableViewCell

@property (nonatomic, copy  ) littlebOrderItemCellDiDSelectBlock littlebOrderItemCellDiDSelectBlock;

@property (nonatomic, copy  ) littlebOrderItemCellButtonBlock littlebOrderItemCellButtonBlock;

+ (CGFloat)getlittlebOrderItemCellHi;

- (void)updateOrderItemModel:(YBLOrderItemModel *)model;

@end

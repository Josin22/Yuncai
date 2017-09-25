//
//  YBLBigBOrderItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

@class YBLOrderItemModel;

typedef void(^BigBOrderItemCellDiDSelectBlock)();

typedef void(^BigBOrderItemCellButtonClickBlock)(NSString *currentTitle,YBLOrderPropertyItemModel *clickButtonModel);

@interface YBLBigBOrderItemCell : UITableViewCell

@property (nonatomic, copy  ) BigBOrderItemCellDiDSelectBlock bigBOrderItemCellDiDSelectBlock;

@property (nonatomic, copy  ) BigBOrderItemCellButtonClickBlock bigBOrderItemCellButtonClickBlock;

- (void)updateModel:(YBLOrderItemModel *)model;

+ (CGFloat)getHI;

@end

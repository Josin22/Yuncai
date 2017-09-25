//
//  YBLShopCarItemCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBLAddSubtractView.h"

@class lineitems;

@interface YBLShopCarItemCell : UITableViewCell

@property (nonatomic, strong) YBLAddSubtractView *addSubtractView;

@property (nonatomic, strong) UIButton *checkAllButton; //选中按钮

- (void)updateItemsModel:(lineitems *)model;

+ (CGFloat)getItemCellHi;

@end

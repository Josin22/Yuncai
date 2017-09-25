//
//  YBLAddressTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/12.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLAddressModel.h"

typedef void(^AddressTableViewRowDefaultBlock)(YBLAddressModel *model,NSInteger section);

typedef void(^AddressTableViewRowDidSelectBlock)(YBLAddressModel *model,NSInteger section);

typedef void(^AddressTableViewCellEditButtonClickBlock)(YBLAddressModel *model);

typedef void(^AddressTableViewCellEmptyButtonClickBlock)(void);

typedef void(^AddressTableViewCellDeleteClickBlock)(YBLAddressModel *model,NSInteger section);

typedef void(^AddressTableViewCellDeleteClickBlock)(YBLAddressModel *model,NSInteger section);

@interface YBLAddressTableView : UITableView
/**
 *  cell点击
 */
@property (nonatomic, copy  ) AddressTableViewRowDidSelectBlock addressTableViewRowDidSelectBlock;
/**
 *  编辑点击按钮
 */
@property (nonatomic, copy  ) AddressTableViewCellEditButtonClickBlock addressTableViewCellButtonClickBlock;
/**
 *  空视图点击
 */
@property (nonatomic, copy  ) AddressTableViewCellEmptyButtonClickBlock addressTableViewCellEmptyButtonClickBlock;
/**
 *  删除
 */
@property (nonatomic, copy  ) AddressTableViewCellDeleteClickBlock addressTableViewCellDeleteClickBlock;
/**
 *  默认
 */
@property (nonatomic, copy  ) AddressTableViewRowDefaultBlock addressTableViewRowDefaultBlock;

@property (nonatomic, strong) NSMutableArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style addressGenre:(AddressGenre)addressGenre;

@end

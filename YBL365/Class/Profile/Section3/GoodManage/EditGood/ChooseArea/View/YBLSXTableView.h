//
//  YBLSXTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAddressAreaModel;

typedef void(^SXTableViewCellDidSelectBlock)(BOOL arrowOrNot,BOOL buttonSelect, YBLAddressAreaModel *model);

@interface YBLSXTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style tableType:(TableType)tableType;

@property (nonatomic, strong) SXTableViewCellDidSelectBlock sxTableViewCellDidSelectBlock;

- (void)updateArray:(NSArray *)dataArray Dict:(NSMutableDictionary *)dict;

@end

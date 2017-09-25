//
//  YBLShengTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAddressAreaModel;

typedef void(^ShengTableViewCellDidSelectBlock)(BOOL arrowOrNot,BOOL buttonSelect, YBLAddressAreaModel *model);

@interface YBLShengTableView : UITableView

@property (nonatomic, copy  ) ShengTableViewCellDidSelectBlock shengTableViewCellDidSelectBlock;

- (void)updateArray:(NSArray *)dataArray Dict:(NSMutableDictionary *)dict;

@end

//
//  YBLSetLogisticsPricesCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLAddSubtractView.h"

@interface YBLSetLogisticsPricesCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelectRow;

@property (nonatomic, retain) UILabel *logisticsTitleLabel;

@property (nonatomic, strong) YBLAddSubtractView *addSubView;

@end

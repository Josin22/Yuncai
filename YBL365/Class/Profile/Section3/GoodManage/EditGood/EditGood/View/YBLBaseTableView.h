//
//  YBLBaseTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/11.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLEditPurchaseCell.h"

@class YBLEditGoodViewModel,YBLEditGoodViewController;

@interface YBLBaseTableView : UITableView

@property (nonatomic, weak) YBLEditGoodViewModel *viewModel;

@property (nonatomic, weak) YBLEditGoodViewController *Vc;

@end

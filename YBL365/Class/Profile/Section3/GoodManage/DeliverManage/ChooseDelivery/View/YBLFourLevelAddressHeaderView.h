//
//  YBLFourLevelAddressHeaderView.h
//  YC168
//
//  Created by 乔同新 on 2017/4/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLChooseAreaViewModel.h"

@interface YBLFourLevelAddressHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) YBLChooseAreaViewModel *viewModel;

+ (CGFloat)getHeaderViewHeight;

@end

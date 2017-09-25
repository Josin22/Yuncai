//
//  YBLSeckillHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 12/22/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLTimeDown;

@interface YBLSeckillHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) YBLTimeDown *timeDownView;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end

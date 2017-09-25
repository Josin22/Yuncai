//
//  YBLOrderTableView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLOrderTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                  orderSource:(OrderSource)orderSource;

@end

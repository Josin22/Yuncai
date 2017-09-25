//
//  YBLStoreFollowerTabelView.h
//  YC168
//
//  Created by 乔同新 on 2017/6/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLStoreFollowViewModel.h"

@interface YBLStoreFollowerTabelView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                         type:(FollowType)type;

@end

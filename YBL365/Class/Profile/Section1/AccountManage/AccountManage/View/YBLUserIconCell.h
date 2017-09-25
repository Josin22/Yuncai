//
//  YBLUserIconCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/5.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLAccountManageItemModel;

@interface YBLUserIconCell : UITableViewCell

@property (nonatomic, strong) UIButton *clickButton;

- (void)updateModel:(YBLAccountManageItemModel *)model;

+ (CGFloat)getHi;

@end

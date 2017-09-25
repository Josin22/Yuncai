//
//  YBLMapItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/4/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLMapItemCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UILabel *titleInfoLabel;

@property (nonatomic, strong) UIImageView *duihaoImageView;

@property (nonatomic, assign) BOOL isSelectAddress;

@end

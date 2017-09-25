//
//  YBLAddGoodListCell.h
//  YC168
//
//  Created by 乔同新 on 2017/5/19.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLAddGoodListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, retain) UILabel *goodNameLabel;

@property (nonatomic, retain) UILabel *saleCountName;

@property (nonatomic, strong) UIButton *addToStoreButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *noStockImageView;

@end

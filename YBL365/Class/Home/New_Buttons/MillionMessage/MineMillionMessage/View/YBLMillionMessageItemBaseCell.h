//
//  YBLMillionMessageItemBaseCell.h
//  手机云采
//
//  Created by 乔同新 on 2017/7/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLMineMillionMessageItemModel.h"
#import "YBLCustomersLabel.h"

@interface YBLMillionMessageItemBaseCell : UITableViewCell

@property (nonatomic, retain) YBLCustomersLabel *nameLabel;

@property (nonatomic, strong) UITapGestureRecognizer *iconTap;

@property (nonatomic, retain) UILabel *phoneLabel;

@property (nonatomic, retain) UILabel *shopNameLabel;

@property (nonatomic, retain) UILabel *localLabel;

@property (nonatomic, strong) UIView *contentBGView;

@property (nonatomic, strong) UIButton *fousButton;

@property (nonatomic, strong) UIButton *selectButton;

- (void)showMoneyView;

@end

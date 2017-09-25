//
//  YBLShopCarHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/20.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLShopCarHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *checkAllButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UIImageView *moreImageView;

@property (nonatomic, strong) UIButton *expressMoneyButton;
@property (nonatomic, strong) UILabel *expressMoneyLabel;

@end

//
//  YBLShopCarStoreHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class shop;

@interface YBLShopCarStoreHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *checkAllButton;
@property (nonatomic, strong) UILabel *shopNameLabel;

@property (nonatomic, strong) UIButton *storeButton;

- (void)updataShop:(shop *)model;

+ (CGFloat)getHeaderHi;

@end

//
//  YBLShopCarFooterView.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBLCartModel;

@interface YBLShopCarFooterView : UITableViewHeaderFooterView

@property (nonatomic, retain) UILabel *label;

@property (nonatomic, retain) UILabel *priceLabel;

- (void)updataSingleSectionGood:(YBLCartModel *)model;

+ (CGFloat)getFooterHi;

@end

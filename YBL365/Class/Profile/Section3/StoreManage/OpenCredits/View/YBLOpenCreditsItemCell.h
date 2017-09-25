//
//  YBLOpenCreditsItemCell.h
//  YC168
//
//  Created by 乔同新 on 2017/3/25.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YBLCreditPriceStandardsModel.h"

@interface YBLOpenCreditsItemCell : UITableViewCell

//开通
@property (nonatomic, strong) UIButton *openCreditsButton;

- (void)updateModel:(YBLCreditPriceStandardsModel *)model;

+ (CGFloat)getHi;

@end

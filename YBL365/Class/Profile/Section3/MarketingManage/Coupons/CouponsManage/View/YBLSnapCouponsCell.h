//
//  YBLSnapCouponsCell.h
//  手机云采
//
//  Created by 乔同新 on 2017/8/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLCouponsBaseCell.h"

@interface YBLSnapCouponsCell : YBLCouponsBaseCell

@property (nonatomic, retain) UILabel *conditionLabel;

@property (nonatomic, retain) UILabel *valueLabel;

@property (nonatomic, retain) UILabel *goodTitleLabel;

@property (nonatomic, strong) UIImageView *goodImageView;

@property (nonatomic, strong) UIImageView *stateImageView;

@end

//
//  YBLSpecInfoCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/27.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLLabelsCell.h"

@interface YBLSpecInfoCell : YBLLabelsCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, strong) YBLButton *distanceButton;

+ (CGFloat)getHI;

@end

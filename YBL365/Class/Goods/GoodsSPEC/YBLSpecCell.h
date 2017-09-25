//
//  YBLSpecCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/2/18.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLAddSubtractView.h"

@interface YBLSpecCell : UITableViewCell

@property (nonatomic, retain) UILabel *spec1Label;

@property (nonatomic, retain) UILabel *spec2Label;

//@property (nonatomic, retain) UILabel *storgeLabel;

@property (nonatomic, strong) YBLAddSubtractView *addSubtractView;

+ (CGFloat)getSpecHi;

@end

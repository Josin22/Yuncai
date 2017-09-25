//
//  YBLGoodsSpecCell.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBLLabelsCell.h"

@interface YBLGoodsSpecCell : YBLLabelsCell

@property (nonatomic, retain) UILabel *specLabel;

+ (CGFloat)getGoodsSpecCellHeight;

@end

//
//  YBLGoodsOriginInfoCell.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLGoodsOriginInfoCell : UITableViewCell

@property (nonatomic, retain) UILabel *countLabel;

@property (nonatomic, strong) YBLButton *priceCountButton;

@property (nonatomic, retain) UILabel *originLabel;

@property (nonatomic, strong) YBLButton *cutsButton;

+ (CGFloat)getOriginInfoCellHeight;

@end

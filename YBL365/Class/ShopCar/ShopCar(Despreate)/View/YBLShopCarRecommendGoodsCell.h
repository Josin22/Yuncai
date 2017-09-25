//
//  YBLShopCarGoodsCell.h
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLShopCarRecommendGoodsCell : UITableViewCell

+ (CGFloat)getCellHi;

- (void)updateWithLeftGood:(id)leftGood rightGood:(id)rightGood;

@end

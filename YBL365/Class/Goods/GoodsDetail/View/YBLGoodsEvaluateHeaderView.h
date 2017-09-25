//
//  YBLGoodsEvaluateHeaderView.h
//  YBL365
//
//  Created by 乔同新 on 12/24/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLGoodsEvaluateHeaderView : UITableViewHeaderFooterView

@property (nonatomic, retain) UILabel *countEvaluateLabel;

@property (nonatomic, strong) YBLButton *goodEvaluateButton;

- (void)updateEVcount:(NSInteger)evCount evPercent:(float)evpercent;

+ (CGFloat)getGoodsEvaluateHeaderViewHeight;

@end

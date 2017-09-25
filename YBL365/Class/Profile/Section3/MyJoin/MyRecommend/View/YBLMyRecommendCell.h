//
//  YBLMyRecommendCell.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/7.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLMyRecommendCell : UITableViewCell

@property (nonatomic, strong) UIButton *lookSameButton;

@property (nonatomic, strong) UIButton *tradeNotificationButton;

+ (CGFloat)getMyRecommendCellHeight;

@end

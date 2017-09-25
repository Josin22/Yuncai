//
//  YBLOrderDetailContactFooterView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/16.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBLOrderDetailContactFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) YBLButton *moreButton;

@property (nonatomic, strong) YBLButton *contactButton;

@property (nonatomic, assign) BOOL isHaveTwoCount;

+ (CGFloat)getHi:(BOOL)isHasMore;

@end

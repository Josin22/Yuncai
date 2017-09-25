//
//  YBLFilterBottomView.h
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^FilterDismissBlock)();

@interface YBLFilterBottomView : UIView

@property (nonatomic, copy)FilterDismissBlock filterDismissBlock;

@property (nonatomic, strong) UIButton *dimissButton;
@property (nonatomic, strong) UIButton *submitBUtton;

- (void)showWithFilterArray:(NSArray *)filterArray animation:(BOOL)animation;

- (void)dismiss;

@end

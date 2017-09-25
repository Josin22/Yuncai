//
//  YBLAreaItemButton.h
//  YC168
//
//  Created by 乔同新 on 2017/3/23.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AreaItemButtonType) {
    AreaItemButtonTypeNormal = 0,
    AreaItemButtonTypeSpacial
};

@interface YBLAreaItemButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame areaItemButtonType:(AreaItemButtonType)areaItemButtonType;

@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, strong) UIButton *arrowButton;

@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, strong) UIColor *selectColor;

- (void)resetFrame;

@end

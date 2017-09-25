//
//  TextImageButton.h
//  YBL365
//
//  Created by 乔同新 on 2017/3/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,Type) {
    TypeText = 0,
    TypeImage
};

@interface TextImageButton : UIButton

@property (nonatomic, retain) UILabel *topLabel;

@property (nonatomic, retain) UILabel *bottomLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIColor *normalColor;

- (instancetype)initWithFrame:(CGRect)frame Type:(Type)type;

@end

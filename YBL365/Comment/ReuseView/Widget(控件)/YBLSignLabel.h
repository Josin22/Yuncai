//
//  YBLSiginView.h
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SiginDirection) {
    SiginDirectionLeft = 0,  //箭头朝左
    SiginDirectionTop     //箭头朝上
    
};

@interface YBLSignLabel : UIView

- (instancetype)initWithFrame:(CGRect)frame SiginDirection:(SiginDirection)direction;

@property (nonatomic, assign) BOOL isFillAll;

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, copy  ) NSString *signText;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *textColor;

@end

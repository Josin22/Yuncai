//
//  YBLTimeDown.h
//  YBL365
//
//  Created by 乔同新 on 12/20/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TimeDownType) {
    
    TimeDownTypeText = 0,
    TimeDownTypeNumber
};

typedef void(^TimeOverBlock)(void);

@interface YBLTimeDown : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     WithType:(TimeDownType)type;

- (void)setBackgroundColor:(UIColor *)backgroundColor
                 TextColor:(UIColor *)color
                    radiuo:(CGFloat)rad;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic,retain) UILabel *textTimerLabel;

@property (nonatomic, copy) TimeOverBlock timeOverBlock;

- (void)setEndTime:(NSString *)endTime begainText:(NSString *)text;

- (void)setEndTime:(NSString *)endTime NowTime:(NSString *)NowTime begainText:(NSString *)text;

- (void)destroyTimer;

@end

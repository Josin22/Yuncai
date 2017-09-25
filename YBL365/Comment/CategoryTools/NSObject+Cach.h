//
//  NSObject+Cach.h
//  YC168
//
//  Created by 乔同新 on 2017/6/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Cach)

@property (nonatomic, strong) NSMutableAttributedString *att_price;

@property (nonatomic, strong) NSMutableAttributedString *att_text;

@property (nonatomic, strong) UIFont *text_font;

@property (nonatomic, assign) CGFloat text_max_width;

@property (nonatomic, assign) CGFloat text_height;

@property (nonatomic, assign) CGFloat cell_height;

- (void)calulateTextSize:(NSString *)text;

- (void)calulateTextSize:(NSString *)text textFont:(UIFont *)textFont textMaxWidth:(CGFloat)textMaxWidth;

@end

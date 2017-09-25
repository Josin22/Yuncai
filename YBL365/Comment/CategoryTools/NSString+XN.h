//
//  NSString+XN.h
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/6.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XN)



- (CGSize)heightWithFont:(UIFont *)font
                MaxWidth:(float)width;
/**
 *  Get the string's height with the fixed width.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *  @param width     Fixed width.
 *
 *  @return String's height.
 */
- (CGFloat)heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute fixedWidth:(CGFloat)width;

/**
 *  Get the string's width.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *
 *  @return String's width.
 */
- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

/**
 *  Get a line of text height.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *
 *  @return String's width.
 */
+ (CGFloat)aLineOfTextHeightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

+ (NSMutableAttributedString *)stringPrice:(NSString *)price color:(UIColor *)color font:(float)font  isBoldFont:(BOOL)isBlod appendingString:(NSString *)appending;

+ (NSMutableAttributedString *)price:(NSString *)priceString color:(UIColor *)textColor font:(CGFloat)textFont;

+ (NSMutableAttributedString *)stringStrikethrough:(NSString *)string color:(UIColor *)color font:(float)font;

+ (NSMutableAttributedString *)redPriceString:(NSString *)priceString color:(UIColor *)textColor font:(CGFloat)textFont;

@end

//
//  NSString+XN.m
//  51XiaoNiu
//
//  Created by 乔同新 on 16/4/6.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "NSString+XN.h"

@implementation NSString (XN)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method systemStringAppending = class_getInstanceMethod([self class], @selector(stringByAppendingString:));
        Method newStringAppending = class_getInstanceMethod([self class], @selector(new_stringByAppendingString:));
        method_exchangeImplementations(systemStringAppending, newStringAppending);        
    });
    
}

- (NSString *)new_stringByAppendingString:(NSString *)appendingString{
 
    if (appendingString.length==0) {
        return nil;
    }else {
        return [self new_stringByAppendingString:appendingString];
    }
}

- (CGSize)heightWithFont:(UIFont *)font
                MaxWidth:(float)width{
    if (self.length==0) {
        return CGSizeMake(0, 0);
    }
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine |
                                             NSStringDrawingUsesLineFragmentOrigin|
                                             NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    
    return CGSizeMake((rect.size.width), (rect.size.height));
    
}
- (CGFloat)heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute fixedWidth:(CGFloat)width {
    
    NSParameterAssert(attribute);
    
    CGFloat height = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        height = rect.size.height;
    }
    
    return height;
}

- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    
    NSParameterAssert(attribute);
    
    CGFloat width = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        width = rect.size.width;
    }
    
    return width;
}

+ (CGFloat)aLineOfTextHeightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    
    CGFloat height = 0;
    CGRect rect    = [@"One" boundingRectWithSize:CGSizeMake(200, MAXFLOAT)
                                          options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil];
    
    height = rect.size.height;
    return height;
}

+ (NSMutableAttributedString *)stringPrice:(NSString *)price color:(UIColor *)color font:(float)font  isBoldFont:(BOOL)isBlod appendingString:(NSString *)appending{
    
    BOOL isHaveRBM = [price hasPrefix:@"¥ "];
    NSAssert(isHaveRBM == YES, @"价格必须是以¥加空格开头");
    
    NSUInteger otherLen = appending.length;
    if (otherLen>0) {
        price = [price stringByAppendingString:appending];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:price];
    
    [str addAttribute:NSFontAttributeName
                value:isBlod == YES?YBLBFont(font-4):YBLFont(font-4)
                range:NSMakeRange(0, 2)];
    NSInteger dian = [price rangeOfString:@"."].location;
    
    [str addAttributes:@{NSFontAttributeName:isBlod == YES?YBLBFont(font):YBLFont(font),}
                 range:NSMakeRange(2, dian-2)];
    [str addAttributes:@{NSFontAttributeName:isBlod == YES?YBLBFont(font-4):YBLFont(font-4),} range:NSMakeRange(dian, price.length - dian)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, price.length-otherLen)];

    if (otherLen>0) {
        [str addAttributes:@{NSFontAttributeName:YBLFont(font-4),}
                     range:NSMakeRange(price.length-otherLen, otherLen)];
    }
//    [str addAttribute:NSTextAlignment value:NSTextAlignmentCenter range:NSMakeRange(0, price.length)];
    
    return str;
}

+ (NSMutableAttributedString *)price:(NSString *)priceString color:(UIColor *)textColor font:(CGFloat)textFont{
    
    NSString *other = @"¥ ";
    priceString = [other stringByAppendingString:priceString];
    
    BOOL isHaveRBM = [priceString hasPrefix:@"."];
    NSAssert(isHaveRBM == NO, @"价格需保留2位小数");
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceString];
    
    NSInteger kong = [priceString rangeOfString:@" "].location;
    
    NSInteger dian = [priceString rangeOfString:@"."].location;
    
    [str addAttributes:@{NSFontAttributeName:YBLFont(textFont-5),NSForegroundColorAttributeName:textColor} range:NSMakeRange(0, kong)];
    
    [str addAttributes:@{NSFontAttributeName:YBLFont(textFont),NSForegroundColorAttributeName:textColor} range:NSMakeRange(kong, priceString.length-kong)];
    
    [str addAttributes:@{NSFontAttributeName:YBLFont(textFont-4),NSForegroundColorAttributeName:textColor} range:NSMakeRange(dian, priceString.length-dian)];

    
    return str;
}

+ (NSMutableAttributedString *)stringStrikethrough:(NSString *)string color:(UIColor *)color font:(float)font{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSInteger length = str.length;
    
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, length)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
    [str addAttributes:@{NSFontAttributeName:YBLFont(font),}
                 range:NSMakeRange(0, length)];
    
    return str;
}

+ (NSMutableAttributedString *)redPriceString:(NSString *)priceString color:(UIColor *)textColor font:(CGFloat)textFont{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceString];
    
    NSInteger kong = [priceString rangeOfString:@" "].location;
    
    [str addAttributes:@{NSFontAttributeName:YBLFont(textFont),NSForegroundColorAttributeName:BlackTextColor} range:NSMakeRange(0, kong)];
    
    [str addAttributes:@{NSFontAttributeName:YBLFont(textFont),NSForegroundColorAttributeName:textColor} range:NSMakeRange(kong, priceString.length-kong)];
    
    return str;
}

@end

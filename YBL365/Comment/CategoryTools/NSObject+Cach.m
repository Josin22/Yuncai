//
//  NSObject+Cach.m
//  YC168
//
//  Created by 乔同新 on 2017/6/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "NSObject+Cach.h"

static const char * att_price_key = "att_price_key";

static const char * att_text_key = "att_text_key";

static const char * text_font_key = "text_font_key";

static const char * text_height_key = "text_height_key";

static const char * text_max_width_key = "text_max_width_key";

static const char * cell_height_key = "cell_height_key";

@implementation NSObject (Cach)

- (void)setText_max_width:(CGFloat)text_max_width{
    objc_setAssociatedObject(self, &text_max_width_key, @(text_max_width), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)text_max_width{
    return [objc_getAssociatedObject(self, &text_max_width_key) floatValue];
}

- (void)setText_font:(UIFont *)text_font{
    objc_setAssociatedObject(self, &text_font_key, text_font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)text_font{
    return objc_getAssociatedObject(self, &text_font_key);
}

- (void)setAtt_text:(NSMutableAttributedString *)att_text{
    objc_setAssociatedObject(self, &att_text_key, att_text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableAttributedString *)att_text{
    return objc_getAssociatedObject(self, &att_text_key);
}

- (void)setAtt_price:(NSMutableAttributedString *)att_price{
    objc_setAssociatedObject(self, &att_price_key, att_price, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableAttributedString *)att_price{
    return objc_getAssociatedObject(self, &att_price_key);
}

- (void)setText_height:(CGFloat)text_height{
    objc_setAssociatedObject(self, &text_height_key, @(text_height), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)text_height{
    return [objc_getAssociatedObject(self, &text_height_key) floatValue];
}

- (void)setCell_height:(CGFloat)cell_height{
    objc_setAssociatedObject(self, &cell_height_key, @(cell_height), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)cell_height{
    return [objc_getAssociatedObject(self, &cell_height_key) floatValue];
}

- (void)calulateTextSize:(NSString *)text{
    [self calulateTextSize:text textFont:self.text_font textMaxWidth:self.text_max_width];
}

- (void)calulateTextSize:(NSString *)text textFont:(UIFont *)textFont textMaxWidth:(CGFloat)textMaxWidth{
    if (textFont) {
        self.text_font = textFont;
    }
    if (textMaxWidth==0) {
        self.text_max_width = textMaxWidth;
    }
    CGSize textSize = [text heightWithFont:textFont MaxWidth:textMaxWidth];
    self.text_height = textSize.height;
}

-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
}

@end

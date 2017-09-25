//
//  UILabel+FlickerNumber.m
//  FlickerNumber
//
//  Created by DeJohn Dong on 15-2-1.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "UILabel+FlickerNumber.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#define DDRangeIntegerKey @"RangeKey"
#define DDMultipleKey @"MultipleKey"
#define DDBeginNumberKey @"BeginNumberKey"
#define DDEndNumberKey @"EndNumberKey"
#define DDResultNumberKey @"ResultNumberKey"

#define DDAttributeKey @"AttributeKey"
#define DDFormatKey @"FormatStringKey"

#define DDFrequency 1.0/30.0f

#define DDDictArrtributeKey @"attribute"
#define DDDictRangeKey @"range"

@interface UILabel ()

@property (nonatomic, strong, readwrite) NSNumber *flickerNumber;
@property (nonatomic, strong, readwrite, nullable) NSNumberFormatter *flickerNumberFormatter;
@property (nonatomic, strong, readwrite, nullable) NSTimer *currentTimer;

@end

@implementation UILabel (FlickerNumber)

- (NSString *)verticalText{
    // 利用runtime添加属性
    return objc_getAssociatedObject(self, @selector(verticalText));
}

- (void)setVerticalText:(NSString *)verticalText{
    objc_setAssociatedObject(self, &verticalText, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
}

#pragma mark - runtime methods

- (void)setFlickerNumber:(NSNumber *)flickerNumber {
    objc_setAssociatedObject(self, @selector(flickerNumber), flickerNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)flickerNumber {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFlickerNumberFormatter:(nullable NSNumberFormatter *)flickerNumberFormatter {
    objc_setAssociatedObject(self, @selector(flickerNumberFormatter), flickerNumberFormatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSNumberFormatter *)flickerNumberFormatter {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentTimer:(nullable NSTimer *)currentTimer {
    objc_setAssociatedObject(self, @selector(currentTimer), currentTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSTimer *)currentTimer {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - flicker methods(public)

//Method #1
- (void)fn_setNumber:(NSNumber *)number {
    [self fn_setNumber:number format:nil];
}

//Method #2
- (void)fn_setNumber:(NSNumber *)number formatter:(nullable NSNumberFormatter *)formatter {
    [self fn_setNumber:number formatter:formatter attributes:nil];
}

//Method #3
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration {
    [self fn_setNumber:number duration:duration format:nil attributes:nil];
}

//Method #4
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(nullable NSNumberFormatter *)formatter{
    [self fn_setNumber:number duration:duration formatter:formatter attributes:nil];
}

//Method #5
- (void)fn_setNumber:(NSNumber *)number format:(nullable NSString *)formatStr {
    [self fn_setNumber:number format:formatStr attributes:nil];
}

//Method #6
- (void)fn_setNumber:(NSNumber *)number format:(nullable NSString *)formatStr formatter:(nullable NSNumberFormatter *)formatter {
    [self fn_setNumber:number format:formatStr formatter:formatter attributes:nil];
}

//Method #7
- (void)fn_setNumber:(NSNumber *)number attributes:(nullable id)attrs {
    [self fn_setNumber:number format:nil attributes:attrs];
}

//Method #8
- (void)fn_setNumber:(NSNumber *)number formatter:(nullable NSNumberFormatter *)formatter attributes:(nullable id)attrs {
    [self fn_setNumber:number duration:1.0 format:nil numberFormatter:formatter attributes:attrs];
}

//Method #9
- (void)fn_setNumber:(NSNumber *)number format:(nullable NSString *)formatStr attributes:(nullable id)attrs {
    [self fn_setNumber:number duration:1.0 format:formatStr attributes:attrs];
}

//Method #10
- (void)fn_setNumber:(NSNumber *)number format:(nullable NSString *)formatStr formatter:(nullable NSNumberFormatter *)formatter attributes:(nullable id)attrs {
    if(!formatter) {
        formatter = [self defaultFormatter];
    }
    [self fn_setNumber:number duration:1.5 format:formatStr numberFormatter:formatter attributes:attrs];
}

//Method #11
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(nullable NSString *)formatStr {
    [self fn_setNumber:number duration:duration format:formatStr attributes:nil];
}

//Method #12
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(nullable NSString *)formatStr formatter:(nullable NSNumberFormatter *)formatter {
    if(!formatter)
        formatter = [self defaultFormatter];
    [self fn_setNumber:number duration:duration format:formatStr formatter:formatter];
}

//Method #13
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration attributes:(nullable id)attrs {
    [self fn_setNumber:number duration:duration format:nil attributes:attrs];
}

//Method #14
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(nullable NSNumberFormatter *)formatter attributes:(nullable id)attrs {
    if(!formatter)
        formatter = [self defaultFormatter];
    [self fn_setNumber:number duration:duration format:nil numberFormatter:formatter attributes:attrs];
}

//Method #15
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(nullable NSString *)formatStr attributes:(nullable id)attrs {
    [self fn_setNumber:number duration:duration format:formatStr numberFormatter:nil attributes:attrs];
}

//Method #16
- (void)fn_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(nullable NSString *)formatStr numberFormatter:(nullable NSNumberFormatter *)formatter attributes:(nullable id)attrs {
    /**
     *  check the number type
     */
    NSAssert([number isKindOfClass:[NSNumber class]], @"Number Type is not matched , exit");
    if(![number isKindOfClass:[NSNumber class]]) {
        self.text = [NSString stringWithFormat:@"%@",number];
        return;
    }
    
    /* limit duration is postive number and it is large than 0.3 , fixed the issue#1--https://github.com/openboy2012/FlickerNumber/issues/1 */
    duration = fabs(duration) < 0.3 ? 0.3 : fabs(duration);
    
    [self.currentTimer invalidate];
    self.currentTimer = nil;
    
    //initialize useinfo dict
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if(formatStr)
        [userInfo setObject:formatStr forKey:DDFormatKey];
    
    [userInfo setObject:number forKey:DDResultNumberKey];
    
    //initialize variables
    long long beginNumber = 0;
    [userInfo setObject:@(beginNumber) forKey:DDBeginNumberKey];
    self.flickerNumber = @0;
    unsigned long long endNumber = [number unsignedLongLongValue];
    
    //get multiple if number is double type
    int multiple = [self getTheMultipleFromNumber:number formatString:formatStr];
    if (multiple > 0)
        endNumber = [number doubleValue] * multiple;
    
    //check the number if out of bounds the unsigned int length
    if (endNumber >= INT64_MAX) {
        self.text = [NSString stringWithFormat:@"%@",number];
        return;
    }
    
    [userInfo setObject:@(multiple) forKey:DDMultipleKey];
    [userInfo setObject:@(endNumber) forKey:DDEndNumberKey];
    if ((endNumber * DDFrequency)/duration < 1) {
        duration = duration * 0.3;
    }
    [userInfo setObject:@((endNumber * DDFrequency)/duration) forKey:DDRangeIntegerKey];
    
    if(attrs)
        [userInfo setObject:attrs forKey:DDAttributeKey];
    
    self.flickerNumberFormatter = nil;
    if(formatter)
        self.flickerNumberFormatter = formatter;
    
    self.currentTimer = [NSTimer scheduledTimerWithTimeInterval:DDFrequency target:self selector:@selector(flickerAnimation:) userInfo:userInfo repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.currentTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - private methods
/**
 *  Flicker number animation implemetation method.
 *
 *  @param timer  The schedule timer, the time interval decide the number flicker counts.
 */
- (void)flickerAnimation:(NSTimer *)timer {
    /**
     *  check the rangeNumber if more than 1.0, fixed the issue#2--https://github.com/openboy2012/FlickerNumber/issues/2
     */
    if ([timer.userInfo[DDRangeIntegerKey] floatValue] >= 1.0) {
        long long rangeInteger = [timer.userInfo[DDRangeIntegerKey] longLongValue];
        self.flickerNumber = @([self.flickerNumber longLongValue] + rangeInteger);
    } else {
        float rangeInteger = [timer.userInfo[DDRangeIntegerKey] floatValue];
        self.flickerNumber = @([self.flickerNumber floatValue] + rangeInteger);
    }
    
    
    int multiple = [timer.userInfo[DDMultipleKey] intValue];
    if (multiple > 0) {
        [self floatNumberAnimation:timer multiple:multiple];
    } else {
        NSString *formatStr = timer.userInfo[DDFormatKey]?:(self.flickerNumberFormatter?@"%@":@"%.0f");
        self.text = [self finalString:@([self.flickerNumber longLongValue]) stringFormat:formatStr numberFormatter:self.flickerNumberFormatter];
        
        if (timer.userInfo[DDAttributeKey]) {
            [self addTextAttributes:timer.userInfo[DDAttributeKey]];
        }
        
        if ([self.flickerNumber longLongValue] >= [timer.userInfo[DDEndNumberKey] longLongValue]) {
            self.text = [self finalString:timer.userInfo[DDResultNumberKey] stringFormat:formatStr numberFormatter:self.flickerNumberFormatter];
            if (timer.userInfo[DDAttributeKey]) {
                [self addTextAttributes:timer.userInfo[DDAttributeKey]];
            }
            [timer invalidate];
        }
    }
}

/**
 *  Float number handle method.
 *
 *  @param timer    timer
 *  @param multiple The number's multiple.
 */
- (void)floatNumberAnimation:(NSTimer *)timer multiple:(int)multiple {
    NSString *formatStr = timer.userInfo[DDFormatKey] ?: (self.flickerNumberFormatter ? @"%@" : [NSString stringWithFormat:@"%%.%df",(int)log10(multiple)]);
    self.text = [self finalString:@([self.flickerNumber doubleValue]/multiple) stringFormat:formatStr numberFormatter:self.flickerNumberFormatter];
    if (timer.userInfo[DDAttributeKey]) {
        [self addTextAttributes:timer.userInfo[DDAttributeKey]];
    }
    if ([self.flickerNumber longLongValue] >= [timer.userInfo[DDEndNumberKey] longLongValue]) {
        self.text = [self finalString:timer.userInfo[DDResultNumberKey] stringFormat:formatStr numberFormatter:self.flickerNumberFormatter];
        if (timer.userInfo[DDAttributeKey]) {
            [self addTextAttributes:timer.userInfo[DDAttributeKey]];
        }
        [timer invalidate];
    }
}

/**
 *  The attributed(s) text handle methods
 *
 *  @param attributes The attributed property, it's a attributed dictionary OR array of attributed dictionaries.
 */
- (void)addTextAttributes:(id)attributes {
    if ([attributes isKindOfClass:[NSDictionary class]]) {
        NSRange range = [attributes[DDDictRangeKey] rangeValue];
        [self addAttribute:attributes[DDDictArrtributeKey] range:range];
    } else if([attributes isKindOfClass:[NSArray class]]) {
        for (NSDictionary *attribute in attributes) {
            NSRange range = [attribute[DDDictRangeKey] rangeValue];
            [self addAttribute:attribute[DDDictArrtributeKey] range:range];
        }
    }
}

/**
 *  Add attributed property into the number text OR string-format text.
 *
 *  @param attri The attributed of the text
 *  @param range The range of the attributed property
 */
- (void)addAttribute:(NSDictionary *)attri
               range:(NSRange)range {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    // handler the out range exception
    if(range.location + range.length <= str.length){
        [str addAttributes:attri range:range];
    }
    self.attributedText = str;
}

/**
 *  Get muliple from number
 *
 *  @param number past number
 *
 *  @return mulitple
 */
- (int)getTheMultipleFromNumber:(NSNumber *)number
                   formatString:(NSString *)formatStr {
    if([formatStr rangeOfString:@"%@"].location == NSNotFound) {
        if([formatStr rangeOfString:@"%d"].location != NSNotFound) {
            return 0;
        }
        formatStr = [self regexNumberFormat:formatStr];
        NSString *formatNumberString = [NSString stringWithFormat:formatStr,[number floatValue]];
        if ([formatNumberString rangeOfString:@"."].location != NSNotFound) {
            NSUInteger length = [[formatNumberString substringFromIndex:[formatNumberString rangeOfString:@"."].location + 1] length];
            float padding = log10f(length < 6 ? length:6);
            number = @([formatNumberString floatValue] + padding);
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",number];
    if([str rangeOfString:@"."].location != NSNotFound) {
        NSUInteger length = [[str substringFromIndex:[str rangeOfString:@"."].location +1] length];
        // Max Multiple is 6
        return  length >= 6 ? pow(10, 6): pow(10, (int)length);
    }
    return 0;
}

/**
 *  Get the number string from number-formatter style.
 *
 *  @param number    The result number.
 *  @param formattor The number-formatter style.
 *
 *  @return The number string.
 */
- (NSString *)stringFromNumber:(NSNumber *)number
               numberFormatter:(NSNumberFormatter *)formattor {
    if(!formattor) {
        formattor = [[NSNumberFormatter alloc] init];
        formattor.formatterBehavior = NSNumberFormatterBehavior10_4;
        formattor.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return [formattor stringFromNumber:number];
}

/**
 *  The final-string of each frame of flicker animation.
 *
 *  @param number    The result number.
 *  @param formatStr The string-format String.
 *  @param formatter The number-formatter style.
 *
 *  @return The final string.
 */
- (NSString *)finalString:(NSNumber *)number
             stringFormat:(NSString *)formatStr
          numberFormatter:(NSNumberFormatter *)formatter {
    NSString *finalString = nil;
    if (formatter) {
        NSAssert([formatStr rangeOfString:@"%@"].location != NSNotFound, @"The string format type is not matched. Please check your format type if it's not `%%@`. ");
        finalString = [NSString stringWithFormat:formatStr,[self stringFromNumber:number numberFormatter:formatter]];
    } else {
        NSAssert([formatStr rangeOfString:@"%@"].location == NSNotFound, @"The string format type is not matched. Please check your format type if it's `%%@`. ");
        // fixed the bug if use the `%d` format string.
        if ([formatStr rangeOfString:@"%d"].location == NSNotFound)
        {
            finalString = [NSString stringWithFormat:formatStr,[number doubleValue]];
        }
        else
        {
            finalString = [NSString stringWithFormat:formatStr,[number longLongValue]];
        }
    }
    return finalString;
}

/**
 *  Get the decimal style number as default number-formatter style.
 *
 *  @return The number-foramtter style.
 */
- (NSNumberFormatter *)defaultFormatter {
    NSNumberFormatter *formattor = [[NSNumberFormatter alloc] init];
    formattor.formatterBehavior = NSNumberFormatterBehavior10_4;
    formattor.numberStyle = NSNumberFormatterDecimalStyle;
    return formattor;
}

/**
 *  Get the format string use regex feature. This methods to handle the number is an integer number but it should string format as a float number, like this `self.text = [NSString stringFormat:@"%f",1234]`, it's show `1234.000000`.
 *
 *  @param formatString The origin string
 *
 *  @return The string-format String.
 */
- (NSString *)regexNumberFormat:(NSString *)formatString {
    NSError *regexError = nil;
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"^%((\\d+.\\d+)|(\\d+).|(.\\d+))f$"
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&regexError];
    if (!regexError) {
        NSTextCheckingResult *match = [regex firstMatchInString:formatString
                                                        options:0
                                                          range:NSMakeRange(0, [formatString length])];
        if (match) {
            NSString *result = [formatString substringWithRange:match.range];
            return result;
        }
    } else {
        NSLog(@"error - %@", regexError);
    }
    return @"%f";
}

@end

@implementation UILabel (FlickerNumberDeprecated)

- (void)dd_setNumber:(NSNumber *)number {
    [self fn_setNumber:number format:nil];
}

- (void)dd_setNumber:(NSNumber *)number formatter:(NSNumberFormatter *)formatter {
    [self fn_setNumber:number format:nil formatter:formatter];
}

- (void)dd_setNumber:(NSNumber *)number format:(NSString *)formatStr {
    [self fn_setNumber:number format:formatStr];
}

- (void)dd_setNumber:(NSNumber *)number format:(NSString *)formatStr formatter:(NSNumberFormatter *)formatter {
    [self fn_setNumber:number format:formatStr formatter:formatter];
}

- (void)dd_setNumber:(NSNumber *)number attributes:(id)attrs {
    [self fn_setNumber:number attributes:attrs];
}

- (void)dd_setNumber:(NSNumber *)number formatter:(NSNumberFormatter *)formatter attributes:(id)attrs {
    [self fn_setNumber:number formatter:formatter attributes:attrs];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr {
    [self fn_setNumber:number duration:duration format:formatStr];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr numberFormatter:(NSNumberFormatter *)formatter {
    [self fn_setNumber:number duration:duration format:formatStr formatter:formatter];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration {
    [self fn_setNumber:number duration:duration];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter {
    [self fn_setNumber:number duration:duration formatter:formatter];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration attributes:(id)attrs {
    [self fn_setNumber:number duration:duration attributes:attrs];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr formatter:(NSNumberFormatter *)formatter {
    [self fn_setNumber:number duration:duration format:formatStr formatter:formatter];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter attributes:(id)attrs {
    [self fn_setNumber:number duration:duration formatter:formatter attributes:attrs];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr attributes:(id)attrs {
    [self fn_setNumber:number duration:duration format:formatStr attributes:attrs];
}

- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr numberFormatter:(NSNumberFormatter *)formatter attributes:(id)attrs {
    [self fn_setNumber:number duration:duration format:formatStr numberFormatter:formatter attributes:attrs];
}

@end

@implementation NSDictionary (FlickerNumber)

+ (instancetype)fn_dictionaryWithAttribute:(NSDictionary *)attribute range:(NSRange)range {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:attribute forKey:DDDictArrtributeKey];
    [dict setObject:[NSValue valueWithRange:range] forKey:DDDictRangeKey];
    return dict;
}

@end

@implementation NSDictionary (FlickerNumberDeprecated)

+ (instancetype)dictionaryWithAttribute:(NSDictionary *)attribute range:(NSRange)range {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:attribute forKey:DDDictArrtributeKey];
    [dict setObject:[NSValue valueWithRange:range] forKey:DDDictRangeKey];
    return dict;
}

@end

NS_ASSUME_NONNULL_END


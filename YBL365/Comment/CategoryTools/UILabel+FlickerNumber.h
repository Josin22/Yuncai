//
//  UILabel+FlickerNumber.h
//  FlickerNumber
//
//  Created by DeJohn Dong on 15-2-1.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (FlickerNumber)

@property (nonatomic) NSString *verticalText;

/**
 *  Flicker a number without other effects.
 *
 *  @param number    The number for flicker animation, can't be `nil`.
 */
- (void)fn_setNumber:(NSNumber *)number;

/**
 *  Flicker a number with number-formatter style. You can use the `NSNumberFormatterCurrencyStyle` number-formatter style, the number will flicker animation as `$1,023.12`.
 *
 *  @param number    The number for flicker animation.
 *  @param formatter The number-formatter style. If this parameter is `nil`, the method should use the default number-formatter style -- `NSNumberFormatterDecimalStyle`, so `1000000` will be '1,000,000'.
 */
- (void)fn_setNumber:(NSNumber *)number
           formatter:(nullable NSNumberFormatter *)formatter;

/**
 *  Flicker a number in during time.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time, can't be a minus.
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration;

/**
 *  Flicker a number in during time with number-formatter style.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time.
 *  @param formatter The number-formatter style.
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
           formatter:(nullable NSNumberFormatter *)formatter;

/**
 *  Flicker a number with string-format style. like this: `Today's income: $200.00`.
 *
 *  @param number    The number for flicker animation.
 *  @param formatStr The string-format String. If you set this parameter is `nil`, the method is same to `fn_setNumber:`.
 */
- (void)fn_setNumber:(NSNumber *)number
              format:(nullable NSString *)formatStr;

/**
 *  Flicker a number with string-format String & number-formatter style.
 *
 *  @param number    The number for flicker animation.
 *  @param formatStr The string-format String.
 *  @param formatter The number-formatter style.
 */
- (void)fn_setNumber:(NSNumber *)number
              format:(nullable NSString *)formatStr
           formatter:(nullable NSNumberFormatter *)formatter;


/**
 *  Flicker a number with attributed(s) property.
 *
 *  @param number The number for flicker animation.
 *  @param attrs  The attributed number set(a dictionary OR array of dictionaries), character attributes for text. Only can attributed the number because there are no string-format String. Use this parameter the number text can be colorful and wonderful. If you set this parameter is `nil`, the same to method `fn_setNumber:`.
 */
- (void)fn_setNumber:(NSNumber *)number
          attributes:(nullable id)attrs;

/**
 *  Flicker a number with number-formatter style & attributed(s) property.
 *
 *  @param number    The number for flicker animation.
 *  @param formatter The number-formatter style.
 *  @param attrs     The attributed number set(a dictionary OR array of dictionaries).
 */
- (void)fn_setNumber:(NSNumber *)number
           formatter:(nullable NSNumberFormatter *)formatter
          attributes:(nullable id)attrs;

/**
 *  Flicker a number with string-format String & attributed(s) property.
 *
 *  @param number    The number for flicker animation.
 *  @param formatStr The string-format String.
 *  @param attrs     The attributed string set(a dictionary OR array of dictionaries). You can attributed(s) the number or string-format String.
 */
- (void)fn_setNumber:(NSNumber *)number
              format:(nullable NSString *)formatStr
          attributes:(nullable id)attrs;

/**
 *  Flicker a number in dafault during time(1.0s) with all effects.
 *
 *  @param number    The number for flicker animation.
 *  @param formatStr The string-format String.
 *  @param formatter The number-formatter style.
 *  @param attrs     The attributed string set(a dictionary OR array of dictionaries).You can attributed(s) the number or string-format String.
 */
- (void)fn_setNumber:(NSNumber *)number
              format:(nullable NSString *)formatStr
           formatter:(nullable NSNumberFormatter *)formatter
          attributes:(nullable id)attrs;

/**
 *  Flicker a number in during time with string-format String.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time.
 *  @param formatStr The string-format String.
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
              format:(nullable NSString *)formatStr;

/**
 *  Flicker a number in during time with string-format String & number-formatter style.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time.
 *  @param formatStr The string-format String.
 *  @param formatter The number-formatter style.
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
              format:(nullable NSString *)formatStr
           formatter:(nullable NSNumberFormatter *)formatter;

/**
 *  Flicker a number in during time with attributed(s) property.
 *
 *  @param number   The number for flicker animation.
 *  @param duration The flicker animation during time.
 *  @param attrs    The attributed number set(a dictionary OR array of dictionaries).
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
          attributes:(nullable id)attrs;

/**
 *  Flicker a number in during time with attributed(s) property of number & number-formatter style.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time.
 *  @param formatter The number-formatter style.
 *  @param attrs     The attributed number set(a dictionary OR array of dictionaries).
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
           formatter:(nullable NSNumberFormatter *)formatter
          attributes:(nullable id)attrs;

/**
 *  Flicker a number in during time with effects except number-formatter style.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time.
 *  @param formatStr The string-format String.
 *  @param attrs     The attributed string set(a dictionary OR array of dictionaries). You can set string-format String OR number attributes both.
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
              format:(nullable NSString *)formatStr
          attributes:(nullable id)attrs;

/**
 *  Flicker a number in during time with all the effects. You can attributed(s) the number or string-format String. You also can set the number number-fomatter style.
 *
 *  @param number    The number for flicker animation.
 *  @param duration  The flicker animation during time.
 *  @param formatStr The string-format String.
 *  @param formatter The number-formatter style.
 *  @param attrs     The attributed string set(a dictionary OR array of dictionaries).
 */
- (void)fn_setNumber:(NSNumber *)number
            duration:(NSTimeInterval)duration
              format:(nullable NSString *)formatStr
     numberFormatter:(nullable NSNumberFormatter *)formatter
          attributes:(nullable id)attrs;

@end

@interface UILabel (FlickerNumberDeprecated)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

- (void)dd_setNumber:(NSNumber *)number __deprecated_msg("Use `fn_setNumber:`");
- (void)dd_setNumber:(NSNumber *)number formatter:(NSNumberFormatter *)formatter __deprecated_msg("Use `fn_setNumber:formatter:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration __deprecated_msg("Use `fn_setNumber:duration:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter __deprecated_msg("Use `fn_setNumber:duration:formatter:");
- (void)dd_setNumber:(NSNumber *)number format:(NSString *)formatStr __deprecated_msg("Use `fn_setNumber:format:`");
- (void)dd_setNumber:(NSNumber *)number format:(NSString *)formatStr formatter:(NSNumberFormatter *)formatter __deprecated_msg("Use `fn_setNumber:format:formatter:`");
- (void)dd_setNumber:(NSNumber *)number attributes:(id)attrs __deprecated_msg("Use `fn_setNumber:attributes:`");
- (void)dd_setNumber:(NSNumber *)number formatter:(NSNumberFormatter *)formatter attributes:(id)attrs __deprecated_msg("Use `fn_setNumber:formatter:attributes:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr __deprecated_msg("Use `fn_setNumber:duration:format:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr formatter:(NSNumberFormatter *)formatter __deprecated_msg("Use `fn_setNumber:duration:format:formatter:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration attributes:(id)attrs __deprecated_msg("Use `fn_setNumber:duration:attributes:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration formatter:(NSNumberFormatter *)formatter attributes:(id)attrs __deprecated_msg("Use `fn_setNumber:duration:formatter:attributes:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr attributes:(id)attrs __deprecated_msg("Use `fn_setNumber:duration:format:attributes:`");
- (void)dd_setNumber:(NSNumber *)number duration:(NSTimeInterval)duration format:(NSString *)formatStr numberFormatter:(NSNumberFormatter *)formatter attributes:(id)attrs __deprecated_msg("Use `fn_setNumber:duration:format:formatter:attributes:`");

#pragma clang diagnostic pop

@end

@interface NSDictionary(FlickerNumber)

/**
 *  Create an attribute texts dictionary, like the NSAttributedString.
 *
 *  @param attribute  The attributed text of the dictionary.
 *  @param range      The range of the attributed text.
 *
 *  @return Dictionary of attributed text.
 */
+ (instancetype)fn_dictionaryWithAttribute:(NSDictionary *)attribute range:(NSRange)range;

@end

@interface NSDictionary (FlickerNumberDeprecated)

+ (instancetype)dictionaryWithAttribute:(NSDictionary *)attribute range:(NSRange)range __deprecated_msg("Use `fn_dictionaryWithAttribute:range:`");

@end

NS_ASSUME_NONNULL_END


//
//  YBLlimmitTextView.h
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^LimmitTextViewShowBeginTextBlock)(UITextView *textView);

typedef void(^LimmitTextViewTextChangeLengthBlock)(NSInteger changeLength);

typedef void(^LimmitTextViewTextDidBeginEditingBlock)(UITextView *textView);

typedef NS_ENUM(NSInteger, LimmitTextViewType) {
    LimmitTextViewTypeNoShowLengthLabel = 0,
    LimmitTextViewTypeShowLengthLabel
};

@interface YBLlimmitTextView : UITextView

- (instancetype)initWithFrame:(CGRect)frame type:(LimmitTextViewType)type;

@property (nonatomic, assign) NSInteger limmteTextLength;

@property (nonatomic, copy  ) LimmitTextViewShowBeginTextBlock limmitTextViewShowBeginTextBlock;

@property (nonatomic, copy  ) LimmitTextViewTextChangeLengthBlock limmitTextViewTextChangeLengthBlock;

@property (nonatomic, copy  ) LimmitTextViewTextDidBeginEditingBlock limmitTextViewTextDidBeginEditingBlock;

@end

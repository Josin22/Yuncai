//
//  YBLlimmitTextView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLlimmitTextView.h"

@interface YBLlimmitTextView ()<UITextViewDelegate>

@property (nonatomic, assign) LimmitTextViewType type;

@property (nonatomic, retain) UILabel *textCountLabel;

@end

@implementation YBLlimmitTextView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame type:LimmitTextViewTypeNoShowLengthLabel];
}

- (instancetype)initWithFrame:(CGRect)frame type:(LimmitTextViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        _type = type;
        
        if (_type == LimmitTextViewTypeShowLengthLabel) {
            _textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
            _textCountLabel.textAlignment = NSTextAlignmentRight;
            _textCountLabel.font = YBLFont(12);
            _textCountLabel.textColor = YBLThemeColor;
            _textCountLabel.right = self.width-space;
            _textCountLabel.bottom = self.height;
            _textCountLabel.text = @"0";
            [self addSubview:_textCountLabel];
        }
    }
    return self;
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    [self showTextLength:text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < self.limmteTextLength) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = self.limmteTextLength - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
//            self.lessLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)self.limmteTextLength];
            [self showTextLength:0];
            BLOCK_EXEC(self.limmitTextViewTextChangeLengthBlock,0);
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > self.limmteTextLength)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:self.limmteTextLength];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    [self showTextLength:existTextNum];
    BLOCK_EXEC(self.limmitTextViewTextChangeLengthBlock,existTextNum);
//    self.lessLabel.text = [NSString stringWithFormat:@"%ld/%ld",existTextNum,(long)self.limmteTextLength];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if (self.limmitTextViewShowBeginTextBlock) {
        return self.limmitTextViewShowBeginTextBlock(textView);
    }
    return YES;
}

- (void)showTextLength:(NSInteger)length{
    if (_type == LimmitTextViewTypeShowLengthLabel) {
        _textCountLabel.text = [NSString stringWithFormat:@"%@",@(length)];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

    BLOCK_EXEC(self.limmitTextViewTextDidBeginEditingBlock,textView);
}

@end

//
//  YBLPurchaseShowIPayShipMentView.m
//  YC168
//
//  Created by 乔同新 on 2017/5/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseShowIPayShipMentView.h"

@interface YBLPurchaseShowIPayShipMentView ()

@property (nonatomic, assign) ShowMentType showMentType;

@property (nonatomic, strong) NSMutableArray *textDataArray;

@property (nonatomic, strong) UIScrollView *textScrollView;

@end

@implementation YBLPurchaseShowIPayShipMentView

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                  showMentType:ShowMentTypeAspfit
                 textDataArray:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                 showMentType:(ShowMentType)showMentType
                textDataArray:(NSMutableArray *)textDataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _textDataArray = textDataArray;
        _showMentType = showMentType;
        
        [self createrUI];
    }
    return self;
}

- (void)updateTextDataArray:(NSMutableArray *)textDataArray{
    
    _textDataArray = textDataArray;
    
    for (UIView *subView in self.textScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSInteger index = 0;
    CGFloat imageWi = 15;
    
    for (NSString *title in _textDataArray) {
        
        CGSize textSize = [title heightWithFont:YBLFont(13) MaxWidth:self.textScrollView.width];
        
        CGRect new_frame = CGRectMake(space, space+(imageWi+space)*index, textSize.width+space+imageWi, imageWi);
        
        YBLButton *textButton = [YBLButton buttonWithType:UIButtonTypeCustom];
        textButton.frame = new_frame;
        [textButton setImage:[UIImage imageNamed:@"purchase_order_circle"] forState:UIControlStateNormal];
        [textButton setTitle:title forState:UIControlStateNormal];
        [textButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        textButton.titleLabel.font = YBLFont(12);
        textButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        textButton.imageRect = CGRectMake(0, 1.5, imageWi-3, imageWi-3);
        textButton.titleRect = CGRectMake(imageWi+space-3, 0, new_frame.size.width-imageWi+space, imageWi);
        [self.textScrollView addSubview:textButton];
        index++;
        if (index == _textDataArray.count) {
            self.textScrollView.contentSize = CGSizeMake(self.width, textButton.bottom+space);
            if (_showMentType == ShowMentTypeAspfit) {
                self.textScrollView.height = textButton.bottom+space;
            }
        }
    }
    
    if (_showMentType == ShowMentTypeNoAspfit&&self.textScrollView.contentSize.height>self.textScrollView.height) {
        [UIView animateWithDuration:.3
                              delay:1.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                          [self.textScrollView setContentOffset:CGPointMake(0, -(self.textScrollView.contentSize.height-self.textScrollView.height)) animated:YES];
                         }
                         completion:^(BOOL finished) {
                             [self.textScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                         }];
    }
}

- (void)createrUI{
    
    self.backgroundColor = YBLColor(247, 247, 247, 1);
    
    UIScrollView *textScrollView = [[UIScrollView alloc] initWithFrame:[self bounds]];
    textScrollView.showsHorizontalScrollIndicator = NO;
    textScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:textScrollView];
    self.textScrollView = textScrollView;
    BOOL isShowVer = NO;
    if (_showMentType == ShowMentTypeNoAspfit) {
        isShowVer = YES;
    }
    self.textScrollView.showsVerticalScrollIndicator = isShowVer;
    
    [self updateTextDataArray:_textDataArray];
}

@end


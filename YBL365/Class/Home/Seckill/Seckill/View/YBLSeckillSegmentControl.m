//
//  YBLSeckillSegmentControl.m
//  YBL365
//
//  Created by 乔同新 on 12/21/16.
//  Copyright © 2016 乔同新. All rights reserved.
//

#import "YBLSeckillSegmentControl.h"

static NSInteger BUTTON_TAG = 10;

@interface YBLSeckillSegmentControl ()
{
    NSInteger selectTimeIndex;
}
@property (nonatomic, strong) NSMutableArray *buttonsArray;

@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation YBLSeckillSegmentControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSeckillSegmentUI];
    }
    return self;
}

- (void)createSeckillSegmentUI{

    selectTimeIndex = 0;
    
    self.buttonsArray = [NSMutableArray array];
    NSInteger titleCount = self.titlesArray.count;
    
    for (int i = 0; i < titleCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i*(self.frame.size.width/titleCount), 0, self.frame.size.width/titleCount , self.frame.size.height)];
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateSelected];
        [button setTag:BUTTON_TAG+i];
        if (i == 0) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonsArray addObject:button];
     
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (NSArray *)titlesArray{
    
    if (!_titlesArray) {
        _titlesArray = [NSArray array];
        _titlesArray = @[@"抢购中",
                    @"即将开始",
                    @"即将开始",
                    @"即将开始",
                    @"即将开始"];
    }
    return _titlesArray;
}

- (void)setTimesArray:(NSMutableArray *)timesArray{
    
    _timesArray = timesArray;
    
    [self.buttonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        NSString *timeString = _timesArray[idx];
        NSString *titlesString = self.titlesArray[idx];
        NSString *btnText = [NSString stringWithFormat:@"%@\n%@",timeString,titlesString];
        NSRange timeStringRange = NSMakeRange(0, timeString.length);
        NSRange titlesStringRange = NSMakeRange(btnText.length-titlesString.length, titlesString.length);
        
        /**
         未选中
         */
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:btnText];
        
        [AttributedStr addAttributes:[self getTextAttributeWithFontSize:YBLBFont(16) color:YBLColor(45, 44, 55, 1)]
                               range:timeStringRange];
        [AttributedStr addAttributes:[self getTextAttributeWithFontSize:YBLFont(11) color:YBLColor(45, 44, 55, 1)]
                               range:titlesStringRange];
        
        [btn setAttributedTitle:AttributedStr forState:UIControlStateNormal];
        
        /**
         选中
         */
        NSMutableAttributedString *AttributedStr_Select = [[NSMutableAttributedString alloc]initWithString:btnText];
        
        [AttributedStr_Select addAttributes:[self getTextAttributeWithFontSize:YBLBFont(19) color:YBLThemeColor]
                                      range:timeStringRange];
        [AttributedStr_Select addAttributes:[self getTextAttributeWithFontSize:YBLFont(11) color:YBLThemeColor]
                                      range:titlesStringRange];
        
        [btn setAttributedTitle:AttributedStr_Select forState:UIControlStateSelected];
    }];

}

- (NSDictionary *)getTextAttributeWithFontSize:(UIFont *)font color:(UIColor *)color{
    
    NSDictionary *textAttribute = @{NSFontAttributeName: font,
                                    NSForegroundColorAttributeName:color};
    
    return textAttribute;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    _currentIndex = currentIndex;
    
    [self doClick:_currentIndex];
}

- (void)segmentClick:(UIButton *)btn{
    
    NSInteger btnTag = btn.tag-BUTTON_TAG;
    
    [self doClick:btnTag];
}

- (void)doClick:(NSInteger)tag{
    
    UIButton *button = (UIButton *)[self viewWithTag:tag+BUTTON_TAG];
    
    if (selectTimeIndex != tag) {
        
        UIButton *currentButton = (UIButton *)[self viewWithTag:selectTimeIndex+BUTTON_TAG];
        currentButton.selected = NO;
        button.selected = YES;
        selectTimeIndex = tag;
        
        if ([self.delegate respondsToSelector:@selector(seckillSegmentControlIndex:)]) {
            [self.delegate seckillSegmentControlIndex:selectTimeIndex];
        }
    }
    
    
}

@end

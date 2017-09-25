//
//  YBLSingleTextSegment.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//△▽Δ

#import "YBLSingleTextSegment.h"

static NSInteger BUTTON_TAG = 58855;

@interface YBLSingleTextSegment ()
{
    NSInteger selectIndex;
}
@end

@implementation YBLSingleTextSegment

- (instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)array{

    if (self = [super initWithFrame:frame]) {
        
        selectIndex = 0;
        _titleArray = array.mutableCopy;
        
        NSInteger count = array.count;
        
        for (int i = 0; i < count; i++) {
            
            CGFloat wi = self.width/count;
            
            CGRect frame = CGRectMake(i*wi, 0, wi, self.height);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = frame;
            button.tag = BUTTON_TAG+i;
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:YBLColor(40, 40, 40, 1) forState:UIControlStateNormal];
            [button setTitleColor:YBLThemeColor forState:UIControlStateSelected];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = YBLFont(15);
            if (i == 0) {
                button.selected = YES;
            }
            [button addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if (i!=count-1) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.width-0.5, 0, 0.5, button.height/2)];
                lineView.centerY = self.height/2;
                lineView.backgroundColor = YBLLineColor;
                [button addSubview:lineView];
            }
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, self.width, 0.5)];
        lineView.backgroundColor = YBLLineColor;
        [self addSubview:lineView];
        self.lineView = lineView;
        
    }
    return self;
}

- (void)buttonSelect:(UIButton *)btn{
    
    NSInteger tag = btn.tag - BUTTON_TAG;
    
   [self doClick:tag];
    
}

- (void)setCurrentInex:(NSInteger)currentInex{
    
    [self doClick:currentInex];

}

- (void)doClick:(NSInteger)index{
    
    UIButton *currentButton = (UIButton *)[self viewWithTag:index+BUTTON_TAG];
    
    if (selectIndex!=index) {
        
        UIButton *selectButton = (UIButton *)[self viewWithTag:selectIndex+BUTTON_TAG];
        currentButton.selected = YES;
        selectButton.selected = NO;
        
        selectIndex = index;
        
        if ([self.delegate respondsToSelector:@selector(CurrentSegIndex:)]) {
            [self.delegate CurrentSegIndex:selectIndex];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(CurrentSegIndexReclick:)]) {
            [self.delegate CurrentSegIndexReclick:selectIndex];
        }
    }
}

- (void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray = titleArray;

    [self reSetSegmentTitle];
}

- (void)setEnableSegment:(BOOL)enableSegment{
    _enableSegment = enableSegment;
    self.userInteractionEnabled = _enableSegment;
}

- (void)reSetSegmentTitle{
    
    NSInteger count = self.titleArray.count;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:BUTTON_TAG+i];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
    }
}

- (void)repalceTitleWith:(NSString *)text repIndex:(NSInteger)repIndex{
    text = [NSString stringWithFormat:@"%@△",text];
    [self.titleArray replaceObjectAtIndex:repIndex withObject:text];
    
    [self reSetSegmentTitle];
}

@end

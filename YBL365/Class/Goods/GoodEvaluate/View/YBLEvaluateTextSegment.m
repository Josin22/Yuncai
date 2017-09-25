//
//  YBLEvaluateTextSegment.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/28.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLEvaluateTextSegment.h"
#import "TextImageButton.h"

static const NSInteger button_tag = 2928;

@interface YBLEvaluateTextSegment()
{
    NSInteger selectIndex;
}

@property (nonatomic, strong) NSArray *defaultTitleArray;

@end

@implementation YBLEvaluateTextSegment

- (instancetype)initWithFrame:(CGRect)frame{
    
    return [self initWithFrame:frame titleArray:self.defaultTitleArray.mutableCopy];
}

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSMutableArray *)titleArray{
    
    if (self = [super initWithFrame:frame]) {
        _titleArray = titleArray;
        _textFont = YBLFont(12);
        
        [self createUIWithData:_titleArray];
    }
    return self;
}

- (NSArray *)defaultTitleArray{
    
    if (!_defaultTitleArray) {
        _defaultTitleArray = @[@"全部评价",@"好评",@"中评",@"差评",@"有图"].mutableCopy;
    }
    return _defaultTitleArray;
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    for (int i = 0; i < _nummberArray.count; i++) {
        id num = _nummberArray[i];
        TextImageButton *selectButton = (TextImageButton *)[self viewWithTag:i+button_tag];
        selectButton.topLabel.font = _textFont;
        selectButton.bottomLabel.font = _textFont;
        selectButton.bottomLabel.text = [self getNummberValue:num];
    }
}

- (void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray = titleArray;
    
    for (UIView *subv in self.subviews) {
        [subv removeFromSuperview];
    }
    
    [self createUIWithData:_titleArray];
}

- (void)setNummberArray:(NSMutableArray *)nummberArray{
    _nummberArray = nummberArray;
    for (int i = 0; i < _nummberArray.count; i++) {
        id num = _nummberArray[i];
        TextImageButton *selectButton = (TextImageButton *)[self viewWithTag:i+button_tag];
        selectButton.bottomLabel.text = [self getNummberValue:num];
    }
}

- (id)getNummberValue:(id)nummber{
    if ([nummber isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",nummber];
    }
    return nummber;
}

- (void)createUIWithData:(NSArray *)dataArray{
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSInteger index = 0;
    CGFloat itemWi = self.width/dataArray.count;
    
    for (NSString *title in dataArray) {
        TextImageButton *item = [[TextImageButton alloc] initWithFrame:CGRectMake(index*itemWi, 0, itemWi, self.height)];
        item.topLabel.font = self.textFont;
        item.bottomLabel.font = self.textFont;
        item.topLabel.text = title;
        item.bottomLabel.text = @"0";
        item.tag = button_tag+index;
        [item addTarget:self action:@selector(ItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        if (index == 0) {
            item.selected = YES;
        }
        index++;
    }
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, self.height-0.5, self.width, 0.5)]];
}

- (void)ItemClick:(TextImageButton *)btn{
    
    NSInteger tag = btn.tag - button_tag;
    
    [self doClick:tag isRecieve:YES];
}

- (void)doClick:(NSInteger)index isRecieve:(BOOL)isRecieve{
    
    TextImageButton *currentButton = (TextImageButton *)[self viewWithTag:index+button_tag];
    if (selectIndex!=index) {
        currentButton.selected = YES;
        TextImageButton *selectButton = (TextImageButton *)[self viewWithTag:selectIndex+button_tag];
        selectButton.selected = NO;
        selectIndex = index;
        if ([self.delegate respondsToSelector:@selector(textDidSelectIndex:clickItem:)]&&isRecieve) {
            [self.delegate textDidSelectIndex:selectIndex clickItem:currentButton];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;

    [self doClick:_currentIndex isRecieve:YES];
}


@end

//
//  YBLScaleTextSegmentView.m
//  YBL365
//
//  Created by 乔同新 on 2017/3/8.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLScaleTextSegmentView.h"
#import "TextImageButton.h"

static NSInteger item_tag = 824;

@interface YBLScaleTextSegmentView ()
{
    NSInteger selectIndex;
}
@property (nonatomic, strong) NSArray *upValue;
@property (nonatomic, strong) NSArray *bottomValue;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) TextImageButton *item1;
@property (nonatomic, strong) TextImageButton *item2;
@property (nonatomic, strong) TextImageButton *item3;

@end

@implementation YBLScaleTextSegmentView

- (instancetype)initWithFrame:(CGRect)frame
                      UpValue:(NSArray *)upValue
                  BottomValue:(NSArray *)bottomValue{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _upValue = upValue;
        _bottomValue = bottomValue;
        self.backgroundColor = [UIColor whiteColor];
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    NSInteger index = 0;
    selectIndex = 0;
    NSInteger itemWi = self.width/_upValue.count;
    
    for (id upvalue in _upValue) {
        NSString *bottomValue = _bottomValue[index];
        Type type = TypeText;
        if ([upvalue isKindOfClass:[NSString class]]) {
            type = TypeText;
        } else if ([upvalue isKindOfClass:[UIImage class]]) {
            type = TypeImage;
        }
        TextImageButton *item = [[TextImageButton alloc] initWithFrame:CGRectMake(index*itemWi, 0, itemWi, self.height)
                                                                  Type:type];
        if (type == TypeText) {
            item.topLabel.text = upvalue;
            item.topLabel.font = YBLFont(14);
        } else if (type == TypeImage){
            item.iconImageView.image = upvalue;
        }
        item.tag = item_tag+index;
        if (index == 0) {
            item.selected = YES;
        }
        item.bottomLabel.text = bottomValue;
        item.bottomLabel.font = YBLFont(13);
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
       
        index++;
    }
    
    
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1.5, itemWi, 1.5)];
    self.lineView.backgroundColor = YBLThemeColor;
    [self addSubview:self.lineView];
    
    [self addSubview:[YBLMethodTools addLineView:CGRectMake(0, self.height-0.5, self.width, 0.5)]];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    [self doClick:_currentIndex];
}

- (void)itemClick:(TextImageButton *)btn{
    
    NSInteger tag = btn.tag-item_tag;
    
    [self doClick:tag];
}

- (void)doClick:(NSInteger)tag{
    
    TextImageButton *button = (TextImageButton *)[self viewWithTag:tag+item_tag];
    
    if (selectIndex != tag) {
        
        TextImageButton *currentButton = (TextImageButton *)[self viewWithTag:selectIndex+item_tag];
        currentButton.selected = NO;
        button.selected = YES;
        selectIndex = tag;
        NSInteger itemWi = self.width/_upValue.count;
        
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.lineView.left = (itemWi*selectIndex);
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        if ([self.delegate respondsToSelector:@selector(textSegmentControlIndex:)]) {
            [self.delegate textSegmentControlIndex:selectIndex];
        }
    }
}

- (void)setRatio:(CGFloat)ratio{
    _ratio = ratio;
   
    for (int i = 0; i < _upValue.count; i++) {
        TextImageButton *item = (TextImageButton *)[self viewWithTag:item_tag+i];
        item.topLabel.scale = ratio/10;
        CGFloat scale = 1.2;
        item.bottomLabel.scale = scale-(scale-1)/10*ratio;//
        item.bottomLabel.centerY = self.height/2+ratio;
    }
}

- (void)setTopValue:(NSMutableArray *)topValue{
    _topValue = topValue;
    [self resetValue:_topValue isTop:YES];
}

- (void)setBottomsValue:(NSMutableArray *)bottomsValue{
    _bottomsValue = bottomsValue;
    [self resetValue:_bottomsValue isTop:NO];
}

- (void)resetValue:(NSMutableArray *)value isTop:(BOOL)isTop{

    for (int i = 0; i < value.count; i++) {
        NSString *topv = nil;
        id unfinevalue =  value[i];
        if ([unfinevalue isKindOfClass:[NSNumber class]]) {
            topv = [NSString stringWithFormat:@"%@",unfinevalue];
        } else {
            topv = unfinevalue;
        }
        TextImageButton *item = (TextImageButton *)[self viewWithTag:item_tag+i];
        if (isTop) {
            item.topLabel.text = topv;
        } else {
            item.bottomLabel.text = topv;
        }
    }
}

@end

//
//  YBLTimeLineItemView.m
//  YC168
//
//  Created by 乔同新 on 2017/4/13.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLTimeLineItemView.h"

@interface YBLTimeLineItemView ()

@property (nonatomic, strong) UIButton *pointView;

@property (nonatomic, strong) UIView *pointMaskView;

@property (nonatomic, strong) UIView *pointLineView;

@end

@implementation YBLTimeLineItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _pointLength = 8;
        _tinColor = YBLThemeColor;
        _normalColor = YBLColor(210, 210, 210, 1);
        _pointLineWidth = .8;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.pointLineView = [[UIView alloc] init];
    self.pointLineView.backgroundColor = _normalColor;
    [self addSubview:self.pointLineView];
    
    CGFloat pow = _pointLength*1.7;
    
    self.pointMaskView = [[UIView alloc] init];
    self.pointMaskView.backgroundColor = [_tinColor colorWithAlphaComponent:.5];
    self.pointMaskView.layer.masksToBounds = YES;
    self.pointMaskView.layer.cornerRadius = pow/2;
    [self addSubview:self.pointMaskView];
    
    self.pointView = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.pointView.frame = CGRectMake(0, 0, _pointLength, _pointLength);
    [self.pointView setBackgroundColor:_tinColor forState:UIControlStateSelected];
    [self.pointView setBackgroundColor:_normalColor forState:UIControlStateNormal];
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = _pointLength/2;
    [self addSubview:self.pointView];
    
    [self resetFrame];
}

- (void)resetFrame{
    
    self.pointLineView.frame = CGRectMake(0, 0, _pointLineWidth, self.height);
    self.pointLineView.centerX = self.width/2;
    CGFloat pow = _pointLength*1.7;
    self.pointMaskView.frame = CGRectMake(0, 0, pow, pow);
    self.pointMaskView.center = self.center;
    self.pointView.frame = CGRectMake(0, 0, _pointLength, _pointLength);
    self.pointView.center = self.pointMaskView.center;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    [self resetFrame];
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    [self.pointView setBackgroundColor:_normalColor forState:UIControlStateNormal];
}

- (void)setTinColor:(UIColor *)tinColor {
    _tinColor = tinColor;
    [self.pointView setBackgroundColor:_tinColor forState:UIControlStateSelected];
}

- (void)setPointLength:(CGFloat)pointLength{
    _pointLength = pointLength;
    self.pointView.width = _pointLength;
    self.pointMaskView.width = _pointLength*1.7;
    self.pointView.center = self.pointMaskView.center;
}

- (void)setPointLineWidth:(CGFloat)pointLineWidth{
    _pointLineWidth = pointLineWidth;
    self.pointLineView.width = _pointLineWidth;
    self.pointLineView.centerX = self.width/2;
}

- (void)setTimeLineState:(TimeLineState)timeLineState{
    _timeLineState = timeLineState;
    switch (_timeLineState) {
        case TimeLineStateStartPoint:
        {
            self.pointMaskView.hidden = YES;
            self.pointView.selected = NO;
            self.pointLineView.top = 0;
            self.pointLineView.height = self.height/2;
        }
            break;
        case TimeLineStatePointLine:
        {
            self.pointMaskView.hidden = YES;
            self.pointView.selected = NO;
            self.pointLineView.top = 0;
            self.pointLineView.height = self.height;
        }
            break;
        case TimeLineStateEndPoint:
        {
            self.pointMaskView.hidden = NO;
            self.pointView.selected = YES;
            self.pointLineView.top = self.height/2;
            self.pointLineView.height = self.height/2;
        }
            break;
            
        default:
            break;
    }
}

- (void)animate {

    CABasicAnimation *breath = [YBLMethodTools AlphaLight:.6];
    [self.pointMaskView.layer addAnimation:breath forKey:@"breath"];
}

@end

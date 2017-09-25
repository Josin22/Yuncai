//
//  YBLSiginView.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/6.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLSignLabel.h"

@interface YBLSignLabel ()

@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, assign) SiginDirection direction;

@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation YBLSignLabel

- (instancetype)initWithFrame:(CGRect)frame SiginDirection:(SiginDirection)direction{
    
    if (self = [super initWithFrame:frame]) {
        _direction = direction;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    _isFillAll = YES;
    _fillColor = YBLThemeColor;
    
    CGFloat height = self.height;
    CGFloat width = self.width;
    CGRect labelFrame = CGRectZero;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(width, 0)];
    if (_direction == SiginDirectionTop) {
    
        [linePath addLineToPoint:CGPointMake(width, height)];
        [linePath addLineToPoint:CGPointMake(width/2, height-5)];
        labelFrame = CGRectMake(1, 1, self.width-2, height-5-2);
        
    } else {
    
        [linePath addLineToPoint:CGPointMake(width-height/2, height/2)];
        [linePath addLineToPoint:CGPointMake(width, height)];
        labelFrame = CGRectMake(1, 1, self.width-2-10, height-2);
    }
    [linePath addLineToPoint:CGPointMake(0, height)];
    [linePath addLineToPoint:CGPointMake(0, 0)];
    [linePath closePath];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = [self bounds];
    layer.path = linePath.CGPath;
    layer.fillColor = YBLThemeColor.CGColor;
    [self.layer addSublayer:layer];
    self.lineLayer = layer;
    
    /* text label */
    
    
    _textLabel = [[UILabel alloc] initWithFrame:labelFrame];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor whiteColor];
    [self addSubview:_textLabel];
}

- (void)setIsFillAll:(BOOL)isFillAll{
    _isFillAll = isFillAll;
    
    if (isFillAll) {
        self.lineLayer.fillColor = _fillColor.CGColor;
    } else {
        self.lineLayer.fillColor = [UIColor whiteColor].CGColor;
        self.lineLayer.strokeColor = _lineColor.CGColor;
        self.lineLayer.lineWidth = 0.7;
    }
}

- (void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    if (_isFillAll) {
        self.lineLayer.fillColor = _fillColor.CGColor;
    }
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    if (!_isFillAll) {
        self.lineLayer.fillColor = [UIColor whiteColor].CGColor;
        self.lineLayer.strokeColor = _lineColor.CGColor;
        self.lineLayer.lineWidth = 0.7;
    }
}

- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    _textLabel.font = textFont;
}

- (void)setSignText:(NSString *)signText{
    _signText = signText;
    _textLabel.text = signText;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _textLabel.textColor = _textColor;
}

@end

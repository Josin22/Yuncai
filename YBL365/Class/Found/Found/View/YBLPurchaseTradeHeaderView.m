//
//  YBLPurchaseTradeHeaderView.m
//  YBL365
//
//  Created by 乔同新 on 2017/1/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPurchaseTradeHeaderView.h"

#pragma mark YBLCircleButton

@interface YBLCircleButton : UIView

@property (nonatomic, retain) UILabel *numberLabel;

@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, assign) CGFloat lineWidth;

@end

@interface YBLCircleButton ()

@property (nonatomic, assign) BOOL isLineCircle;

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation YBLCircleButton

- (instancetype)initWithFrame:(CGRect)frame isLineCircle:(BOOL)isLineCircle
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isLineCircle = isLineCircle;
        
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat labelHi = 20;
    CGFloat lineWi = 2;
    CGFloat circleRa = self.width/2;
    CGFloat lineSpace = 8;
    CGPoint centP = CGPointMake(self.width/2, self.height/2-labelHi);
    CGRect lineFrame =  CGRectMake(0, 0, self.width, self.height-labelHi-space/2);
    CGRect labelFrame = CGRectMake(lineWi, centP.y-labelHi/2, lineFrame.size.width-2*lineWi, labelHi);
    if (_isLineCircle) {
        circleRa = self.width/2-lineSpace;
        CGFloat ZA_circleRa = self.width/2;
        labelFrame = CGRectMake(lineWi+lineSpace, centP.y-labelHi/2, lineFrame.size.width-2*(lineWi+lineSpace), labelHi);
        
        UIBezierPath *ZA_CirceLinePath = [UIBezierPath bezierPathWithArcCenter:centP
                                                                        radius:ZA_circleRa
                                                                    startAngle:0
                                                                      endAngle:DEGREES_TO_RADIANS(360)
                                                                     clockwise:YES];
        [ZA_CirceLinePath closePath];
        
        CAShapeLayer *ZA_LineCircleLayer = [CAShapeLayer layer];
        ZA_LineCircleLayer.frame = lineFrame;
        ZA_LineCircleLayer.path = ZA_CirceLinePath.CGPath;
        ZA_LineCircleLayer.fillColor = [UIColor clearColor].CGColor;
        ZA_LineCircleLayer.lineWidth = 0.6;
        ZA_LineCircleLayer.strokeColor = YBLTextColor.CGColor;
        [self.layer addSublayer:ZA_LineCircleLayer];
    }
    UIBezierPath *circleLinePath = [UIBezierPath bezierPathWithArcCenter:centP
                                                                  radius:circleRa
                                                              startAngle:0
                                                                endAngle:DEGREES_TO_RADIANS(360)
                                                               clockwise:YES];
    [circleLinePath closePath];
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = lineFrame;
    circleLayer.path = circleLinePath.CGPath;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineWidth = lineWi;
    circleLayer.strokeColor = YBLThemeColor.CGColor;
    [self.layer addSublayer:circleLayer];
    self.circleLayer = circleLayer;
    
    self.numberLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = YBLFont(20);
    [self addSubview:self.numberLabel];
    
    self.textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, self.width, self.width, labelHi)];
    self.textLabel.textColor = YBLColor(100, 101, 102, 1);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = YBLFont(13);
    [self addSubview:self.textLabel];
    
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    
    self.circleLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    
    self.circleLayer.lineWidth = lineWidth;
}

@end

#pragma mark YBLTextButton

@interface YBLTextButton : UIView

@property (nonatomic, retain) UILabel *textLabel;

@property (nonatomic, retain) UILabel *numberLabel;

@end

@implementation YBLTextButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height/2)];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = YBLFont(20);
    self.numberLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.numberLabel];

    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.numberLabel.bottom, self.numberLabel.width, self.height/2)];
    self.textLabel.textColor = YBLColor(100, 101, 102, 1);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = YBLFont(13);
    [self addSubview:self.textLabel];

}

@end

#pragma mark  YBLPurchaseTradeHeaderView

@interface YBLPurchaseTradeHeaderView ()

@end

@implementation YBLPurchaseTradeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTradeHeaderView];
    }
    return self;
}

- (void)createTradeHeaderView{
    
    self.backgroundColor = YBLColor(44, 43, 41, 1);
    
    CGFloat  height = [YBLPurchaseTradeHeaderView getMMTradeHeaderViewHeight];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"orderMM_mount"]];
    CGFloat imageViewHeight = ((double)106/720)*YBLWindowWidth;
    bgView.frame = CGRectMake(0, height/2, YBLWindowWidth, imageViewHeight);
    [self addSubview:bgView];
    
    CGFloat circleWi = (YBLWindowWidth-8*space)/3;
    CGFloat circleHi = circleWi+25;
    
    YBLCircleButton *circleButton1 = [[YBLCircleButton alloc] initWithFrame:CGRectMake(2*space, bgView.top-circleWi+space*2, circleWi, circleHi) isLineCircle:YES];
    circleButton1.numberLabel.text = @"294";
    circleButton1.textLabel.text = @"已完成箱";
    circleButton1.lineWidth = 2.5;
    [self addSubview:circleButton1];
    
    YBLCircleButton *circleButton2 = [[YBLCircleButton alloc] initWithFrame:CGRectMake(circleButton1.right+2*space, bgView.top-circleWi, circleWi, circleHi) isLineCircle:NO];
    circleButton2.numberLabel.text = @"100万元";
    circleButton2.textLabel.text = @"总成交额";
    circleButton2.lineColor = YBLColor(77, 209, 194, 1);
    circleButton2.lineWidth = 5;
    [self addSubview:circleButton2];
    
    YBLCircleButton *circleButton3 = [[YBLCircleButton alloc] initWithFrame:CGRectMake(circleButton2.right+2*space, circleButton1.top, circleWi, circleHi) isLineCircle:YES];
    circleButton3.numberLabel.text  = @"50天";
    circleButton3.textLabel.text = @"上线时间";
    circleButton3.lineWidth = 2.5;
    [self addSubview:circleButton3];
    
    
    CGFloat lineWi  = 1;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(2*space, bgView.bottom, YBLWindowWidth-4*space, lineWi)];
    lineView1.backgroundColor = YBLTextColor;
    [self addSubview:lineView1];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.left, height-space, lineView1.width, lineWi)];
    lineView3.backgroundColor = YBLTextColor;
    [self addSubview:lineView3];

    CGFloat lineHeit = lineView3.top-lineView1.bottom;
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(YBLWindowWidth/2, lineView1.bottom, lineWi,lineHeit)];
    lineView2.backgroundColor = YBLTextColor;
    [self addSubview:lineView2];

    
    YBLTextButton *textButton1 = [[YBLTextButton alloc] initWithFrame:CGRectMake(lineView1.left, lineView1.bottom+space, lineView1.width/2, lineHeit-2*space)];
    textButton1.numberLabel.text = @"2000";
    textButton1.textLabel.text = @"总需求箱数";
    [self addSubview:textButton1];
    
    
    YBLTextButton *textButton2 = [[YBLTextButton alloc] initWithFrame:CGRectMake(lineView2.left, textButton1.top, textButton1.width, textButton1.height)];
    textButton2.numberLabel.text = @"¥28470";
    textButton2.textLabel.text = @"总采购金额";
    [self addSubview:textButton2];
    
    
    
}

+ (CGFloat)getMMTradeHeaderViewHeight{
    
    return 250;
}

@end

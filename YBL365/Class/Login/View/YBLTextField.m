//
//  YBLTextField.m
//  YBL365
//
//  Created by 乔同新 on 2016/12/19.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLTextField.h"

static NSInteger BUTTON_TAG  = 201;

@interface YBLTextField ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation YBLTextField

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
    
        [self createTextFieldUI];
    }
    return self;
}

- (void)createTextFieldUI{
    
    UIBezierPath *lineCirclePath = [UIBezierPath bezierPath];
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat radiuo = height/2;
    [lineCirclePath addArcWithCenter:CGPointMake(radiuo, radiuo)
                           radius:radiuo
                       startAngle:DEGREES_TO_RADIANS(90)
                         endAngle:DEGREES_TO_RADIANS(270)
                        clockwise:YES];
    [lineCirclePath addLineToPoint:CGPointMake(width-height, 0)];
    [lineCirclePath addArcWithCenter:CGPointMake(width-radiuo, radiuo)
                           radius:radiuo
                       startAngle:DEGREES_TO_RADIANS(270)
                         endAngle:DEGREES_TO_RADIANS(90)
                        clockwise:YES];
    [lineCirclePath addLineToPoint:CGPointMake(width-radiuo, height)];
    [lineCirclePath closePath];
    
    CAShapeLayer *lineCircleLayer = [self getLayer];
    lineCircleLayer.frame = self.bounds;
    [self.layer addSublayer:lineCircleLayer];
    lineCircleLayer.path = lineCirclePath.CGPath;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(radiuo, 0, self.width-self.height, self.height)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font = YBLFont(14);
    [_textField setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:_textField];

    //找回密码
    UIButton *foundPWDButton = [self getButton:@"找回密码"];
    foundPWDButton.tag  = BUTTON_TAG;
    [self addSubview:foundPWDButton];
    foundPWDButton.hidden = YES;
    
    //发送验证码
    UIButton *sendCodeButton = [self getButton:@"发送验证码"];
    sendCodeButton.tag = BUTTON_TAG+1;
    [self addSubview:sendCodeButton];
    sendCodeButton.hidden = YES;
    
    //+86
    UIButton *nummberButton = [self getButton:@"+86"];
    nummberButton.tag = BUTTON_TAG+2;
    [self addSubview:nummberButton];
    nummberButton.hidden = YES;
    
}

- (UIButton *)getButton:(NSString *)title{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:YBLColor(80, 80, 80, 1) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    button.titleLabel.font = YBLFont(13);
    return button;
}

- (void)changeButtonFrame:(textFieldType)type{
    
    UIButton *codeButton = (UIButton *)[self viewWithTag:BUTTON_TAG+1];
    UIButton *foundButton = (UIButton *)[self viewWithTag:BUTTON_TAG];
//    UIButton *xxButton = (UIButton *)[self viewWithTag:BUTTON_TAG+2];

    for (int i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:BUTTON_TAG+i];
        NSString *title = button.currentTitle;
        CGSize titleSize =  [title heightWithFont:YBLFont(13) MaxWidth:200];
        CGFloat titleWidth = titleSize.width;
        CGFloat titleHeight = titleSize.height;
        CGFloat titleSpace = 5;
        CGFloat buttonWidth = titleWidth+2*titleSpace;
        CGFloat lineStartY = (self.height-(titleHeight+2))/2;
        
        CAShapeLayer *verticalLineLayer = [self getLayer];
        UIBezierPath *verticallinePath = [UIBezierPath bezierPath];
        
        if (type == textFieldTypePhone) {
            button.enabled = NO;
            button.frame = CGRectMake(0, 0, buttonWidth, self.height);
            verticalLineLayer.frame = [button bounds];
            [verticallinePath moveToPoint:CGPointMake(buttonWidth, lineStartY)];
            [verticallinePath addLineToPoint:CGPointMake(buttonWidth, lineStartY+titleHeight+2)];
            [verticallinePath closePath];
            CGRect textFrame = [_textField frame];
            textFrame.origin.x = buttonWidth;
            textFrame.size.width = self.width-buttonWidth-self.height/2;
            _textField.frame = textFrame;
            
        }else {
            button.frame = CGRectMake(self.width-buttonWidth, 0, buttonWidth, self.height);
            verticalLineLayer.frame = [button bounds];
            [verticallinePath moveToPoint:CGPointMake(0, lineStartY)];
            [verticallinePath addLineToPoint:CGPointMake(0, lineStartY+titleHeight+2)];
            [verticallinePath closePath];
            CGRect textFrame = [_textField frame];
            textFrame.origin.x = self.height/2;
            textFrame.size.width = self.width-buttonWidth-self.height/2;
            _textField.frame = textFrame;
            [button addTarget:self action:@selector(textFieldButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        verticalLineLayer.path = verticallinePath.CGPath;
        [button.layer addSublayer:verticalLineLayer];
        
    }
    
    switch (type) {
        case textFieldTypeDefault:
        {
            codeButton.hidden = YES;
            foundButton.hidden = YES;
        }
            break;
        case textFieldTypeSendCode:
        {
            codeButton.hidden = NO;
            foundButton.hidden = YES;
        }
            break;
        case textFieldTypeFoundPWD:
        {
            codeButton.hidden = YES;
            foundButton.hidden = NO;
        }
            break;
        case textFieldTypePhone :
        {
            
        }
            break;
        default:
            break;
    }
}


- (void)textFieldButtonClick:(UIButton *)btn{
    
    BLOCK_EXEC(self.textFieldBlock,_currentType);
}

- (CAShapeLayer *)getLayer{
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 0.5;
    layer.strokeColor = YBLColor(153, 153, 153, 1).CGColor;
    layer.fillColor = YBLColor(255, 255, 255, 1).CGColor;
    layer.backgroundColor = [UIColor clearColor].CGColor;

    return layer;
}

- (void)setPlaceholderValue:(NSString *)placeholderValue{
    
    _placeholderValue = placeholderValue;
    
    _textField.placeholder = placeholderValue;
}

- (void)setCurrentValue:(NSString *)currentValue{
    
    _textField.text = currentValue;
    
}

- (NSString *)currentValue{
    
    return _textField.text;
}

- (void)setCurrentType:(textFieldType)currentType{
    
    _currentType = currentType;
    
    [self changeButtonFrame:currentType];
}

@end

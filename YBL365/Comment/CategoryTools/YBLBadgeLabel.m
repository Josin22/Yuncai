//
//  YBLBadgeLabel.m
//  YC168
//
//  Created by 乔同新 on 2017/6/14.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBadgeLabel.h"
#import "UIView+YBLCornerRadius.h"

@implementation YBLBadgeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.font = YBLFont(10);
    self.textColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = YBLThemeColor;
    
}

- (void)setBageValue:(NSInteger)bageValue{
    _bageValue = bageValue;
    
    if (_bageValue<=0) {
        self.hidden = YES;
        return;
    } else {
        self.hidden = NO;
    }
    NSString *bageText = [NSString stringWithFormat:@"%@",@(_bageValue)];
    if ([bageText isEqualToString:self.text]) {
        return;
    }
    if(_bageValue > 99){
        bageText=@"99+";
    }
    self.text = bageText;
    CGSize textSize = [bageText heightWithFont:YBLFont(11) MaxWidth:100];
    CGFloat bageValueW = textSize.width+5;
    CGFloat bageValueH = 12;
    if (bageValueH>bageValueW) {
        bageValueW=bageValueH;
    }
    self.width = bageValueW;
    self.height = bageValueH;

    self.layer.cornerRadius = bageValueH/2;//圆形
    
    [YBLMethodTools addAnimationWith:self];
}

@end

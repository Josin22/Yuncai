//
//  YBLLicensBrandItemView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/2.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLLicensBrandItemView.h"

@interface YBLLicensBrandItemView ()

@property (nonatomic, strong) CAGradientLayer *brandLineLayer;

@end

@implementation YBLLicensBrandItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    self.brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-2)];
    self.brandLabel.backgroundColor = [UIColor whiteColor];
    self.brandLabel.textColor = YBLTextColor;
    self.brandLabel.font = YBLBFont(14);
    self.brandLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.brandLabel];
    
    self.brandLineLayer = [CAGradientLayer layer];
    self.brandLineLayer.frame = CGRectMake(self.brandLabel.left, self.brandLabel.bottom, self.brandLabel.width, self.height-self.brandLabel.bottom);
    self.brandLineLayer.colors = @[(__bridge id)YBLColor(190, 116, 246, 1).CGColor,
                                   (__bridge id)YBLColor(148, 152, 233, 1).CGColor,
                                   (__bridge id)YBLColor(131, 199, 237, 1).CGColor,
                                   ];
    self.brandLineLayer.locations = @[@(0.0),@(0.33),@(0.66)];
    self.brandLineLayer.startPoint = CGPointMake(0, 0.5);
    self.brandLineLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer addSublayer:self.brandLineLayer];
    //
    
    
}
@end

//
//  HMSelectCounterButton.m
//  HMImagePicker
//
//  Created by 刘凡 on 16/1/29.
//  Copyright © 2016年 itheima. All rights reserved.
//

#import "HMSelectCounterButton.h"
#import "HMImagePickerGlobal.h"

@implementation HMSelectCounterButton

#pragma mark - 设置数据
- (void)setCount:(NSInteger)count {
    _count = count;
    
    [self setTitle:[NSString stringWithFormat:@"%zd", count] forState:UIControlStateNormal];
    BOOL isHidden = count <= 0;
    
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.hidden = isHidden;
                     } completion:nil];
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [bundle URLForResource:HMImagePickerBundleName withExtension:nil];
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        UIImage *image = [UIImage imageNamed:@"number_icon"
                                    inBundle:imageBundle
               compatibleWithTraitCollection:nil];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setTitle:@"0" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.hidden = YES;
        
        [self sizeToFit];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

@end

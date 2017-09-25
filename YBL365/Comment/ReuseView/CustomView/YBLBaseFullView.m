//
//  YBLBaseFullView.m
//  手机云采
//
//  Created by 乔同新 on 2017/7/21.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseFullView.h"

@implementation YBLBaseFullView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createssUI];
    }
    return self;
}

- (void)createssUI{
    
    /* 背景 文字 */
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;
    
    [UIView animateWithDuration:.4
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
                     }];
}

- (void)dismiss{
    
}

@end

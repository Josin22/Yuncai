//
//  YBLBaseView.m
//  YC168
//
//  Created by 乔同新 on 2017/3/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLBaseView.h"

@implementation YBLBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    /* 背景 文字 */
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, YBLWindowHeight+space, YBLWindowWidth, YBLWindowHeight/3)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [YBLMethodTools addTopShadowToView:self.contentView];
    
    [self addSubvieToContentView];
    
    [UIView animateWithDuration:.4
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
                         self.contentView.bottom = YBLWindowHeight;
                     }];
}

- (void)addSubvieToContentView{
    
}

- (void)dismiss{

}

@end

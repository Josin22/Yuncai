//
//  YBLUpButton.m
//  YBL365
//
//  Created by 乔同新 on 16/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLUpButton.h"

@implementation YBLUpButton

+ (instancetype)showInView:(UIView *)view center:(CGPoint)center scrollView:(UIScrollView *)scrollView zeroTop:(CGFloat)top {
    YBLUpButton *upButton = [YBLUpButton buttonWithType:UIButtonTypeCustom];
    upButton.size = CGSizeMake(40, 40);
    upButton.center = center;
    [view addSubview:upButton];
    [upButton setImage:[UIImage imageNamed:@"iButton_01M_01"] forState:UIControlStateNormal];
    [upButton setImage:[UIImage imageNamed:@"iButton_01M_02"] forState:UIControlStateHighlighted];
    upButton.layer.cornerRadius = 20;
    upButton.layer.masksToBounds = YES;
    __weak typeof (scrollView)weakScrollView = scrollView;
    [[upButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakScrollView setContentOffset:CGPointMake(0, top) animated:YES];
    }];
    __weak typeof (upButton)weakUpButton = upButton;
    [[scrollView rac_valuesForKeyPath:@"contentOffset" observer:upButton] subscribeNext:^(id x) {
        if (scrollView.contentOffset.y >= YBLWindowHeight) {
            weakUpButton.hidden = NO;
        }else {
            weakUpButton.hidden = YES;
        }
    }];
    return upButton;
}


+ (instancetype)showInView:(UIView *)view center:(CGPoint)center block:(void(^)())block {
    YBLUpButton *upButton = [YBLUpButton buttonWithType:UIButtonTypeCustom];
    upButton.size = CGSizeMake(40, 40);
    upButton.center = center;
    [view addSubview:upButton];
    [upButton setImage:[UIImage imageNamed:@"iButton_03M_01"] forState:UIControlStateNormal];
    [upButton setImage:[UIImage imageNamed:@"iButton_03M_02"] forState:UIControlStateHighlighted];
    upButton.layer.cornerRadius = 20;
    upButton.layer.masksToBounds = YES;
    [[upButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (block) {
            block();
        }
    }];
    return upButton;
}





- (void)dealloc {
    NSLog(@"%@-dealloc",[self class]);
}

@end

//
//  YBLFilterBottomView.m
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLFilterBottomView.h"

@interface YBLFilterBottomView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *scrollView;


@end


@implementation YBLFilterBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = YBLColor(0, 0, 0, 0.5);
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
        __weak typeof (self)weakSelf = self;
        [[gesture rac_gestureSignal] subscribeNext:^(id x) {
            [weakSelf dismiss];
        }];
        [self addGestureRecognizer:gesture];
        
        
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor = YBLColor(250, 250, 250, 1.0);
        [self addSubview:self.bgView];
        self.bgView.frame = CGRectMake(0, 0, YBLWindowWidth, 150);
        
        
        self.dimissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dimissButton setTitleColor:YBLColor(70, 70, 70, 1.0) forState:UIControlStateNormal];
        [self.dimissButton setTitle:@"重置" forState:UIControlStateNormal];
        self.dimissButton.backgroundColor = [UIColor whiteColor];
        self.dimissButton.titleLabel.font = YBLFont(17);
        [self.bgView addSubview:self.dimissButton];
        [self.dimissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(@0);
            make.height.equalTo(@44);
            make.width.equalTo(@(YBLWindowWidth/2));
        }];
        [[self.dimissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf dismiss];
        }];
        
        
        self.submitBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.submitBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.submitBUtton.backgroundColor = YBLColor(240, 70, 73, 1.0);
        [self.submitBUtton setTitle:@"确定" forState:UIControlStateNormal];
        self.submitBUtton.titleLabel.font = YBLFont(17);
        [self.bgView addSubview:self.submitBUtton];
        [self.submitBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dimissButton.mas_right);
            make.bottom.equalTo(@0);
            make.height.equalTo(@44);
            make.width.equalTo(@(YBLWindowWidth/2));
        }];
        [[self.submitBUtton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf dismiss];
        }];
        
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 30)];
        [self.bgView addSubview:self.scrollView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = LINE_BASE_COLOR;
        [self.bgView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(self.submitBUtton.mas_top);
        }];
        
    }
    return self;
}



- (void)showWithFilterArray:(NSArray *)filterArray animation:(BOOL)animation  {
    self.backgroundColor = YBLColor(0, 0, 0, 0.5);
    CGFloat height = filterArray.count/2*50 + filterArray.count%2*50 + 44;
    if (height > YBLWindowHeight - kNavigationbarHeight - 90 - 150) {
        height = YBLWindowHeight - kNavigationbarHeight - 90 - 150;
    }
    self.bgView.height = height;
    self.scrollView.height = height-44;
    for (UIView *v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < filterArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int row = i/2;
        int col = i%2;
        CGFloat width = YBLWindowWidth / 2;
        button.frame = CGRectMake(col*width, row * 50, width, 50);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width-10, 50)];
        label.text = filterArray[i];
        label.font = YBLFont(15);
        label.textColor = YBLColor(70, 70, 70, 1.0);
        [button addSubview:label];
        [self.scrollView addSubview:button];
    }
    
    if (animation) {
        self.bgView.top = -height;
        [UIView animateWithDuration:0.5 animations:^{
            self.bgView.top = 0;
        }];
    }
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.top = -self.bgView.height;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (self.filterDismissBlock) {
            self.filterDismissBlock();
        }
        [self removeFromSuperview];
    }];
}


@end

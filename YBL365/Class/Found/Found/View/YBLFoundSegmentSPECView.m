//
//  YBLFoundSegmentSPECView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/4.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFoundSegmentSPECView.h"

static NSInteger button_tag1 = 131313;

static NSInteger button_tag2 = 331313;


@interface YBLFoundSegmentSPECView ()
{
    NSInteger currentTag1;
    NSInteger currentTag2;
}
@property (nonatomic, strong) UIView *specLineView;
@property (nonatomic, strong) UIScrollView *specView1;
@property (nonatomic, strong) UIScrollView *specView2;

@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;

@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *sureButton;

@end

@implementation YBLFoundSegmentSPECView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.height = 320;
        self.backgroundColor = [UIColor whiteColor];
        
        self.specView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 100)];
        self.specView1.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.specView1];
        
        self.specLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.specView1.bottom, self.specView1.width, 0.5)];
        self.specLineView.backgroundColor = YBLColor(230, 230, 230, 1);
        [self addSubview:self.specLineView];
        
        self.specView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.specLineView.bottom, self.width, 150)];
        self.specView2.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.specView2];
        
        CGFloat wi = self.width/4;
        CGFloat hi = 30;
        
        UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        resetButton.frame = CGRectMake(self.width/4-wi/2, self.height-hi*2, wi, hi);
        resetButton.layer.cornerRadius = 3;
        resetButton.layer.masksToBounds = YES;
        resetButton.layer.borderColor = YBLTextColor.CGColor;
        resetButton.layer.borderWidth = 0.5;
        [resetButton setTitle:@"重置" forState:UIControlStateNormal];
        resetButton.titleLabel.font = YBLFont(13);
        resetButton.tag = 0;
        [resetButton setTitleColor:YBLTextColor forState:UIControlStateNormal];
        [self addSubview:resetButton];
        [resetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.resetButton = resetButton;
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(self.width*3/4-wi/2, self.resetButton.top, wi, hi);
        sureButton.layer.cornerRadius = 3;
        sureButton.layer.masksToBounds = YES;
        sureButton.layer.borderColor = YBLThemeColor.CGColor;
        sureButton.layer.borderWidth = 0.5;
        sureButton.titleLabel.font = YBLFont(13);
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        sureButton.tag = 1;
        [sureButton setTitleColor:YBLThemeColor forState:UIControlStateNormal];
        [self addSubview:sureButton];
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.sureButton = sureButton;
    }
    return self;
}

- (void)updateSPECArray1:(NSMutableArray *)array1 array2:(NSMutableArray *)array2{
    
    
    if (![self.data1 isEqualToArray:[array1 mutableCopy]] || ![self.data2 isEqualToArray:[array2 mutableCopy]]) {
        
        if (self.specView1.subviews.count>1) {
            for (UIView *view in self.specView1.subviews) {
                [view removeFromSuperview];
            }
        }
        if (self.specView2.subviews.count>1) {
            for (UIButton *view in self.specView2.subviews) {
                [view removeFromSuperview];
            }
        }
        
        NSInteger lie = 4;
        CGFloat itemWi = (self.width-6*space)/lie;
        CGFloat itemHi = 30;
        /* 一级 */
        for (int i = 0; i < array1.count; i++) {
            int row = i/lie;
            int col = i%lie;
            
            CGRect frame = CGRectMake(1.5*space+col*(itemWi+space), 1.5*space+row*(itemHi+space), itemWi, itemHi);
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = frame;
            [button1 setTitle:array1[i] forState:UIControlStateNormal];
            [button1 setTitleColor:BlackTextColor forState:UIControlStateNormal];
            [button1 setTitleColor:YBLThemeColor forState:UIControlStateSelected];
            button1.titleLabel.font = YBLFont(13);
            button1.tag = button_tag1+i;
            button1.layer.cornerRadius = 3;
            button1.layer.masksToBounds = YES;
            button1.backgroundColor = [YBLColor(250, 250, 250, 1) colorWithAlphaComponent:1];
            [button1 addTarget:self action:@selector(buttin1click:) forControlEvents:UIControlEventTouchUpInside];
            [self.specView1 addSubview:button1];
            
        }
        NSInteger hiCount1 = array1.count/lie+1;
        CGFloat hei1 = hiCount1*itemHi+(2+hiCount1)*space;
        
        self.specView1.contentSize = CGSizeMake(self.width, hei1);
        self.specView1.height = 2*itemHi+(3)*space;
        self.specLineView.top = self.specView1.bottom;
        /* 二级 */
        for (int i = 0; i < array2.count; i++) {
            
            int row = i/lie;
            int col = i%lie;
            
            CGRect frame = CGRectMake(1.5*space+col*(itemWi+space), 1.5*space+row*(itemHi+space), itemWi, itemHi);
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            button2.frame = frame;
            [button2 setTitle:array2[i] forState:UIControlStateNormal];
            [button2 setTitleColor:BlackTextColor forState:UIControlStateNormal];
            [button2 setTitleColor:YBLThemeColor forState:UIControlStateSelected];
            button2.titleLabel.font = YBLFont(13);
            button2.backgroundColor = [YBLColor(250, 250, 250, 1) colorWithAlphaComponent:1];
            button2.layer.cornerRadius = 3;
            button2.layer.masksToBounds = YES;
            button2.tag = button_tag2+i;
            [self.specView2 addSubview:button2];
            [button2 addTarget:self action:@selector(buttin2click:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        self.specView2.top = self.specLineView.bottom;
        NSInteger hiCount2 = array2.count/lie+1;
        CGFloat hei2 = hiCount2*itemHi+(3+hiCount2)*space;
        self.specView2.contentSize = CGSizeMake(self.width, hei2);
        self.specView2.height = 3*itemHi+(4)*space;
        
        self.data1 = array1;
        self.data2 = array2;
        
        self.height = self.specView1.height + self.specView2.height+60;
        self.resetButton.top = self.height-45;
        self.sureButton.top  = self.resetButton.top;
    }

}

- (void)resetButtonClick:(UIButton *)btn{
 
    UIButton *currentButton1 = (UIButton *)[self viewWithTag:currentTag1+button_tag1];
    currentButton1.selected = NO;
    UIButton *currentButton2 = (UIButton *)[self viewWithTag:currentTag2+button_tag2];
    currentButton2.selected = NO;
    currentTag1 = -1;
    currentTag2 = -1;
}

- (void)sureButtonClick:(UIButton *)btn{
    
    
    BLOCK_EXEC(self.foundSegmentSPECViewSureBlock,@[self.data1[currentTag1],self.data2[currentTag2]]);
    
}


- (void)buttin1click:(UIButton *)btn{
    
    NSInteger index = btn.tag-button_tag1;
    btn.selected = YES;
    if (index != currentTag1) {
        UIButton *currentButton = (UIButton *)[self viewWithTag:currentTag1+button_tag1];
        currentButton.selected = NO;
        currentTag1 = index;
    }
    
    
}
- (void)buttin2click:(UIButton *)btn{
    
    NSInteger index = btn.tag-button_tag2;
    btn.selected = YES;
    if (index != currentTag2) {
        UIButton *currentButton = (UIButton *)[self viewWithTag:currentTag2+button_tag2];
        currentButton.selected = NO;
        currentTag2 = index;
    }
    
}
@end

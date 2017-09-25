//
//  YBLActionSheetView.m
//  YBL365
//
//  Created by 乔同新 on 2017/2/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLActionSheetView.h"

static const NSInteger button_tag = 2183213;

static YBLActionSheetView *actionSheetView = nil;

@interface YBLActionSheetView (){
    
    CGFloat contentHi;
}

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, weak  ) UIViewController *Vc;

@property (nonatomic, copy  ) ActionSheetClickBlock clickBlock;


@end

@implementation YBLActionSheetView


+ (void)showActionSheetWithTitles:(NSArray *)titlesArray
                      handleClick:(ActionSheetClickBlock)clickBlock{
    
    if (!actionSheetView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        actionSheetView = [[YBLActionSheetView alloc] initWithFrame:[keyWindow bounds]
                                                             titles:titlesArray
                                                        handleClick:clickBlock];
        [keyWindow addSubview:actionSheetView];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titlesArray
                  handleClick:(ActionSheetClickBlock)clickBlock{
    
    if (self = [super initWithFrame:frame]) {
        _titlesArray = titlesArray;
        _clickBlock = clickBlock;
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[self bounds]];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [bgView addGestureRecognizer:tap];
    self.bgView = bgView;

    CGFloat itemHi = 50;
    contentHi = itemHi+space/2+_titlesArray.count*itemHi;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, contentHi)];
    contentView.backgroundColor = YBLColor(240, 240, 240, 1);
    [self addSubview:contentView];
    self.contentView = contentView;
    
    NSInteger index = 0;
    for (NSString *title in _titlesArray) {
    
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = CGRectMake(0, index*itemHi, contentView.width, itemHi);
        [itemButton setTitle:title forState:UIControlStateNormal];
        itemButton.backgroundColor = [UIColor whiteColor];
        [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        itemButton.titleLabel.font = YBLFont(16);
        [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.tag = button_tag+index;
        [contentView addSubview:itemButton];
        
        if (index!=_titlesArray.count-1) {
            [itemButton addSubview:[YBLMethodTools addLineView:CGRectMake(0, itemButton.height-0.5, itemButton.width, 0.5)]];
        } else {
            UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancleButton.frame = CGRectMake(0, itemButton.bottom+space/2, itemButton.width, itemButton.height);
            [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
            cancleButton.backgroundColor = [UIColor whiteColor];
            [cancleButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
            cancleButton.titleLabel.font = YBLFont(16);
            [contentView addSubview:cancleButton];
            WEAK
            [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                STRONG
                [self dismiss];
            }];
        }
        
        index++;
    }
    
    [UIView animateWithDuration:.25f
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
                         self.contentView.top = self.height-contentHi;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)itemClick:(UIButton *)btn{
    
    BLOCK_EXEC(self.clickBlock,btn.tag-button_tag);
    
    [self dismiss];
}


- (void)dismiss{
    
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                         self.contentView.top = self.height;
                     }
                     completion:^(BOOL finished) {
                         if (actionSheetView) {
                             [actionSheetView removeFromSuperview];
                             actionSheetView = nil;
                         }
                     }];
}


@end

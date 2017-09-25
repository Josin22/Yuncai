//
//  YBLGoodsManageItemButton.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsManageItemButton.h"

static NSInteger const tag_itembutton = 5120;

@interface YBLGoodsManageItemButton ()

@end

@implementation YBLGoodsManageItemButton

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleArray = titleArray;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createUI{
    
    NSInteger index = 0;
    CGFloat buttonWi = self.width/_titleArray.count;
    for (NSString *title in _titleArray) {
        
        CGRect frame = CGRectMake(buttonWi*index, 0, buttonWi, self.height);
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = frame;
        [itemButton setTitle:title forState:UIControlStateNormal];
        [itemButton setTitleColor:BlackTextColor forState:UIControlStateNormal];
        itemButton.titleLabel.font = YBLFont(14);
        itemButton.tag = tag_itembutton+index;
        [itemButton addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        
        if (index!=_titleArray.count-1) {
            UIView *lineView = [YBLMethodTools addLineView:CGRectMake(itemButton.width-.5, 0, .5, itemButton.height/2)];
            lineView.centerY = itemButton.height/2;
            [itemButton addSubview:lineView];
        }
        
        index++;
    }
    UIView *topLineView = [YBLMethodTools addLineView:CGRectMake(0, 0, self.width, .5)];
    [self addSubview:topLineView];
    self.topLineView = topLineView;
    UIView *bottomLineView = [YBLMethodTools addLineView:CGRectMake(0, self.height-.5, self.width, .5)];
    [self addSubview:bottomLineView];
}

- (void)setTitleArray:(NSMutableArray *)titleArray{
    _titleArray = titleArray;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self createUI];
}

- (void)itemClick:(UIButton *)btn {
    
    NSInteger index=  btn.tag-tag_itembutton;
    
    BLOCK_EXEC(self.goodsManageItemButtonClickBlock,index)
}



@end

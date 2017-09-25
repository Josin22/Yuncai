//
//  YBLStoreGoodsHeaderView.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreGoodsHeaderView.h"

static NSInteger const BTN_TAG = 201;

@interface YBLStoreGoodsHeaderView ()
{
    NSInteger selectIndex;
}
@end

@implementation YBLStoreGoodsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    NSArray * titleArray = @[@"推荐",@"销量",@"新品",@"价格"];
    
    
    CGFloat buttonW = self.width/(titleArray.count+1);
    CGFloat buttonH = self.height;
    
    UIButton * categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryButton.frame = CGRectMake(self.width-buttonW, 0, buttonW, buttonH);
    [categoryButton setImage:[UIImage newImageWithNamed:@"store_list" size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [categoryButton setImage:[UIImage newImageWithNamed:@"store_list_change" size:CGSizeMake(30, 30)] forState:UIControlStateSelected];
    categoryButton.tag = BTN_TAG+4;
    [categoryButton addTarget:self action:@selector(classifyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:categoryButton];
    
    
    
    [titleArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:YBLThemeColor forState:UIControlStateSelected];
        button.titleLabel.font = YBLFont(15);
        button.tag = BTN_TAG+idx;
        button.frame = CGRectMake(buttonW*idx, 0, buttonW, buttonH);
        [button addTarget:self action:@selector(classifyButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (idx == 0) {
            button.selected = YES;
        }
    }];
    
    UIView * verticalLine = [[UIView alloc]initWithFrame:CGRectMake(self.width-buttonW, 0, 1, self.height)];
    verticalLine.backgroundColor = YBLLineColor;
    [self addSubview:verticalLine];
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
}

- (void)classifyButton:(UIButton *)button {
    NSInteger tag = button.tag - BTN_TAG;
    if (tag != selectIndex) {
        button.selected = !button.selected;
        if (tag != 4) {
            UIButton * agoButton = [self viewWithTag:BTN_TAG+selectIndex];
            agoButton.selected = NO;
            selectIndex = tag;
        }
        if (self.classifyButtonBlock) {
            self.classifyButtonBlock(tag,button.selected);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

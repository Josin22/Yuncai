//
//  YBLStoreDetailHeaderView.m
//  YBL365
//
//  Created by 陶 on 2016/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreDetailHeaderView.h"
#import "YBLStoreLogoView.h"

static NSInteger const BTN_TAG = 101;

@interface YBLStoreDetailHeaderView ()
@property (nonatomic, strong) YBLStoreLogoView * storeLogoView;

@end

@implementation YBLStoreDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createrUI];
        [self addButton];
    }
    return self;
}

- (void)createrUI {
    self.storeLogoView = [[YBLStoreLogoView alloc]initWithFrame:CGRectMake(0, 5, self.width, 60)];
    [self.storeLogoView changeFrame];
    [self addSubview:self.storeLogoView];
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, YBLWindowWidth, 1)];
    lineView.backgroundColor = YBLLineColor;
    [self addSubview:lineView];
    
}

- (void)addButton {
    NSArray * titleArray = [NSArray arrayWithObjects:@"全部商品",@"热销",@"上新", nil];
    
    CGFloat buttonW = YBLWindowWidth/titleArray.count;
    CGFloat buttonH = 49;
    
    [titleArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+buttonW*idx, self.height-50, buttonW, buttonH);
        button.tag = BTN_TAG + idx;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:[NSString stringWithFormat:@"50\n%@",titleArray[idx]] forState:UIControlStateNormal];
        button.titleLabel.font = YBLFont(14);
        [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
        
        if (idx != 0) {
            UIImageView * separate_line   = [[UIImageView alloc]initWithFrame:CGRectMake(1, 10, 1, buttonH-20)];
            separate_line.backgroundColor = YBLLineColor;
            [button addSubview:separate_line];
        }
        
    }];
}

- (void)buttonClick:(UIButton *)button {
    if (self.buttonSelectBlock) {
        self.buttonSelectBlock(button.tag - BTN_TAG);
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

//
//  YBLStoreBottomView.m
//  YBL365
//
//  Created by 陶 on 2016/12/21.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLStoreBottomView.h"

@implementation YBLStoreBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    NSArray * titleArr                    = [NSArray arrayWithObjects:@"店铺详情",@"热销分类",@"联系客服", nil];
    NSArray * imageArr                    = [NSArray arrayWithObjects:@"NewFinderNaviMessageIcon_20x20_",@"NewFinderNaviMessageIcon_20x20_", @"NewFinderNaviMessageIcon_20x20_",nil];
    CGFloat buttonW = YBLWindowWidth/titleArr.count;
    CGFloat buttonH = 50;
    [titleArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0+buttonW*idx, 0, buttonW, buttonH);
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        if (idx != 0) {
            UIImage *btnImage       = [UIImage newImageWithNamed:imageArr[idx] size:(CGSize){18,18}];
            [button setImage:btnImage forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(8, -10, 0, 0)];
            UIImageView * separate_line   = [[UIImageView alloc]initWithFrame:CGRectMake(1, 0, 1, buttonH)];
            separate_line.backgroundColor = YBLLineColor;
            [button addSubview:separate_line];
            
        }
        [button setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:YBLTextColor forState:UIControlStateNormal];
        button.titleLabel.font = YBLFont(15);
    }];
    
    UIImageView * top_line   = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, YBLWindowWidth, 0.5)];
    top_line.backgroundColor = YBLLineColor;
    [self addSubview:top_line];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

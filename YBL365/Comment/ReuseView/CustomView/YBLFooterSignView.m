//
//  YBLFooterSignView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/17.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLFooterSignView.h"

@interface YBLFooterSignView ()

@property (nonatomic, strong) UIImageView *footerImageView;

@end

@implementation YBLFooterSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.footerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cai_bottom_logo"]];
        self.footerImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.footerImageView.frame = CGRectMake(0, 0, 180, 40);
        self.footerImageView.centerX = self.width/2;
        self.footerImageView.top = 0;
        [self addSubview:self.footerImageView];
    }
    return self;
}

@end

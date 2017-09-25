//
//  YBLImageTextDetailPullView.m
//  YC168
//
//  Created by 乔同新 on 2017/6/22.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLImageTextDetailPullView.h"

@implementation YBLImageTextDetailPullView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, space/2, 165, 21)];
    imageView.image = [UIImage imageNamed:@"image_text"];
    imageView.centerX = self.width/2;
    [self addSubview:imageView];
}

@end

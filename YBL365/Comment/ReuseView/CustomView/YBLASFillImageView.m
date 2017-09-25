//
//  YBLASFillImageView.m
//  手机云采
//
//  Created by 乔同新 on 2017/8/3.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLASFillImageView.h"

@implementation YBLASFillImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end

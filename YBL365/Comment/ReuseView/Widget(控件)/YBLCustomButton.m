//
//  YBLCustomButton.m
//  YBL365
//
//  Created by 乔同新 on 16/12/23.
//  Copyright © 2016年 乔同新. All rights reserved.
//

#import "YBLCustomButton.h"

@implementation YBLCustomButton

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:!title?@"":title forState:state];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imageView.image!=nil || self.upImageView.image!=nil || self.bottomImageView.image!=nil) {
        self.titleLabel.centerX = self.width/2 - 6;
    }
    
    self.imageView.left = self.titleLabel.right + 3;
    
    if (self.upImageView) {
        self.upImageView.bottom = self.titleLabel.centerY-2;
        self.upImageView.left = self.titleLabel.right + 3;
    }
    if (self.bottomImageView) {
        self.bottomImageView.left = self.titleLabel.right + 3;
        self.bottomImageView.top = self.titleLabel.centerY+2;
    }
    
}

@end

//
//  YBLGoodsEvaluateImageCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLGoodsEvaluateImageCell.h"

@implementation YBLGoodsEvaluateImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createEvaluateImageViewUI];
    }
    return self;
}

- (void)createEvaluateImageViewUI{
    
    CGFloat wi = self.width;
    CGFloat space1 = 6;
    CGFloat imageWi = (wi-space1*2);
    
    self.picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(space1, space1, imageWi, imageWi)];
    self.picImageView.layer.borderColor = YBLLineColor.CGColor;
    self.picImageView.layer.borderWidth = 0.5;
    self.picImageView.layer.cornerRadius = 2;
    self.picImageView.layer.masksToBounds = YES;
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.picImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.picImageView];
}

@end

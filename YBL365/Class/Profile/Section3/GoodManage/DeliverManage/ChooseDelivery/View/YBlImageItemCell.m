//
//  YBlImageItemCell.m
//  YC168
//
//  Created by 乔同新 on 2017/4/15.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBlImageItemCell.h"

@interface YBlImageItemCell ()

@end

@implementation YBlImageItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.picImageView.backgroundColor = [UIColor whiteColor];
    
    self.itemButton = [[YBLButton alloc] initWithFrame:[self.picImageView frame]];
    [self.itemButton setImage:[UIImage imageNamed:@"fuxuan_normal"] forState:UIControlStateNormal];
    [self.itemButton setImage:[UIImage imageNamed:@"fuxuan_select"] forState:UIControlStateSelected];
    CGFloat imageWi = space+5;
    CGFloat imageSpace = 2;
    self.itemButton.imageRect = CGRectMake(self.picImageView.width-imageSpace-imageWi, imageSpace, imageWi, imageWi);
    [self.contentView addSubview:self.itemButton];
}

@end

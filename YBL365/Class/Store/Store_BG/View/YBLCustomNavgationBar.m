//
//  YBLCustomNavgationBar.m
//  YC168
//
//  Created by 乔同新 on 2017/5/20.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLCustomNavgationBar.h"

@implementation YBLCustomNavgationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = YBLColor(51, 51, 51, 1);
        
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(space, 0, 30, 30);
    self.backButton.bottom = self.height-space;
    [self.backButton setImage:[UIImage imageNamed:@"back_withe"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.backButton.right, self.backButton.top, self.width-self.backButton.right*2, self.backButton.height)];
    self.titleLabel.font = YBLFont(16);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

@end

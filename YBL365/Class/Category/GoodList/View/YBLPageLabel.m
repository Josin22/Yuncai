//
//  YBLPageLabel.m
//  YC168
//
//  Created by 乔同新 on 2017/5/10.
//  Copyright © 2017年 乔同新. All rights reserved.
//

#import "YBLPageLabel.h"

@implementation YBLPageLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    
    self.textColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
    
    self.font = YBLFont(12);
    
    self.textAlignment = NSTextAlignmentCenter;
    
}

@end
